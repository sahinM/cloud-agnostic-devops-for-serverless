#!/bin/bash
# This function waits for the service to become available.
# Retries for 10 times and 3 second interval (hard coded for now)
wait_for_service_to_start() {
    local n=1
    local max=10
    local delay=3

    local SERVICE_NAME=$1
    local SERVICE_IS_RUNNING=0
    while [  "$SERVICE_IS_RUNNING" -eq 0 ]; do
      if [[ $n -gt $max ]]; then
        echo "ERROR: Retried $(($n-1)) times but $SERVICE_NAME didn't start. Exiting" >&2
        exit 1
      fi
      SERVICE_IS_RUNNING=$(check_service_is_running $SERVICE_NAME)
      echo "Waiting for $SERVICE_NAME to start"
      n=$[$n+1]
      sleep $delay
    done
    echo "$SERVICE_NAME is Running"
}

cd testing
faas-cli up -f weather-forecast.yml
# wait_for_service_to_start echo
echo -n Stuttgart, DE | faas-cli invoke weather-forecast