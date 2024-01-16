your_predefined_command=nvim

# Launch Kitty with the predefined command
kitty -e $your_predefined_command

# Get the PID of the last background process (Kitty)
kitty_pid=$!

# Wait for the Kitty process to finish
wait $kitty_pid
