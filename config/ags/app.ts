import { App } from "astal/gtk3";
import style from "./style.scss";
import AppLauncher from "./widget/AppLauncher";

App.start({
  instanceName: "main",
  css: style,
  main() {
    AppLauncher().hide();
  },
});
