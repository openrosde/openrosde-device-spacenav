# General guidelines and recommendations for writing 'Dockerfile':
# https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/

################################################################################

# Inherit from the image below this layer, given by 'BUILD-DOCKER-IMAGE.bash' of OpenRoSDE.
ARG OPENROSDE_PARENT_IMAGE
FROM ${OPENROSDE_PARENT_IMAGE}

################################################################################

# Install the 3Dconnexion SpaceNavigator/SpaceMouse controllers ROS dependencies.
# https://wiki.ros.org/spacenav_node

# Gather the SpaceNavigator/SpaceMouse package dependencies from the Ubuntu repositories.
RUN apt-get update && apt-get install -y --no-install-recommends \
  spacenavd \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# Gather the SpaceNavigator/SpaceMouse package dependencies from the ROS repositories.
RUN apt-get update && apt-get install -y --no-install-recommends \
  ros-noetic-spacenav-node \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

################################################################################

# Embed the commit hash of this Dockerfile for traceability.
ARG OPENROSDE_DOCKERFILE_COMMIT_SHORT_SHA
