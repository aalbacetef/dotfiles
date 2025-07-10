#!/usr/bin/env fish

set COMMAND_TO_RUN "$argv"

# Directory to watch for file changes (typically your project root or main source dir)
set PROJECT_DIR (pwd)

# last command run's PID
set PID "" 


echo ""
echo "watch n run:"
echo "------------"
echo "  directory: $PROJECT_DIR"
echo "  command:   $COMMAND_TO_RUN"
echo ""

function run_cmd
    # Kill any existing process of the command
    if test -n "$PID"
        echo "Stopping previous run (PID: $PID)..."
        # Using 'and' to ensure 'wait' only runs if 'kill' succeeds or is ignored
        kill "$PID" 2>/dev/null; or true
        wait "$PID" 2>/dev/null; or true

        echo "process with PID: $PID killed"
    end

    echo "------------------------------------------------------------"
    echo "Restarting: $COMMAND_TO_RUN at " (date)

    # Run the command in the background and store its PID
    # assumes it's a bash command
    bash -c $COMMAND_TO_RUN &
    set PID (jobs --last --pid) # Get the PID of the last backgrounded job

    echo "New command run started with PID: $PID"
    echo "------------------------------------------------------------"
end

run_cmd

fswatch -r -0 "$PROJECT_DIR" | while read -z event
    echo "Detected change in project directory: $event"
    run_cmd
end

# --- Graceful Shutdown ---
function cleanup_and_exit
    echo "Stopping process (PID: $PID)..."
    kill "$PID" 2>/dev/null; or true
    wait "$PID" 2>/dev/null; or true
    echo "Exiting..."
    exit 0
end

fish_add_handler SIGINT SIGTERM SIGHUP cleanup_and_exit
