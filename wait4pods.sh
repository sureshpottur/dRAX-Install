#!/bin/bash

# Set the namespace (optional)
namespace=default

# Set the timeout in seconds
timeout=300

# Set the interval in seconds
interval=5

echo "Waiting for all pods to be in Running or Completed state..."

end=$((SECONDS+timeout))
while true; do
  not_running_or_completed=$(kubectl get pods -n "$namespace" --field-selector=status.phase!=Running,status.phase!=Completed -o name)
  if [ -z "$not_running_or_completed" ]; then
    echo "All pods are in Running or Completed state"
    exit 0
  fi
  if [ "$SECONDS" -ge "$end" ]; then
    echo "Timed out waiting for pods to be in Running or Completed state" >&2
    exit 1
  fi
  sleep "$interval"
done

