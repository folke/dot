import cliphist, { CliphistItem } from "service/cliphist"
import Gtk from "gi://Gtk?version=3.0"

const iconVisible = Variable(false)

async function Item(item: CliphistItem) {
  const child: Gtk.Widget = item.contentType.match(/(png|jpg|jpeg|bmp|webp)/)
    ? Widget.Icon({
        class_name: "cliphist-image",
        icon: await cliphist.getFile(item),
        size: 80,
        hpack: "start",
        // css: `background-image: url('file://${cliphist.getFile(item)}');`,
      })
    : Widget.Label({
        label: item.content,
        hpack: "start",
        truncate: "end",
        maxWidthChars: 53,
      })
  return Widget.Box(
    {
      attribute: { item: item },
      vertical: true,
    },
    Widget.Separator(),
    Widget.Button({
      child,
      class_name: "cliphist-item",
      on_clicked: () => {
        cliphist.run(item)
        App.closeWindow("launcher")
      },
    })
  )
}

export function Icon() {
  const icon = Widget.Icon({
    icon: "edit-copy-symbolic",
    class_name: "spinner",
  })

  return Widget.Revealer({
    transition: "slide_left",
    child: icon,
    reveal_child: iconVisible.bind(),
  })
}

export function Cliphist() {
  const list = Widget.Box<Awaited<ReturnType<typeof Item>>>({
    vertical: true,
  })

  const revealer = Widget.Revealer({
    child: list,
  })

  async function filter(term: string) {
    term = term.trim()
    iconVisible.value = true
    const found = await cliphist.query(term)
    print(`found: ${found.length} for "${term}"`)
    list.children = await Promise.all(found.map(Item))
    revealer.reveal_child = true
  }
  function clear() {
    iconVisible.value = false
    list.children = []
    revealer.reveal_child = false
  }

  return Object.assign(revealer, {
    filter,
    clear,
    run: cliphist.run,
    runFirst: () => {
      const first = list.children[0]
      if (first) cliphist.run(first.attribute.item)
    },
  })
}
