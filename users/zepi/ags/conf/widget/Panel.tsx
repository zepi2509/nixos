import { App, Astal, Gtk, Gdk } from "astal/gtk4"
import { GLib, Variable, bind } from "astal"
import Battery from "gi://AstalBattery"
import Wp from "gi://AstalWp"




function Panel({ gdkmonitor, format = "%H:%M" }: { gdkmonitor: Gdk.Monitor; format?: string }): Gtk.Widget {
  const { TOP, LEFT, BOTTOM } = Astal.WindowAnchor

  const time = Variable(GLib.DateTime.new_now_local()).poll(1000, () =>
    GLib.DateTime.new_now_local(),
  )

  const battery = Battery.get_default()

  const subpanel = Variable(<box />)
  const audioPanel = <AudioPanel />
  const networkPanel = <NetworkPanel />
  const bluetoothPanel = <BluetoothPanel />

  return (
    <window
      name="Panel"
      cssName="Panel"
      exclusivity={Astal.Exclusivity.IGNORE}
      gdkmonitor={gdkmonitor}
      anchor={TOP | LEFT | BOTTOM}
      application={App}>
      <box
        cssName="container">
        <centerbox
          cssName="centerbox"
          orientation={Gtk.Orientation.VERTICAL}
          vexpand>
          <box
            orientation={Gtk.Orientation.VERTICAL}>
            <label>System</label>
            <button
              onClicked={() => (subpanel.get() === audioPanel)
                ? subpanel.set(<box />)
                : subpanel.set(audioPanel)
              }
              hexpand>
              Sound
            </button>
            <button
              onClicked={() => (subpanel.get() === networkPanel)
                ? subpanel.set(<box />)
                : subpanel.set(networkPanel)
              }
              hexpand>
              Network
            </button>
            <button
              onClicked={() => (subpanel.get() === bluetoothPanel)
                ? subpanel.set(<box />)
                : subpanel.set(bluetoothPanel)
              }
              hexpand>
              Bluetooth
            </button>
          </box>
          <box />
          <centerbox>
            <label label={time((t) => t.format(format)!)} />
            <box />
            <label label={bind(battery, "percentage").as(
              (p) => `${Math.floor(p * 100)}%`
            )} />
          </centerbox>
        </centerbox>
        {subpanel((panel) => panel)}
      </box >
    </window >
  )
}

function AudioPanel(): Gtk.Widget {
  const audio = Wp.get_default()

  return (
    <centerbox
      cssName="AudioPanel"
      cssClasses={["Subpanel"]}>
      <centerbox
        orientation={Gtk.Orientation.VERTICAL}
        vexpand>
        <label label="Sound" />
      </centerbox>
    </centerbox>
  )
}

function NetworkPanel(): Gtk.Widget {
  return (
    <centerbox
      cssName="NetworkPanel"
      cssClasses={["Subpanel"]}>
      <centerbox
        orientation={Gtk.Orientation.VERTICAL}
        vexpand>
        <label label="Network" />
      </centerbox>
    </centerbox>
  )
}

function BluetoothPanel(): Gtk.Widget {
  return (
    <centerbox
      cssName="BluetoothPanel"
      cssClasses={["Subpanel"]}>
      <centerbox
        orientation={Gtk.Orientation.VERTICAL}
        vexpand>
        <label label="Bluetooth" />
      </centerbox>
    </centerbox>
  )
}

export default function (gdkmonitor: Gdk.Monitor) {
  <Panel gdkmonitor={gdkmonitor} />
}
