# 3Dconnexion Devices

Documentation of the spacenav device of OpenRoSDE, which packages the `spacenavd` daemon and the [`spacenav_node`](https://wiki.ros.org/spacenav_node) driver for the 3Dconnexion devices, such as the 3Dconnexion SpaceMouse, with a bridge from the SpaceMouse to the twist commands of MoveIt Servo.

## 🔗 External Resources

- 3Dconnexion SpaceMouse: [https://3dconnexion.com/](https://3dconnexion.com/)
- `spacenavd`: [https://github.com/FreeSpacenav/spacenavd](https://github.com/FreeSpacenav/spacenavd)
- ROS `spacenav_node`: [https://wiki.ros.org/spacenav_node](https://wiki.ros.org/spacenav_node)
- `spacenav_node` source: [https://github.com/ros-drivers/joystick_drivers/tree/main/spacenav_node](https://github.com/ros-drivers/joystick_drivers/tree/main/spacenav_node)

## 🔩 Hardware Overview

The device supports every 3Dconnexion device that `spacenavd` supports, wired or wireless.
A wireless 3Dconnexion SpaceMouse connects to the Ubuntu development machine through a 3Dconnexion Universal Receiver, which `lsusb` lists with the USB ID `256f:c652`:

```shell
lsusb -d 256f:c652
```

> [!WARNING]
> Plug the 3Dconnexion Universal Receiver into a USB 2 port of the Ubuntu development machine, never into a USB 3 port (usually blue).
> On a USB 3 port, the receiver still shows up in `lsusb` and `spacenavd` still opens it, but no motion or button event ever reaches it, so the 3Dconnexion SpaceMouse silently does nothing.

## ⚙️ Configuration

Activate the device in `.env.custom`, or in the template of a setup, beside the other extensions:

```shell
OPENROSDE_ROBOT_EXTENSIONS="openrosde-device-spacenav"
```

The Docker layer of the device installs `spacenavd` from the Ubuntu repositories and `ros-noetic-spacenav-node` from the ROS repositories.
The container of OpenRoSDE already sees every USB device of the Ubuntu development machine, so the device needs no Docker Compose overlay.

## 🕹️ Twist Bridge

To start `spacenavd`, the `spacenav_node` driver, and the bridge to MoveIt Servo:

```shell
roslaunch openrosde_spacenav_launch spacenav_twist_bridge.launch
```

- `spacenavd` starts inside the container through its init script, unless it already runs, and `start_spacenavd:=false` leaves it out.
- `spacenav_node` publishes the motion of the SpaceMouse on `/spacenav/twist` and its buttons on `/spacenav/joy`, and restarts until `spacenavd` accepts its connection.
- The bridge forwards the motion only while Button 0 is held, smooths it, and publishes a `geometry_msgs/TwistStamped` stamped in `base_link` on `/servo_server/delta_twist_cmds`, the input of MoveIt Servo.
- `reverse_for_front_view:=true` flips the planar translational and tilt axes, for an operator in front of the robot.

Button 1 is left free, so a setup can give it to a gripper, such as with `onrobot_rg_joy_button.launch joy_topic:=/spacenav/joy` of `openrosde-device-onrobot`.
See the README of [`openrosde_spacenav_launch`](../ros/spacenav_catkin_ws/src/openrosde_spacenav_launch/README.md) for every argument.

> [!IMPORTANT]
> The bridge drives the robot while Button 0 is held, so always have the emergency stop button of the robot in your other hand.

## 🩺 Troubleshooting

- Check that the receiver is plugged in a USB 2 port and listed by `lsusb -d 256f:c652`.
- Check that `spacenavd` runs in the container with `pgrep -x spacenavd`.
- Check that motion reaches ROS with `rostopic echo /spacenav/twist` while moving the SpaceMouse.

## 📋 Launch Files Reference

The launch files of the device are in the package `openrosde_spacenav_launch`:

| Launch File | Description |
| --- | --- |
| `spacenav_twist_bridge.launch` | `spacenavd`, the `spacenav_node` driver, and the bridge from the SpaceMouse to MoveIt Servo |

A device ships no `tmux` panes, so the setup that activates it starts this launch file from its own panes.
