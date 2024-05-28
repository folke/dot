import { launchApp, icon } from "lib/utils"
import icons from "lib/icons"
import options from "options"
import PanelButton from "../PanelButton"
import { Application } from "types/service/applications"

const hyprland = await Service.import("hyprland")
const apps = await Service.import("applications")
const { monochrome, exclusive, iconSize } = options.bar.taskbar
const { position } = options.bar

const focus = (address: string) => hyprland.messageAsync(`dispatch focuswindow address:${address}`)

const DummyItem = (address: string) =>
  Widget.Box({
    attribute: { address },
    visible: false,
  })

const AppItem = (address: string) => {
  const client = hyprland.getClient(address)
  if (!client || client.class === "") return DummyItem(address)

  let app: Application | undefined

  const filtered = apps.list.filter((app) => app.match(client.class))

  for (const a of filtered) {
    app ??= a
    if (a.icon_name === client.class) app = a
  }

  const title = Utils.watch(client.title, hyprland, () => hyprland.getClient(address)?.title || "")

  let icon_name = app?.icon_name ?? client.class
  icon_name = icon_name === "quake" ? "org.wezfurlong.wezterm" : icon_name

  const btn = PanelButton({
    class_name: "panel-button",
    tooltip_text: title,
    on_primary_click: () => focus(address),
    on_middle_click: () => app && launchApp(app),
    child: Widget.Box([
      Widget.Icon({
        size: iconSize.bind(),
        icon: monochrome
          .bind()
          .as((m) => icon(icon_name, icons.fallback.executable + (m ? "-symbolic" : ""))),
      }),
      Widget.Label({
        label: title,
        truncate: "end",
        maxWidthChars: 50,
        // visible: hyprland.active.client.address === address,
        setup: (w) =>
          w.hook(hyprland, () => {
            w.visible = hyprland.active.client.address === address
          }),
      }),
    ]),
  })

  return Widget.Box(
    {
      attribute: { address },
      visible: Utils.watch(true, [exclusive, hyprland], () => {
        return exclusive.value ? hyprland.active.workspace.id === client.workspace.id : true
      }),
    },
    Widget.Overlay({
      child: btn,
      pass_through: true,
      overlay: Widget.Box({
        className: "indicator",
        hpack: "start",
        vpack: position.bind().as((p) => (p === "top" ? "start" : "end")),
        setup: (w) =>
          w.hook(hyprland, () => {
            w.toggleClassName("active", hyprland.active.client.address === address)
          }),
      }),
    })
  )
}

function sortItems<T extends { attribute: { address: string } }>(arr: T[]) {
  return arr.sort(({ attribute: a }, { attribute: b }) => {
    const aclient = hyprland.getClient(a.address)!
    const bclient = hyprland.getClient(b.address)!
    return aclient.workspace.id - bclient.workspace.id
  })
}

export default () =>
  Widget.Box({
    class_name: "taskbar",
    children: sortItems(hyprland.clients.map((c) => AppItem(c.address))),
    setup: (w) =>
      w
        .hook(
          hyprland,
          (w, address?: string) => {
            if (typeof address === "string")
              w.children = w.children.filter((ch) => ch.attribute.address !== address)
          },
          "client-removed"
        )
        .hook(
          hyprland,
          (w, address?: string) => {
            if (typeof address === "string")
              w.children = sortItems([...w.children, AppItem(address)])
          },
          "client-added"
        )
        .hook(
          hyprland,
          (w, event?: string) => {
            if (event === "movewindow") w.children = sortItems(w.children)
          },
          "event"
        ),
  })
