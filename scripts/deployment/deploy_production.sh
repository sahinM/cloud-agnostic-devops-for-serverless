#!/bin/bash

echo "$DOCKER_PW" | docker login -u "$DOCKER_USERNAME" --password-stdin

# Push to the production environment
faas-cli build -f testing/weather-forecast.yml
faas-cli push -f testing/weather-forecast.yml --tag production
faas-cli deploy -f testing/weather-forecast.yml
