# MECSEE129
Files for ME/CS/EE 129

# Getting Started
## Flash SD card using Balena
Put the boot_partition_files onto your SD  card (under  /boot/). Feel free to edit wpa_suppicant.conf to add your own networks

## Log into the Raspberry Pi
Eject the SD card, plug it into the RaspberryPi, and plug gthe RaspberryPi into power.  It will boot and, given the wpa_supplicant.conf file is correct, will connect to your network.  Log into your RaspberryPi with uname: pi, p/w: raspberry

## Change your password
First thing we should do is change the password for the Raspberry Pi.  There's a nice GUI tool for doing this which can be started using
```
sudo raspi-config
```
From here, you can navigate using the keys.  Firstly change the user password
```
1 Change User Password
```
and then change the hostname
```
2 Network Options > N1 Hostname
```
When you've updated the password and hostname, use the left arrow key and select Finish.

## Reboot your Pi
Now's a good time to reboot your Pi so that everything is updated correctly
```
sudo reboot
```

The reboot should be pretty quick so wait a minute, then log back in using ssh.


## Get ROS Setup
### Download git
git doesn't come installed by default so let's install it
```
sudo apt install -y git
```

### Install ROS and Arduino
Install ROS on a RaspberryPi 4 is a little difficult so this repo contains an install script.  Firstly, clone the git repo
```
git clone https://github.com/AndersonRayner/MECSEE129.git
```
and then run the installer script.  (The installer script isn't quite automatic yet so do some copy/pasting of the lines into a terminal)
```
cd ~/MECSEE129/install_scripts/
#./install_script.sh
```
Because the installer script doesn't work automatically (someone feel free to submit a PR to fix this @_@), the easiest way to get all the data across is to open the file on your laptop and copy/paste the sections across manually.  This process is rather time consuming and will take up to about 2 hours (most of this is ROS compile time).

### Create a Workspace
We now need to create a workspace where we can develop our ROS code
```
mkdir -p ~/catkin_ws/src/
cd ~/catkin_ws/
catkin init
```
This should initialise our workspace for us.

### Build the rosserial Package
```
cd src/
git clone https://github.com/ros-drivers/rosserial.git
```
Now we have rosserial, we should be able to build with catkin tools (don't forget to source the workspace after the build)
```
catkin build
source ~/catkin_ws/devel/setup.bash
```

## Set Up udev Rules
Follow the instructions in /udev_rules/README.md.  This will set up udev rules for you so that your Arduino has a predictable name on boot.  It will also fix many of the permissions issues.


## Set Up Arduino
### Flashing the Arduino
Arduino was installed for us by the install script.  Now we need to flash our Arduino with some test code.  Enter the arduino_example/ directory of the ME/CS/EE 129 repo
```
cd ~/MECSEE129/arduino_examples/
````
Automation is great so there's a script to automatically flash your arduino for you with the example code for a ROS publisher
```
./flash_arduino.sh
```

## Running Our First ROS Node
Now everything is set up, let's try it all out.  Log out of your RaspberryPi to make sure everything is sourced correctly for each of the terminals
```
logout
```
Log back in with  three different terminals and run the following

### Terminal 1
Terminal 1 will run roscore for us.  If our .bashrc was set correctly, we can just run
```
roscore
```

### Terminal 2
Terminal 2 is where we'll run our ROS node.  Change directory to catkin workspace
```
cd ~/catkin_ws/
```
We've previously built our workspace before so we just need to source it
```
source ~/catkin_ws/devel/setup.bash
```
And then we can run our ROS node (rosserial_arduino)
```
rosrun rosserial_arduino serial_node.py _port:=/dev/ttyArduino
```
If our Arduino is not device ttyACM0 we should change the above line accordingly

### Terminal 3
Terminal 3 is where we're going to rostopic echo what our node is publishing.  Once again, we need to source our catkin workspace
```
source ~/catkin_ws/devel/setup.bash
```
and then we can list what topics are being published
```
rostopic list
```
There should be a topic /did_it_work being published.  Let's see what it's saying
```
rostopic echo /did_it_work
```
