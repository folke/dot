import { launchApp, icon } from "lib/utils"
import icons from "lib/icons"
import options from "options"
import PanelButton from "../PanelButton"
import { findApp } from "lib/utils"

const hyprland = await Service.import("hyprland")
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

  const app = findApp(client.class)

  const title = Utils.watch(client.title, hyprland, () => hyprland.getClient(address)?.title || "")

  const ico = Utils.merge([title, monochrome.bind()], (title, monochrome) => {
    let icon_name = app?.icon_name ?? client.class
    let icon_fallback = icons.fallback.executable

    if (app?.name === "WezTerm") {
      const cmd = title.split(" ")[1]
      if (cmd) {
        icon_fallback = icon_name
        icon_name = cmd
      }
    }

    return icon(
      icon_name + (monochrome ? "-symbolic" : ""),
      icon_fallback + (monochrome ? "-symbolic" : "")
    )
  })

  const btn = PanelButton({
    class_name: "panel-button",
    tooltip_text: title,
    on_primary_click: () => focus(address),
    on_middle_click: () => app && launchApp(app),
    child: Widget.Box([
      Widget.Icon({
        size: iconSize.bind(),
        icon: ico,
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
