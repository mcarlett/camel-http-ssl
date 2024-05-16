#!/bin/bash
SERVER_JKS=$1
CLIENT_JKS=$2

echo cp $SERVER_JKS in ssl-server/src/main/resources
cp $SERVER_JKS ssl-server/src/main/resources/server.jks

echo cp $CLIENT_JKS in ssl-server/src/main/resources
cp $CLIENT_JKS ssl-client/src/main/resources/client.jks
