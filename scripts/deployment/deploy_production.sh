#!/bin/bash

echo "$DOCKER_PW" | docker login -u "$DOCKER_USERNAME" --password-stdin

# Push to the production environment
faas-cli up -f app/weather-forecast.yml --tag=branch
