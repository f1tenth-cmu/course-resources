#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root. Please use sudo."
	exit 1
fi

apt update && apt install locales
locale-gen en_US en_US.UTF-8
update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

locale

apt install -y software-properties-common
add-apt-repository -y universe

apt update && apt install curl -y
export ROS_APT_SOURCE_VERSION=$(curl -s https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest | grep -F "tag_name" | awk -F\" '{print $4}')
curl -L -o /tmp/ros2-apt-source.deb "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo ${UBUNTU_CODENAME:-${VERSION_CODENAME}})_all.deb"
dpkg -i /tmp/ros2-apt-source.deb

apt update && apt upgrade -y

apt install -y ros-humble-desktop
apt install -y ros-dev-tools

rosdep init
rosdep update

# below are two packages I was missing when I tried to build the f1tenth system - AL
apt install -y ros-humble-diagnostics-updater
apt install -y ros-humble-asio-cmake-module

echo 'source /opt/ros/humble/setup.bash' >> ~/.bashrc

echo "ROS HUMBLE INSTALL COMPLETE. verify with ros2 doctor."

echo "Installing Additional Tools"
apt install gh
apt install tmux

echo "Installation Complete!"