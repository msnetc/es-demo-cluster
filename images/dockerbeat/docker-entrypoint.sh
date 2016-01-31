#!/bin/bash

set -e

echo 'Waiting for Elasticsearch cluster to be available...'

while ! nc -w 1 $ELASTICSEARCH_HOST $ELASTICSEARCH_PORT 2>/dev/null
do
  echo 'Elasticsearch is still not available, sleeping 5 seconds...'
  sleep 5
done

echo 'Configuring dockerbeat template...'
curl --silent -XPUT "http://$ELASTICSEARCH_HOST:$ELASTICSEARCH_PORT/_template/dockerbeat" -d@dockerbeat.template.json; echo

echo 'Starting dockerbeat...'
./dockerbeat -e -c dockerbeat.yml