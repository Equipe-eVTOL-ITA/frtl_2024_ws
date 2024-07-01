#!/bin/bash
set -e

# Define the workspace directory
WORKSPACE_DIR=~/frtl_2024_ws

# Source ROS 2 setup
source /opt/ros/humble/setup.bash

# Function to build packages
build_packages() {
    cd $WORKSPACE_DIR
    colcon build --packages-select $@
}

while true; do
    echo "Select an option to build:"
    echo "1) all packages"
    echo "2) simulation"
    echo "3) frtl_2024"
    echo "4) frtl_2024_fase1"
    echo "5) frtl_2024_fase2"
    echo "6) frtl_2024_fase3"
    echo "7) frtl_2024_fase4"
    read -p "" choice

    case $choice in
        1) colcon build ;;
        2) build_packages simulation ;;
        3) build_packages frtl_2024 ;;
        4) build_packages frtl_2024_fase1 ;;
        5) build_packages frtl_2024_fase2 ;;
        6) build_packages frtl_2024_fase3 ;;
        7) build_packages frtl_2024_fase4 ;;
        *) echo "Invalid option. Try again." ;;
    esac

    echo "Build completed!"
    echo
done
