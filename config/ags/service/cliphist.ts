import { bash, dependencies } from "lib/utils"
import icons from "lib/icons"
import options from "options"
import GLib from "gi://GLib"

const MAX = options.launcher.cliphist.max

export type CliphistItem = {
  id: number
  content: string
  contentType: string
}

async function query(filter: string) {
  if (!dependencies("fzf")) return [] as CliphistItem[]
  const fzfArgs = filter === "" ? '-f ""' : `-f ${filter}`

  return bash(`cliphist list | fzf ${fzfArgs} | head -n ${MAX}`)
    .then((str) =>
      Array.from(
        new Set(
          str
            .split("\n")
            .filter((i) => i)
            .map((x) => {
              // [[ binary data 63 Kib png 420x420 ]]
              const [id, content] = x.match(/(\d+)\s+(.*)/)!.slice(1)
              let contentType = "text"
              if (content.startsWith("[[")) {
                contentType =
                  content.match(/\[\[\s+binary data.*(jpg|png|webp|jpeg|bmp)/)![1] ?? "binary"
              }
              return { id: Number(id), content, contentType }
            })
        ).values()
      )
    )
    .catch((err) => {
      print(err)
      return []
    })
}

function run(args: CliphistItem) {
  bash(`cliphist decode ${args.id} | wl-copy`)
    .then((out) => {
      print(`:cliphist ${args.id}:`)
      print(out)
    })
    .catch((err) => {
      Utils.notify("Cliphist Error", err, icons.app.terminal)
    })
}

async function getFile(item: CliphistItem) {
  const f = `/tmp/cliphist-${item.id}.${item.contentType}`
  if (!GLib.file_test(f, GLib.FileTest.EXISTS)) await bash(`cliphist decode ${item.id} > ${f}`)
  return f
}

class Cliphist extends Service {
  static {
    Service.register(this)
  }
  constructor() {
    super()
  }
  getFile = getFile
  query = query
  run = run
}

export default new Cliphist()
