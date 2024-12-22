#!/bin/bash

container_names=("web" "database" "cache")

check_time=60


restart_container() {
  container=$1
  echo "$(date) - Attempting to restart container '$container'..." >> restart-log.txt
  docker restart "$container" >> restart-log.txt 2>&1
  if [ $? -eq 0 ]; then
    echo "$(date) - Successfully restarted container '$container'" >> restart-log.txt
  else
    echo "$(date) - Failed to restart container '$container'" >> restart-log.txt
  fi
}

check_containers() {
  for container in "${container_names[@]}"; do
    # Konteynerin durumunu kontrol et
    status=$(docker inspect -f '{{.State.Status}}' "$container" 2>/dev/null)

    if [ $? -eq 0 ]; then
      echo "Container '$container': $status"

      if [ "$status" != "running" ]; then
        echo "$(date) - Container '$container' is not running. Restarting..." >> restart-log.txt
        restart_container "$container"
      fi
    else
      echo "Container '$container': Not found!"
    fi
  done
  echo ""
}

echo "Containers Status Check: ${container_name[*]}"

while true; do

  check_containers

  sleep $check_time

done