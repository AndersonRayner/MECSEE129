# MECSEE129
Files and instructions for ME/CS/EE 129

# Getting Started
## Install the Raspberry Pi into the Case
Electronics like the Raspberry Pi are somewhat delicate so it's always a good idea to put them into a case.  Raspberry Pi 4s also have an overheating problem so this case comes with a fan to keep the Pi cool.  The fan cables need to be connected to 
```
Red: 5V
Black: GND
```
as per the pinout given at
```
https://www.jameco.com/Jameco/workshop/circuitnotes/raspberry_pi_circuit_note_fig2.jpg
```
The fan should be blowing into the case.  Also remember to attached the heatsinks to the three largest parts if the Raspberry Pi.

## Flash SD card using Balena
Download the Raspian Buster Lite image from 
```
https://downloads.raspberrypi.org/raspbian_lite_latest
```
and Balena Etcher from 
```
https://www.balena.io/etcher/
```
Start Balena Etcher, follow the prompts and flash the Raspian image onto the SD card.  Once finished, remove and re-insert the SD card into your computer, and put the /boot_partition_files/ onto your SD card (under  /boot/). Feel free to edit wpa_suppicant.conf to add your own networks.

## Log into the Raspberry Pi
### First Power On
Eject the SD card from the computer, plug it into the Raspberry Pi, and plug the Raspberry Pi into power.  It will boot and, given the wpa_supplicant.conf file is correct, will connect to your network. 

### Finding the Raspberry Pi on the Network
The Raspberry Pi is assigned a random IP address by the router's DHCP server.  To find the IP address of the Raspberry Pi, open a web browser and navigate to 192.168.1.1.  The p/w of the router is MECSEE129.  From there, navigate to wireless clients and look for the device named raspberrypi.

Alternativly, if your computer has a zeroconf service, you can access your Raspberry Pi with the host name raspberrypi.local.

### Logging In
Log into the Raspberry Pi over ssh with the credentials
```
uname: pi
p/w: raspberry
```
Linux and Mac users should be able to open a terminal and type
```
ssh pi@192.168.1.XXX
```
where XXX is the last three numbers of the Raspberry Pi's IP address.

Windows doesn't have out-of-the-box ssh support so you need PuTTY.  PuTTY can be downloaded from 
```
https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html
```
PuTTY automatically puts the ssh in so only 
```
pi@192.168.1.XXX
```
is required.

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
Installing ROS on a Raspberry Pi 4 is a little difficult so this repo contains an install script.  Firstly, clone the git repo
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
Now everything is set up, let's try it all out.  Log out of your Raspberry Pi to make sure everything is sourced correctly for each of the terminals
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
