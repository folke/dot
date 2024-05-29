import emoji, { EmojiItem } from "service/emoji"

const iconVisible = Variable(false)

function Item(e: EmojiItem) {
  return Widget.Box(
    {
      attribute: { emoji: e },
      // vertical: true,
    },
    // Widget.Separator(),
    Widget.Button({
      child: Widget.Label({
        label: e.str,
        hpack: "start",
      }),
      class_name: "emoji-item",
      on_clicked: () => {
        emoji.copy(e)
        App.closeWindow("launcher")
      },
    })
  )
}

export function Icon() {
  const icon = Widget.Icon({
    icon: "face-smile-symbolic",
    class_name: "spinner",
  })

  return Widget.Revealer({
    transition: "slide_left",
    child: icon,
    reveal_child: iconVisible.bind(),
  })
}

function chunk<T>(arr: T[], size: number) {
  return Array.from({ length: Math.ceil(arr.length / size) }, (v, i) =>
    arr.slice(i * size, i * size + size)
  )
}

type EmojiBox = ReturnType<typeof Item>
function grid(items: EmojiBox[], size = 11) {
  const chunks = chunk(items, size)
  return chunks.map((chunk) =>
    Widget.Box({
      children: chunk,
      vertical: false,
    })
  )
}

export function Emoji() {
  const list = Widget.Box<ReturnType<typeof grid>[0]>({
    vertical: true,
  })

  const revealer = Widget.Revealer({
    child: list,
  })

  async function filter(term: string) {
    term = term.trim()
    iconVisible.value = true
    const found = await emoji.query(term)
    const items = found.map(Item)
    list.children = grid(items)
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
    copy: emoji.copy,
    copyFirst: () => {
      const first = list.children[0]?.children[0]
      if (first) emoji.copy(first.attribute.emoji)
    },
  })
}
