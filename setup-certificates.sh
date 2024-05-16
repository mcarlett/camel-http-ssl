#!/bin/bash
SERVER_JKS=$1
CLIENT_JKS=$2

echo cp $SERVER_JKS in ssl-server/src/main/resources
rm ssl-server/src/main/resources/server.jks || true
cp $SERVER_JKS ssl-server/src/main/resources/server.jks

echo cp $SERVER_JKS in ssl-camel-server/src/main/resources
rm ssl-camel-server/src/main/resources/server.jks || true
cp $SERVER_JKS ssl-camel-server/src/main/resources/server.jks

echo cp $CLIENT_JKS in ssl-server/src/main/resources
rm ssl-client/src/main/resources/client.jks || true
cp $CLIENT_JKS ssl-client/src/main/resources/client.jks

echo cp $CLIENT_JKS in ssl-server/src/main/resources
rm ssl-server/src/main/resources/client.jks || true
cp $CLIENT_JKS ssl-server/src/main/resources/client.jks
