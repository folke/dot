import { clock } from "lib/variables"
import PanelButton from "../PanelButton"
import options from "options"
import icons from "lib/icons"

const { format, action } = options.bar.date
const time = Utils.derive([clock, format], (c, f) => c.format(f) || "")

export default () =>
  PanelButton({
    window: "datemenu",
    on_clicked: action.bind(),
    child: Widget.Box([
      Widget.Icon(icons.app.calendar),
      Widget.Label({
        justification: "center",
        label: time.bind(),
      }),
    ]),
  })
