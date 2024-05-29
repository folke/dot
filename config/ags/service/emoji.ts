export type EmojiItem = {
  str: string
  name: string
  slug: string
  group: string
}

let emoji: EmojiItem[]

async function reload() {
  const data = Utils.readFile(App.configDir + "/emoji.json")
  const emojis = JSON.parse(data) as { [str: string]: EmojiItem }
  return Object.entries(emojis).map(([str, data]) => {
    data.str = str
    return data
  })
}

async function get() {
  return (emoji ??= await reload())
}

async function query(filter: string) {
  return (await get())
    .filter((e) => {
      return e.name.includes(filter) || e.slug.includes(filter) || e.group.includes(filter)
    })
    .slice(0, 44)
}

function copy(args: EmojiItem) {
  Utils.exec(["wl-copy", args.str])
}

class Emoji extends Service {
  static {
    Service.register(this)
  }
  constructor() {
    super()
    reload()
  }
  query = query
  copy = copy
}

export default new Emoji()
