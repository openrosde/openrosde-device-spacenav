#!/bin/bash

# This script checks the spacenav device inside the container of a setup that activates it, as part of the CI of OpenRoSDE.
# 'gitlab-ci/run-extension-checks.bash' of OpenRoSDE runs it once the Catkin workspaces of the setup are built and sourced, in a container without any network.
# It resolves every launch file of 'openrosde_spacenav_launch' with 'roslaunch --files' and '--dump-params', which start no node, checks that the start script of 'spacenavd' is executable where roslaunch looks for it, and compiles the twist bridge.
#
# Usage: bash ./ci/check-in-container.bash <robot-setup>
#
# <robot-setup>: The setup whose container runs the check, such as 'ur5e'.

################################################################################

# Remember the checks that fail, so that every check runs before the script fails.
OPENROSDE_SPACENAV_FAILED_CHECKS=""

# Record a failed check by its name.
function openrosde-spacenav-fail-check () {
  echo "Error: $1"
  OPENROSDE_SPACENAV_FAILED_CHECKS="${OPENROSDE_SPACENAV_FAILED_CHECKS}"$'\n'"  - $1"
}

# Find the package of the device in the sourced workspaces.
OPENROSDE_SPACENAV_LAUNCH_DIR="$(rospack find openrosde_spacenav_launch)"
if [ -z "${OPENROSDE_SPACENAV_LAUNCH_DIR}" ]; then
  echo "Error: The package 'openrosde_spacenav_launch' is not in the sourced workspaces of the setup '$1'."
  exit 1
fi
echo "Checking the spacenav device in the setup '$1'."

################################################################################

# Resolve every launch file and dump its parameters, which starts no node and needs no ROS master, with and without the reversed axes.
for OPENROSDE_SPACENAV_LAUNCH_FILE in "${OPENROSDE_SPACENAV_LAUNCH_DIR}"/launch/*.launch; do
  if roslaunch --files "${OPENROSDE_SPACENAV_LAUNCH_FILE}" > /dev/null \
    && roslaunch --dump-params "${OPENROSDE_SPACENAV_LAUNCH_FILE}" > /dev/null \
    && roslaunch --dump-params "${OPENROSDE_SPACENAV_LAUNCH_FILE}" reverse_for_front_view:=true > /dev/null; then
    echo "Resolved '$(basename "${OPENROSDE_SPACENAV_LAUNCH_FILE}")'."
  else
    openrosde-spacenav-fail-check "'$(basename "${OPENROSDE_SPACENAV_LAUNCH_FILE}")' does not resolve its files or its parameters."
  fi
done

# Check that the start script of 'spacenavd' is an executable of the package, which 'catkin_find' lists as roslaunch finds it.
if catkin_find --first-only openrosde_spacenav_launch spacenavd_daemon.bash | grep -q .; then
  echo "Found the executable 'spacenavd_daemon.bash' of 'openrosde_spacenav_launch'."
else
  openrosde-spacenav-fail-check "'spacenavd_daemon.bash' is not an executable of 'openrosde_spacenav_launch' in the built workspace."
fi

# Compile every Python node, into a temporary folder rather than next to the sources.
OPENROSDE_SPACENAV_PYCACHE_DIR="$(mktemp -d)"
for OPENROSDE_SPACENAV_SCRIPT_FILE in "${OPENROSDE_SPACENAV_LAUNCH_DIR}"/scripts/*.py; do
  if ! PYTHONPYCACHEPREFIX="${OPENROSDE_SPACENAV_PYCACHE_DIR}" python3 -m py_compile "${OPENROSDE_SPACENAV_SCRIPT_FILE}"; then
    openrosde-spacenav-fail-check "'$(basename "${OPENROSDE_SPACENAV_SCRIPT_FILE}")' does not compile."
  fi
done
rm -rf "${OPENROSDE_SPACENAV_PYCACHE_DIR}"

################################################################################

# Report the result, and fail if any check failed.
if [ -n "${OPENROSDE_SPACENAV_FAILED_CHECKS}" ]; then
  echo "These checks of the spacenav device failed:${OPENROSDE_SPACENAV_FAILED_CHECKS}"
  exit 1
fi
echo "Every check of the spacenav device passed."
