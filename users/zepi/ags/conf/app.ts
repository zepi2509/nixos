import { App } from "astal/gtk4"
import style from "./style.scss"
import Panel from "./widget/Panel"

const primaryMonitor = 1

App.start({
  css: style,
  main() {
    const monitor = App.get_monitors().at(primaryMonitor) ?? App.get_monitors().at(0)

    Panel(monitor!)
  },
})
