#!/bin/bash

# Script to check if all containers in a Docker stack are healthy
# Usage: ./check-container-health.sh <stack_name> <retries> <interval>

# Exit immediately if a command exits with a non-zero status
set -e

# Function to display usage information
usage() {
    echo "Usage: $0 <stack_name> <retries> <interval>"
    echo "  stack_name: Name of the stack to check"
    echo "  retries: Number of times to retry the health check"
    echo "  interval: Interval in seconds between retries"
    exit 1
}

# Check if all required arguments are provided
if [ $# -ne 3 ]; then
    usage
fi

STACK_NAME=$1
RETRIES=$2
INTERVAL=$3

echo "Checking health status for all containers in stack '$STACK_NAME'"
echo "Will retry up to $RETRIES times with $INTERVAL seconds interval"

# Function to check if all containers in a stack are healthy
check_containers_health() {
    local healthy_count=0
    local unhealthy_count=0
    local containers

    # Find all containers that belong to the stack (using naming patterns)
    containers=$(docker ps -a --filter "label=com.docker.compose.project=$STACK_NAME" --format "{{.Names}}")

    # Count the number of containers found
    local container_count
    container_count=$(echo "$containers" | wc -l)

    # Check if we found any containers
    if [ "$container_count" -eq 0 ]; then
        echo "No containers found for stack '$STACK_NAME'"
        return 1
    fi

    echo "Found $container_count containers in stack '$STACK_NAME'"

    # Check health status of each container
    for container in $containers; do
        local health_status
        health_status=$(docker inspect --format "{{.State.Health.Status}}" "$container" 2>/dev/null || echo "unknown")

        echo "Container $container health status: $health_status"

        if [ "$health_status" = "healthy" ]; then
            healthy_count=$((healthy_count + 1))
        elif [ "$health_status" = "unknown" ]; then
            echo "Warning: Container $container does not have health check configured"
            # Consider containers without health checks as healthy
            healthy_count=$((healthy_count + 1))
        else
            unhealthy_count=$((unhealthy_count + 1))
        fi
    done

    echo "$healthy_count out of $container_count containers are healthy"

    # Return success if all containers are healthy
    if [ $unhealthy_count -eq 0 ]; then
        return 0
    else
        return 1
    fi
}

# Main loop to retry health checks
for ((i=1; i<=RETRIES; i++)); do
    echo "Attempt $i of $RETRIES:"

    if check_containers_health; then
        echo "All containers in stack '$STACK_NAME' are healthy!"
        exit 0
    fi

    if [ $i -lt "$RETRIES" ]; then
        echo "Not all containers in stack are healthy yet. Waiting $INTERVAL seconds before next check..."
        sleep "$INTERVAL"
    fi
done

echo "Failed to verify health status for all containers in stack '$STACK_NAME' after $RETRIES attempts"
echo "Removing stack '$STACK_NAME'..."
docker compose -p "$STACK_NAME" down  --remove-orphans
exit 1
