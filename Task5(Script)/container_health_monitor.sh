#!/bin/bash

containers=$(docker ps -a --format "{{.Names}} {{.Status}}")

while read -r containers; do

    name=$(echo "$containers" | awk '{print $1}')
    status=$(echo "$containers" | awk '{print $2}')

    if [ "$status" == "Up" ]; then
        health=$(docker inspect --format='{{.State.Health.Status}}' "$name" 2>/dev/null)
        if [ "$health" == "unhealthy" ]; then
            status="Unhealthy"
        else
            status="Running"
        fi
    elif [[ "$status" == "Exited" || "$status" == "Created" ]]; then
        status="Stopped"
    fi
    echo "Container: $name, Status: $status"
done <<< "$containers"