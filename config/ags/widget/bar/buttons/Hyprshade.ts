import PanelButton from "../PanelButton"
import hyprshade from "service/hyprshade"

export default () => {
  return PanelButton({
    class_name: "hyprshade",
    child: Widget.Icon({
      icon_name: hyprshade.bind("shader").as((v) => {
        return v === "blue-light-filter" ? "night-light-symbolic" : "night-light-disabled-symbolic"
      }),
    }),
    on_clicked: () => hyprshade.toggle(),
  })
}
