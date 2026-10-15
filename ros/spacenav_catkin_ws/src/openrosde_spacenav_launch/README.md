# openrosde_spacenav_launch

The `openrosde_spacenav_launch` package bridges the 3Dconnexion devices, such as the 3Dconnexion SpaceMouse, to twist commands in OpenRoSDE, such as the input of MoveIt Servo, around the `spacenavd` daemon and the [`spacenav_node`](https://wiki.ros.org/spacenav_node) driver.

- Maintainer: Lotfi El Hafi ([lotfi@coarobo.com](mailto:lotfi@coarobo.com)).
- Author: Lotfi El Hafi ([lotfi@coarobo.com](mailto:lotfi@coarobo.com)).
- License: [Apache License 2.0](../../../../LICENSE).

## Launch Files

| Launch File | Description |
| --- | --- |
| `spacenav_twist_bridge.launch` | `spacenavd`, the `spacenav_node` driver, and the bridge from the SpaceMouse to a `geometry_msgs/TwistStamped` command |

## Twist Bridge

```shell
roslaunch openrosde_spacenav_launch spacenav_twist_bridge.launch
```

This launch file starts:

- The `spacenavd` daemon through `spacenavd_daemon.bash` when `start_spacenavd:=true`, unless it already runs.
- The upstream `spacenav_node` driver when `launch_spacenav_node:=true`, started with `respawn` so it reconnects once `spacenavd` is ready.
- The bridge node `spacenav_twist_bridge.py`.

The bridge subscribes to a `geometry_msgs/Twist` on `/spacenav/twist` and the button `sensor_msgs/Joy` on `/spacenav/joy`, applies a deadband, low-pass smoothing, and slew-rate limiting, and republishes a `geometry_msgs/TwistStamped` on `/servo_server/delta_twist_cmds`, the input of MoveIt Servo, stamped in `base_link`.

If `spacenav_node` is already running elsewhere, disable the local driver:

```shell
roslaunch openrosde_spacenav_launch spacenav_twist_bridge.launch launch_spacenav_node:=false
```

Usage notes:

- Hold Button 0 as the deadman and move the SpaceMouse to send twist commands.
- Button 1 is left free for another node, such as the gripper button of `openrosde-device-onrobot`, which reads the same `/spacenav/joy`.
- Set `reverse_for_front_view:=true` when operating from in front of the robot, which flips the planar translational and tilt axes so the hand-to-robot mapping feels like the default behind-the-robot setup.

Parameters:

- `start_spacenavd`: If `true`, starts the `spacenavd` daemon unless it already runs. Defaults to `true`.
- `launch_spacenav_node`: If `true`, starts the upstream `spacenav_node` driver. Set to `false` if `spacenav_node` is already running elsewhere. Defaults to `true`.
- `input_twist_topic`: Input topic from the 3Dconnexion SpaceMouse driver. Defaults to `/spacenav/twist`.
- `output_twist_topic`: Output topic of the `geometry_msgs/TwistStamped` commands. Defaults to `/servo_server/delta_twist_cmds`.
- `joy_topic`: Joystick button topic from the 3Dconnexion SpaceMouse driver. Defaults to `/spacenav/joy`.
- `frame_id`: Frame attached to the outgoing `TwistStamped`. Defaults to `base_link`.
- `require_enable_button`: If `true`, only forwards commands while the configured button is pressed. Defaults to `true`.
- `enable_button_index`: Button index used as deadman switch. Defaults to `0`.
- `publish_zero_when_disabled`: If `true`, publishes a zero twist when the deadman button is released. Defaults to `true`.
- `linear_x_scale`, `linear_y_scale`, `linear_z_scale`: Linear scale factors. Default to `1.0`.
- `angular_x_scale`, `angular_y_scale`, `angular_z_scale`: Angular scale factors. Default to `1.0`.
- `reverse_for_front_view`: If `true`, negates `linear_x_scale`, `linear_y_scale`, `angular_x_scale`, and `angular_y_scale`. Defaults to `false`.
- `publish_rate`: Fixed publish rate of the filtered twist stream in Hz. Defaults to `100.0`.
- `input_timeout`: Time in seconds before stale 3Dconnexion SpaceMouse input is treated as zero. Defaults to `0.1`.
- `linear_deadband`: Center deadband applied to translational axes before scaling. Defaults to `0.10`.
- `angular_deadband`: Center deadband applied to rotational axes before scaling. Defaults to `0.10`.
- `linear_smoothing_time_constant`: First-order filter time constant for translational axes. Defaults to `0.08`.
- `angular_smoothing_time_constant`: First-order filter time constant for rotational axes. Defaults to `0.08`.
- `max_linear_acceleration`: Per-axis translational slew-rate limit. Defaults to `4.0`.
- `max_angular_acceleration`: Per-axis rotational slew-rate limit. Defaults to `6.0`.

In the velocity mode of MoveIt Servo, the deadband, smoothing, and slew-rate parameters are the primary jitter controls.
