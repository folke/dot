/* eslint-disable @typescript-eslint/no-explicit-any */
import { type Application } from "types/service/applications"
import icons, { substitutes } from "./icons"
import Gtk from "gi://Gtk?version=3.0"
import Gdk from "gi://Gdk"
import GLib from "gi://GLib?version=2.0"
const apps = await Service.import("applications")

export type Binding<T> = import("types/service").Binding<any, any, T>

/**
 * @returns substitute icon || name || fallback icon
 */
export function icon(name: string | null, fallback = icons.missing) {
  if (!name) return fallback || ""

  if (GLib.file_test(name, GLib.FileTest.EXISTS)) return name

  const icon = substitutes[name] || name
  if (Utils.lookUpIcon(icon)) return icon

  print(`no icon substitute "${icon}" for "${name}", fallback: "${fallback}"`)
  // print stack trace
  return fallback
}

/**
 * @returns execAsync(["bash", "-c", cmd])
 */
export async function bash(strings: TemplateStringsArray | string, ...values: unknown[]) {
  const cmd =
    typeof strings === "string"
      ? strings
      : strings.flatMap((str, i) => str + `${values[i] ?? ""}`).join("")

  return Utils.execAsync(["bash", "-c", cmd]).catch((err) => {
    console.error(cmd, err)
    return ""
  })
}

/**
 * @returns execAsync(cmd)
 */
export async function sh(cmd: string | string[]) {
  return Utils.execAsync(cmd).catch((err) => {
    console.error(typeof cmd === "string" ? cmd : cmd.join(" "), err)
    return ""
  })
}

export function forMonitors(widget: (monitor: number) => Gtk.Window) {
  const n = Gdk.Display.get_default()?.get_n_monitors() || 1
  return range(n, 0).flatMap(widget)
}

/**
 * @returns [start...length]
 */
export function range(length: number, start = 1) {
  return Array.from({ length }, (_, i) => i + start)
}

/**
 * @returns true if all of the `bins` are found
 */
export function dependencies(...bins: string[]) {
  const missing = bins.filter((bin) =>
    Utils.exec({
      cmd: `which ${bin}`,
      out: () => false,
      err: () => true,
    })
  )

  if (missing.length > 0) {
    console.warn(Error(`missing dependencies: ${missing.join(", ")}`))
    Utils.notify(`missing dependencies: ${missing.join(", ")}`)
  }

  return missing.length === 0
}

/**
 * run app detached
 */
export function launchApp(app: Application) {
  const exe = app.executable
    .split(/\s+/)
    .filter((str) => !str.startsWith("%") && !str.startsWith("@"))
    .join(" ")

  bash(`${exe} &`)
  app.frequency += 1
}

/**
 * to use with drag and drop
 */
export function createSurfaceFromWidget(widget: Gtk.Widget) {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const cairo = imports.gi.cairo as any
  const alloc = widget.get_allocation()
  const surface = new cairo.ImageSurface(cairo.Format.ARGB32, alloc.width, alloc.height)
  const cr = new cairo.Context(surface)
  cr.setSourceRGBA(255, 255, 255, 0)
  cr.rectangle(0, 0, alloc.width, alloc.height)
  cr.fill()
  widget.draw(cr)
  return surface
}

export function findApp(klass: string) {
  // HACK: wezterm is quake
  if (klass === "quake") klass = "org.wezfurlong.wezterm"

  function filter(props: string[]) {
    return apps.list.filter((app) =>
      props.some((prop) => {
        const value = typeof app[prop] === "function" ? app[prop]() : app[prop]
        return value?.toLowerCase().includes(klass.toLowerCase())
      })
    )
  }

  let ret = filter(["icon_name", "desktop"])

  if (ret.length === 0) ret = filter(["name", "executable", "description"])

  if (ret.length > 1) {
    print(`multiple apps found for ${klass}`)
    ret.forEach((app) => {
      const props = [
        "name",
        "icon_name",
        "desktop",
        "wm_class",
        "description",
        "frequency",
        "executable",
      ]
      print(`  - name: ${app.name}`)
      for (const prop of props) print(`    * ${prop}: ${app[prop]}`)
    })
  }

  if (ret.length === 0) print(`no app found for ${klass}`)
  return ret[0]
}
