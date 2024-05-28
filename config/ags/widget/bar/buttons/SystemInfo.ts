import PanelButton from "../PanelButton"
import { df } from "lib/variables"
import { icon } from "lib/utils"

export default () => {
  return PanelButton({
    class_name: "system-info",
    visible: df.bind().as((c) => c > 80),
    child: Widget.Box([
      Widget.Icon({ icon: icon("drive-harddisk") }),
      Widget.Label({
        label: df.bind().as((c) => Math.round(c) + "%"),
      }),
    ]),
  })
}
