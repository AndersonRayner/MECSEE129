#!/bin/sh

echo "Starting ROS and pyserial ROS node using a (bad) tmux script"

SESSION=dev

# Create the new session
tmux new -s $SESSION -n "ROS" -d


# Split the windows up
tmux split-window -v -t $SESSION:0
tmux split-window -h -t $SESSION:0.1
tmux split-window -h -t $SESSION:0.0

# Send commands
# C-m is the equivalent of hitting enter
# Start htop
tmux send-keys -t $SESSION:0.0 'htop' C-m

# Start ROS
tmux send-keys -t $SESSION:0.1 'roscore' C-m
sleep 7

# Start the rosnode pyserial
tmux send-keys -t $SESSION:0.2 'cd ~/catkin_ws/' C-m
tmux send-keys -t $SESSION:0.2 'source ~/catkin_ws/devel/setup.bash' C-m
tmux send-keys -t $SESSION:0.2 'rosrun rosserial_arduino serial_node.py _port:=/dev/ttyArduino' C-m
sleep 5

# Put kill sess ready to go
tmux send-keys -t $SESSION:0.3 'rostopic list' C-m
#tmux send-keys -t $SESSION:0.3 'tmux kill-session'

# Open the session up
tmux -2 attach-session -t $SESSION:0

# Need it to run the command << source-file ~/.tmux.conf (from https://www.linode.com/docs/networking/ssh/persistent-terminal-sessions-with-tmux/)>>



# Kill the session
# tmux kill-session