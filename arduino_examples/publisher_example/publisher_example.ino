// Use the following line if you have a Leonardo or MKR1000
//#define USE_USBCON

#include <ros.h>
#include <std_msgs/String.h>

ros::NodeHandle nh;

std_msgs::String str_msg;
ros::Publisher string_pub("did_it_work", &str_msg);

char msg_str[15] = "Great success!";

void setup()
{
  // Set up an LED so we can see what's happening
  pinMode(LED_BUILTIN, OUTPUT);

  // Initialise ROS
  nh.initNode();
  nh.advertise(string_pub);

}

void loop()
{
  // Fill the ROS message with data
  str_msg.data = msg_str;

  // Publish our ROS message
  string_pub.publish( &str_msg );
  nh.spinOnce();

  // Change the LED
  digitalWrite(LED_BUILTIN, !digitalRead(LED_BUILTIN));

  // Wait
  delay(250);

}
