# Creating udev Rules
## Identifying the Device
In order to create the udev rules, we need to know how Linux can identify it.  To work out the properties of the USB device use
```
udevadm info -a -p /sys/class/tty/(PORT)
```
In our case, this will (PORT) will most likely be something like ttyACM0

### Notes
* Have to use subsystem tty if you want to talk to it as a tty
* Can use product or vendor or something to identify the device
* Can check the existing permissions with << stat --format '%a' /dev/(PORT) >>

## Creating the udev Rule
Create your udev file by first opening the file
```
sudo nano /etc/udev/rules.d/99-arduino.rules
```
The code should look something similar to
```
# udev Rules for the Arduino Boards
# ---------------------------------

# Fix the owners of all the USB serial devices
KERNEL=="ttyUSB[0-9]*",MODE="0666"
KERNEL=="ttyACM[0-9]*",MODE="0666"

# Arduino MEGA 2560
SUBSYSTEM=="tty", ATTRS{manufacturer}=="Arduino (www.arduino.cc)", ATTRS{serial}=="XXXXXXXX", SYMLINK+="ttyArduino"

```
Press Ctrl+o then Enter to save the file, then Ctrl+x to exit.  As part of this code, we've also fixed the permissions for USB and ACM devices so that anyone can access them.  Note here that you'll have to put the serial number for your Arduino in place of the XXXXXXXX.

## Reload the udev rules
We can either get the new rules to apply by unplugging and replugging our device in, or simply by reloading the rules
```
sudo udevadm control --reload-rules
sudo udevadm trigger
```

You can then check it worked by
```
ls /dev/tty*
```
