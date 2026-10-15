#!/bin/bash

# This script starts the 'spacenavd' daemon of the 3Dconnexion devices if it is not already running.
# It is used as a ROS node to integrate 'spacenavd' startup into roslaunch, by 'spacenav_twist_bridge.launch' with 'start_spacenavd:=true'.

################################################################################

# Start the 'spacenavd' daemon if it is not already running:
if ! pgrep -x spacenavd > /dev/null 2>&1; then
  service spacenavd start
fi

# Keep the node alive until roslaunch shuts it down:
tail -f /dev/null
