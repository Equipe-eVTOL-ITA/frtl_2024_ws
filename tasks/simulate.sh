#!/bin/bash
set -e

if [ -f install/setup.bash ]; then 
    source install/setup.bash
fi

export GAZEBO_MODEL_PATH=$GAZEBO_MODEL_PATH:/home/vinicius/PX4-Autopilot/Tools/simulation/gz/models

cd ~/PX4-Autopilot

WORLD=$1
PX4_GZ_MODEL="x500_simulation"

if [ "$WORLD" = "empty" ]; then
    PX4_GZ_MODEL_POSE="0,0,0"
    make px4_sitl gz_x500 PX4_GZ_MODEL=$PX4_GZ_MODEL PX4_GZ_MODEL_POSE=$PX4_GZ_MODEL_POSE
else
    if [ "$WORLD" = "fase1" ]; then
        PX4_GZ_MODEL_POSE="8.0,2.2,1.0"
    elif [ "$WORLD" = "fase2" ]; then
        PX4_GZ_MODEL_POSE="8.0,2.2,1.0"
    elif [ "$WORLD" = "fase3" ]; then
        PX4_GZ_MODEL_POSE="8.0,2.2,1.0"
    elif [ "$WORLD" = "fase4" ]; then
        PX4_GZ_MODEL_POSE="8.0,2.2,1.0"
    else
        echo "Invalid world specified! Please use fase1, fase2, fase3, fase4, or empty."
        exit 1
    fi
    make px4_sitl gz_x500_$WORLD PX4_GZ_MODEL=$PX4_GZ_MODEL PX4_GZ_MODEL_POSE=$PX4_GZ_MODEL_POSE
fi