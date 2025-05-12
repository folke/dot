import GLib from "gi://GLib?version=2.0";
import { execAsync } from "astal/process";
import { GObject, register } from "astal/gobject";

const MAX = 12;

export type CliphistItem = {
  id: number;
  content: string;
  contentType: string;
};

function bash(cmd: string) {
  return execAsync(["bash", "-c", cmd]);
}

async function query(filter: string) {
  const fzfArgs = filter === "" ? '-f ""' : `-f ${filter}`;

  return bash(`cliphist list | fzf ${fzfArgs} | head -n ${MAX}`)
    .then((str) =>
      Array.from(
        new Set(
          str
            .split("\n")
            .filter((i) => i)
            .map((x) => {
              // [[ binary data 63 Kib png 420x420 ]]
              const [id, content] = x.match(/(\d+)\s+(.*)/)!.slice(1);
              let contentType = "text";
              if (content.startsWith("[[")) {
                contentType =
                  content.match(
                    /\[\[\s+binary data.*(jpg|png|webp|jpeg|bmp)/,
                  )![1] ?? "binary";
              }
              return { id: Number(id), content, contentType };
            }),
        ).values(),
      ),
    )
    .catch((err) => {
      print(err);
      return [];
    });
}

function run(args: CliphistItem) {
  bash(`cliphist decode ${args.id} | wl-copy`).then((out) => {
    print(`:cliphist ${args.id}:`);
    print(out);
  });
}

async function getFile(item: CliphistItem) {
  const f = `/tmp/cliphist-${item.id}.${item.contentType}`;
  if (!GLib.file_test(f, GLib.FileTest.EXISTS))
    await bash(`cliphist decode ${item.id} > ${f}`);
  return f;
}

@register()
class Cliphist extends GObject.Object {
  constructor() {
    super();
  }
  getFile = getFile;
  query = query;
  run = run;
}

export default new Cliphist();
