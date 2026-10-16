# OpenRoSDE Device spacenav

The spacenav device of [OpenRoSDE](https://github.com/openrosde/openrosde), read "Open Robotic SDE", the open-source Software Development Environment for collaborative robotics research maintained by [Coarobo GK](https://coarobo.com/).
It packages the `spacenavd` daemon and the [`spacenav_node`](https://wiki.ros.org/spacenav_node) driver for the 3Dconnexion devices, such as the 3Dconnexion SpaceMouse, with a bridge from the SpaceMouse to the twist commands of MoveIt Servo.
It is an extension that OpenRoSDE finds by name once it is cloned into `extensions/openrosde-device-spacenav/` of the core, activated by a setup or by `OPENROSDE_ROBOT_EXTENSIONS`, and it names no robot, so that any platform or setup that is driven with a SpaceMouse can use it.

[![Test with OpenRoSDE](https://github.com/openrosde/openrosde-device-spacenav/actions/workflows/test-with-openrosde.yml/badge.svg?branch=main)](https://github.com/openrosde/openrosde-device-spacenav/actions/workflows/test-with-openrosde.yml)
[![ROS Noetic](https://img.shields.io/badge/ROS_Noetic-Framework-blue?logo=ros&logoColor=white)](http://wiki.ros.org/noetic)
[![Docker](https://img.shields.io/badge/Docker-Layer-blue?logo=docker&logoColor=white)](https://www.docker.com/)
[![OpenRoSDE](https://img.shields.io/badge/OpenRoSDE-Device-blue)](https://github.com/openrosde/openrosde)

[![License: Apache 2.0](https://img.shields.io/badge/License-Apache_2.0-green)](LICENSE)

## 🕹️ Supported Devices

| Device                                                                                                                                                      | Driver                                                                | Documentation                        |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------- | ------------------------------------ |
| 3Dconnexion devices that `spacenavd` supports, such as the 3Dconnexion SpaceMouse, wired or through the 3Dconnexion Universal Receiver (USB ID `256f:c652`) | `spacenavd` and [`spacenav_node`](https://wiki.ros.org/spacenav_node) | [docs/spacenav.md](docs/spacenav.md) |

## 🚀 Quick Start

1. Clone the device into `extensions/` of OpenRoSDE:

    ```shell
    git clone https://github.com/openrosde/openrosde-device-spacenav.git extensions/openrosde-device-spacenav
    ```

2. Activate it in `.env.custom`:

    ```shell
    OPENROSDE_ROBOT_EXTENSIONS="openrosde-device-spacenav"
    ```

3. Build the images and the workspaces, which adds the Docker layer and the Catkin workspace of the device:

    ```shell
    bash ./BUILD-DOCKER-IMAGE.bash
    bash ./RUN-DOCKER-CONTAINER.bash
    openrosde-reset-catkin-workspaces
    ```

4. Plug the 3Dconnexion Universal Receiver into a USB 2 port, then start the bridge to MoveIt Servo in the container:

    ```shell
    roslaunch openrosde_spacenav_launch spacenav_twist_bridge.launch
    ```

A setup usually activates the device in its template and starts its launch file from its own panes, as [`docs/extensions.md`](https://github.com/openrosde/openrosde/blob/dev/docs/extensions.md) of OpenRoSDE describes.

## 📁 Directory Structure

| Path                                        | Content                                                                                                                      |
| ------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| `docker/spacenav-devel/Dockerfile`          | Docker layer `spacenav-devel`, built on the image below it: `spacenavd` and `spacenav_node`.                                 |
| `ros/spacenav_catkin_ws/`                   | Catkin workspace with `openrosde_spacenav_launch`: the launch file, the twist bridge, and the start script of `spacenavd`.   |
| `ci/check-in-container.bash`                | Check of the device, which the CI runs in the container of a setup with no network.                                          |
| `docs/spacenav.md`                          | Documentation of the device.                                                                                                 |
| `.github/workflows/test-with-openrosde.yml` | Workflow that tests this device with the core of OpenRoSDE, as [Continuous Integration](#-continuous-integration) describes. |
| `LICENSE`                                   | Text of the Apache License 2.0.                                                                                              |
| `NOTICE`                                    | MIT notice of the earlier code and notices of third-party software.                                                          |

The layout is the one of the core, which the [Extensions](https://github.com/openrosde/openrosde/blob/dev/docs/extensions.md) guide of OpenRoSDE describes.

## 📖 Documentation

| Document                                                                                      | Description                                                            |
| --------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------- |
| [3Dconnexion Devices](docs/spacenav.md)                                                       | Hardware, USB 2 port, configuration, twist bridge, and troubleshooting |
| [`openrosde_spacenav_launch`](ros/spacenav_catkin_ws/src/openrosde_spacenav_launch/README.md) | Launch file and the arguments of the twist bridge                      |
| [Basic Usage](https://github.com/openrosde/openrosde/blob/dev/docs/basic-usage.md)            | Full setup guide of the core of OpenRoSDE                              |
| [Extensions](https://github.com/openrosde/openrosde/blob/dev/docs/extensions.md)              | How OpenRoSDE finds the files of a cloned extension and tests it       |

## 🧪 Continuous Integration

`.github/workflows/test-with-openrosde.yml` runs on every push to `main`, on every pull request, and by hand (`workflow_dispatch`).
It calls the reusable workflow `extension.yml` of the core, `openrosde/openrosde/.github/workflows/extension.yml@dev` with `core-ref: dev`, which publishes nothing:

- It checks out the core on `dev` and clones the public extensions that `gitlab-ci/extensions.repos` of the core pins, then checks out the commit under test into `extensions/openrosde-device-spacenav/`, so that a pull request from a fork is tested too.
- No setup of the core lists this device, and the core does not pin devices in `gitlab-ci/extensions.repos`, so the workflow passes `extra-extensions: openrosde-device-spacenav`, which adds the device to every setup.
- It passes `setups: ur5e`, so that this device of ROS 1 is tested on the setup `ur5e` alone and never built on a setup of ROS 2.
- It builds the image of the UR5e locally on the published images of the core, then the Docker layer and the Catkin workspace of this device.
- It checks every launch entry point of the panes of the setup and runs `ci/check-in-container.bash` of this device in a container with no network.
- It also checks that no script of the CI can move a robot, and that the meshes of the workspaces convert into valid GLB files.

`ci/check-in-container.bash` resolves the launch file with `roslaunch --files` and `--dump-params`, which start no node, checks that the start script of `spacenavd` is an executable of the package, and compiles the twist bridge.

## 🔗 External Resources

- OpenRoSDE: [https://github.com/openrosde/openrosde](https://github.com/openrosde/openrosde)
- OpenRoSDE website: [https://openrosde.org/](https://openrosde.org/)
- Coarobo GK: [https://coarobo.com/](https://coarobo.com/)
- ROS `spacenav_node`: [https://wiki.ros.org/spacenav_node](https://wiki.ros.org/spacenav_node)

## 🐛 Reporting Issues

Please report any issue of this device using the GitHub issue tracker: [https://github.com/openrosde/openrosde-device-spacenav/issues](https://github.com/openrosde/openrosde-device-spacenav/issues).
Report any issue of the scripts, the images, or the CI of OpenRoSDE in the issue tracker of the core: [https://github.com/openrosde/openrosde/issues](https://github.com/openrosde/openrosde/issues).

## 🤝 Contributing

- This repository uses explicit commit messages following the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) specification.
- Open pull requests into `main`, where the workflow of [Continuous Integration](#-continuous-integration) tests them with the core.
- This repository follows the conventions of the core, which [https://github.com/openrosde/openrosde/blob/dev/AGENTS.md](https://github.com/openrosde/openrosde/blob/dev/AGENTS.md) and [https://github.com/openrosde/openrosde/blob/dev/CONTRIBUTING.md](https://github.com/openrosde/openrosde/blob/dev/CONTRIBUTING.md) describe.
- The contributing guide of the organization applies to this repository, which has none of its own: [https://github.com/openrosde/.github/blob/main/CONTRIBUTING.md](https://github.com/openrosde/.github/blob/main/CONTRIBUTING.md).
- Report a security vulnerability privately, as the security policy of the organization describes: [https://github.com/openrosde/.github/blob/main/SECURITY.md](https://github.com/openrosde/.github/blob/main/SECURITY.md).

## 👥 Authors & Acknowledgment

OpenRoSDE is maintained by [Coarobo GK](https://coarobo.com/).
Its maintainers, authors, and contributors are listed in the README of the core: [https://github.com/openrosde/openrosde#-authors--acknowledgment](https://github.com/openrosde/openrosde#-authors--acknowledgment).

## 🕰️ History

The launch file, the twist bridge, and the start script of `spacenavd` of this device come from the SDE, the predecessor of OpenRoSDE archived at [https://gitlab.com/coarobo/SDE](https://gitlab.com/coarobo/SDE), at commit [`041d164`](https://gitlab.com/coarobo/SDE/-/commit/041d164201db41ac35db5efd7889e6424a84deca) of `dev`, where their earlier history lives.
They were imported without their history, then moved into the Catkin workspace of this device and renamed after what they do rather than after a robot.

## ⚖️ License

```
Copyright 2019 Coarobo GK

Licensed under the Apache License, Version 2.0
```

See [`LICENSE`](LICENSE) for the license, and [`NOTICE`](NOTICE) for the MIT notice of the earlier code and the notices of third-party software.

## 📜 Third-Party Software

This repository holds no third-party code.
The Docker layer brings the third-party software below, each under its own license, as [`NOTICE`](NOTICE) records.

| Component                                                                                  | Source                                                      | License              |
| ------------------------------------------------------------------------------------------ | ----------------------------------------------------------- | -------------------- |
| [`spacenavd`](https://github.com/FreeSpacenav/spacenavd) 0.6                               | Installed by the Docker layer from the Ubuntu repositories  | GPL-3.0-or-later     |
| [`spacenav_node`](https://github.com/ros-drivers/joystick_drivers/tree/main/spacenav_node) | Installed by the Docker layer from the ROS repositories     | BSD License          |
| [`libspnav`](https://github.com/FreeSpacenav/libspnav)                                     | Installed with `spacenav_node` from the Ubuntu repositories | BSD 3-Clause License |

> [!NOTE]
> The Docker layer installs `spacenavd` under the GPL-3.0-or-later, so an image that contains it, such as one given to someone else, carries the obligations of the GPL, while this repository holds none of its code.
