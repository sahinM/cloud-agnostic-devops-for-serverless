#!/bin/bash

echo "$DOCKER_PW" | docker login -u "$DOCKER_USERNAME" --password-stdin
faas-cli push -f testing/weather-forecast.yml --tag staging
