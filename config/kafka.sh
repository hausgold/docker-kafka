#!/bin/bash

# Configure application defaults
export KAFKA_ZOOKEEPER_CONNECT=${KAFKA_ZOOKEEPER_CONNECT:-'zookeeper:2181'}
export KAFKA_ADVERTISED_HOST_NAME=${KAFKA_ADVERTISED_HOST_NAME:-${MDNS_HOSTNAME}}
export KAFKA_LOG_DIRS=${KAFKA_LOG_DIRS:-'/kafka/logs'}

# Start the wurstmeister/kafka bootstrapping
source /usr/bin/start-kafka.sh
