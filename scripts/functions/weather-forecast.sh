#!/bin/bash

# build, deploy and push weather-forecast function and call it
cd testing
faas-cli up -f weather-forecast.yml
# wait_for_service_to_start echo
echo -n Stuttgart, DE | faas-cli invoke weather-forecast
cd -