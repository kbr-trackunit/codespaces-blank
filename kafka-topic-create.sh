#!/bin/bash

env="eks-dev eks-stage eks-prod"
topics="EmailMessageTopic TU_MACHINE TU_UNIT_CLASSIC confluent trackunit-report-process tu-pull-extended-info-response tu-pull-extended-info tu-pull-trip-request tu-pull-trip-response tu-pull-unit-history-request tu-pull-unit-history-response tu-pull-unit-request tu-pull-unit-response"

for env in ${env}; do
    for topic in ${topics}; do
        broker="$(shuf -n1 -e 0 1 2)"
        if [ "${topic}" != "trackunit-report-process" ]; then
            kubectl --context "${env}" -n kafka-internal exec "kafka-cp-kafka-${broker}" -- sh -c "kafka-topics --create --topic ${topic} --partitions 6 --replication-factor 3 --config retention.ms=2592000000 --bootstrap-server kafka-cp-kafka:9092""
        else
            kubectl --context "${env}" -n kafka-internal exec "kafka-cp-kafka-${broker}" -- sh -c "kafka-topics --create --topic ${topic} --partitions 2 --replication-factor 3 --config retention.ms=2592000000 --bootstrap-server kafka-cp-kafka:9092""
        fi
    done
done
