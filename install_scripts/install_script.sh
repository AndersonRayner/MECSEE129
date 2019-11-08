#!/bin/bash
# Script for installing ROS Melodic on Raspberry Pi 4
# Pretty much from https://www.seeedstudio.com/blog/2019/08/01/installing-ros-melodic-on-raspberry-pi-4-and-rplidar-a1m8/

# Add the repos for downloading ROS
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

sudo apt-get update

# Install dependencies
sudo apt install -y python-rosdep python-rosinstall-generator python-wstool python-rosinstall build-essential cmake tmux

# Initialise ROS
sudo rosdep init
rosdep update

mkdir ~/ros_catkin_ws
cd ~/ros_catkin_ws

# Code for installing lite version
# This is missing some dependencies for later so let's just go the full install for now
#rosinstall_generator ros_comm --rosdistro melodic --deps --wet-only --tar > melodic-ros_comm-wet.rosinstall
#wstool init -j8 src melodic-ros_comm-wet.rosinstall

# Code for installing desktop version
rosinstall_generator desktop --rosdistro melodic --deps --wet-only --tar > melodic-desktop-wet.rosinstall
wstool init -j8 src melodic-desktop-wet.rosinstall

# Install a compatible version of Assimp
mkdir -p ~/ros_catkin_ws/external_src
cd ~/ros_catkin_ws/external_src

wget http://sourceforge.net/projects/assimp/files/assimp-3.1/assimp-3.1.1_no_test_models.zip/download -O assimp-3.1.1_no_test_models.zip
unzip assimp-3.1.1_no_test_models.zip
cd assimp-3.1.1
cmake .
make
sudo make install

# Fix dependency for rviz
sudo apt install -y libogre-1.9-dev

# Install the remaining dependencies (this failed when running the system automatically)
cd ~/ros_catkin_ws/
rosdep install --from-paths src --ignore-src --rosdistro melodic -y

# Compile ROS
# If this fails, our system might be out of RAM.  If so, increase the swap space to 2 GB (google it)
sudo ~/ros_catkin_ws/src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release --install-space /opt/ros/melodic -j2

# Source the melodic install so we can use it
echo "" >> ~/.bashrc
echo "# Source ROS installation" >> ~/.bashrc
echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
source ~/.bashrc

# Install catkin tools
# At this point, we can check everything worked by running roscore
# If it goes, ctrl+c out of it and we can continue :)
roscore

# Install catkin tools and rosserial dependencies
sudo apt install -y python-pip
sudo pip install -U catkin_tools
sudo pip install pyserial

# Install Arduino
cd ~
wget https://downloads.arduino.cc/arduino-1.8.10-linuxarm.tar.xz
tar -xf arduino-1.8.10-linuxarm.tar.xz
cd arduino-1.8.10
sudo ./install.sh

arduino --install-library "Rosserial Arduino Library"

# Check Arduino worked
arduino --version
