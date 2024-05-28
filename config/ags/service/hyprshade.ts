import options from "options"

const { interval } = options.hyprshade

class Hyprshade extends Service {
  static {
    Service.register(
      this,
      {},
      {
        shader: ["string"],
      }
    )
  }

  #shader: string = ""
  get shader() {
    return this.#shader
  }

  async #update() {
    this.#shader = Utils.exec("hyprshade current")
    this.changed("shader")
  }

  async toggle() {
    Utils.exec("hyprshade toggle blue-light-filter")
    this.#update()
  }

  get isNight() {
    return this.#shader === "blue-light-filter"
  }

  constructor() {
    super()

    Utils.interval(interval.value, () => {
      this.#update()
    })
  }
}

export default new Hyprshade()
