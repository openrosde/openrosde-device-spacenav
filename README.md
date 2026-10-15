# OpenRoSDE Device: spacenav

`openrosde-device-spacenav` is the device extension of [OpenRoSDE](https://gitlab.com/coarobo/SDE) for the 3Dconnexion devices, such as the 3Dconnexion SpaceMouse, which packages the `spacenavd` daemon and the [`spacenav_node`](https://wiki.ros.org/spacenav_node) driver with a bridge from the SpaceMouse to the twist commands of MoveIt Servo.
It names no robot, so any platform or setup of OpenRoSDE that is driven with a SpaceMouse activates it.

[![Pipeline](https://img.shields.io/gitlab/pipeline-status/coarobo%2Fopenrosde%2Fopenrosde-device-spacenav?branch=main&logo=gitlab&label=Pipeline)](https://gitlab.com/coarobo/openrosde/openrosde-device-spacenav/-/pipelines)
[![ROS Noetic](https://img.shields.io/badge/ROS_Noetic-Framework-blue?logo=ros&logoColor=white)](http://wiki.ros.org/noetic)
[![Docker](https://img.shields.io/badge/Docker-Layer-blue?logo=docker&logoColor=white)](https://www.docker.com/)
[![OpenRoSDE](https://img.shields.io/badge/OpenRoSDE-Device-blue)](https://gitlab.com/coarobo/SDE)

[![License: Apache 2.0](https://img.shields.io/badge/License-Apache_2.0-green)](LICENSE)

## 📑 Content

[[_TOC_]]

## 🕹️ Supported Devices

| Device | Driver | Documentation |
| --- | --- | --- |
| 3Dconnexion devices that `spacenavd` supports, such as the 3Dconnexion SpaceMouse, wired or through the 3Dconnexion Universal Receiver (USB ID `256f:c652`) | `spacenavd` and [`spacenav_node`](https://wiki.ros.org/spacenav_node) | [docs/spacenav.md](docs/spacenav.md) |

## 🚀 Quick Start

1. Clone the device into `extensions/` of OpenRoSDE:

    ```shell
    git clone https://gitlab.com/coarobo/openrosde/openrosde-device-spacenav.git extensions/openrosde-device-spacenav
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

A setup usually activates the device in its template and starts its launch file from its own panes, as [`docs/extensions.md`](https://gitlab.com/coarobo/SDE/-/blob/dev/docs/extensions.md) of OpenRoSDE describes.

## 📁 Directory Structure

```
openrosde-device-spacenav/
  ci/check-in-container.bash                         # Checks that the CI of OpenRoSDE runs in the container of a setup.
  docker/spacenav-devel/Dockerfile                   # Docker layer: 'spacenavd' and 'spacenav_node'.
  docs/spacenav.md                                   # Documentation of the device.
  ros/spacenav_catkin_ws/src/
    openrosde_spacenav_launch/                       # Launch file, twist bridge, and 'spacenavd' start script.
```

## 📖 Documentation

| Document | Content |
| --- | --- |
| [docs/spacenav.md](docs/spacenav.md) | Hardware, USB 2 port, configuration, twist bridge, and troubleshooting |
| [openrosde_spacenav_launch](ros/spacenav_catkin_ws/src/openrosde_spacenav_launch/README.md) | Launch file and the arguments of the twist bridge |

## 🧪 Testing

The pipeline of this repository clones OpenRoSDE on `dev`, adds this device to the `ur5e` setup, builds its Docker layer and its workspace on the published `ur5e-devel:dev` image, and runs `ci/check-in-container.bash` in a container without network.
That check resolves the launch file with `roslaunch --files` and `--dump-params`, which start no node, and compiles the twist bridge.

## 🔗 External Resources

- OpenRoSDE: [https://gitlab.com/coarobo/SDE](https://gitlab.com/coarobo/SDE)
- Coarobo GK: [https://coarobo.com/](https://coarobo.com/)

## 🐛 Reporting Issues

Please report any issue using the GitLab issue tracker: [https://gitlab.com/coarobo/openrosde/openrosde-device-spacenav/-/issues](https://gitlab.com/coarobo/openrosde/openrosde-device-spacenav/-/issues).

## 🤝 Contributing

- This repository uses explicit commit messages following the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) specification.
- This project follows [Semantic Versioning](https://semver.org/) for releases.
- This project follows the conventions of OpenRoSDE, which its [`AGENTS.md`](https://gitlab.com/coarobo/SDE/-/blob/dev/AGENTS.md) describes.

## 👥 Authors & Acknowledgment

### 🔧 Maintainers

- **Lotfi El Hafi** (lotfi@coarobo.com)

### ✍️ Authors

- **Lotfi El Hafi**

## ⚖️ License

```
Copyright 2019 Coarobo GK

Licensed under the Apache License, Version 2.0
```

See [`LICENSE`](LICENSE) and [`NOTICE`](NOTICE) for details, including the MIT License of the earlier versions of these files in the SDE.

## 📜 Third-Party Software

| Component | Use | License |
| --- | --- | --- |
| [`spacenavd`](https://github.com/FreeSpacenav/spacenavd) 0.6 | Installed by the Docker layer from the Ubuntu repositories | GPL-3.0-or-later |
| [`spacenav_node`](https://github.com/ros-drivers/joystick_drivers/tree/main/spacenav_node) | Installed by the Docker layer from the ROS repositories | BSD License |
| [`libspnav`](https://github.com/FreeSpacenav/libspnav) | Installed with `spacenav_node` from the Ubuntu repositories | BSD 3-Clause License |

> [!NOTE]
> The Docker layer installs `spacenavd` under the GPL-3.0-or-later, so an image that contains it, such as one given to someone else, carries the obligations of the GPL, while this repository holds none of its code.
