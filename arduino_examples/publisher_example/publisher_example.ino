/*
 * rosserial Publisher Example
 * Prints "hello world!"
 */

// Use the following line if you have a Leonardo or MKR1000
//#define USE_USBCON

#include <ros.h>
#include <std_msgs/String.h>

ros::NodeHandle nh;

std_msgs::String str_msg;
ros::Publisher chatter("chatter", &str_msg);

char hello[15] = "Great success!";

void setup()
{
  // Set up an LED so we can see what's happening
  pinMode(LED_BUILTIN, OUTPUT);

  // Initialise ROS
  nh.initNode();
  nh.advertise(chatter);
}

void loop()
{
  // Publish our ROS message
  chatter.publish( &str_msg );
  nh.spinOnce();

  // Change the LED
  digitalWrite(LED_BUILTIN, !digitalRead(LED_BUILTIN));

  // Wait
  delay(250);
}
