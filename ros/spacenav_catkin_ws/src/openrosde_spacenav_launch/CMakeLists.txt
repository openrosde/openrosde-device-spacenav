cmake_minimum_required(VERSION 2.8.3)
project(openrosde_spacenav_launch)

find_package(catkin REQUIRED)

catkin_package()

catkin_install_python(
  PROGRAMS
    scripts/spacenav_twist_bridge.py
  DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
)

# Copy the 'spacenavd' startup script to devel space for roslaunch node resolution.
file(COPY scripts/spacenavd_daemon.bash
  DESTINATION ${CATKIN_DEVEL_PREFIX}/lib/${PROJECT_NAME}
  FILE_PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)

# Install the 'spacenavd' startup script to the package bin destination.
install(PROGRAMS scripts/spacenavd_daemon.bash
  DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION})

# Install the launch files.
install(DIRECTORY launch
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION})
