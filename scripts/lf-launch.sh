predefined_command=lf

# Launch Kitty with the predefined command
kitty -e $predefined_command

# Get the PID of the last background process (Kitty)
kitty_pid=$!

# Wait for the Kitty process to finish
wait $kitty_pid
