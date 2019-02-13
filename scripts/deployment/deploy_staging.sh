#!/bin/bash

echo "$DOCKER_PW" | docker login -u "$DOCKER_USERNAME" --password-stdin
faas-cli up -f testing/weather-forecast.yml --tag=branch

# Some test cases
echo -n Stuttgart, DE | faas-cli invoke weather-forecast
echo -n Istanbul | faas-cli invoke weather-forecast
echo -n Heilbronn:DE | faas-cli invoke weather-forecast
