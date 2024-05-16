#!/bin/bash
GEN_DIR="$1"

CA_JKS=$GEN_DIR/rootCA.jks
SERVER_JKS=$GEN_DIR/server.jks
K_PASS=pass123
SERVER_CERT=$GEN_DIR/server.pem
CLIENT_JKS=$GEN_DIR/client.jks
CLIENT_CERT=$GEN_DIR/client.pem

echo create directory $GEN_DIR
mkdir -p $GEN_DIR

echo generate root CA
keytool -alias root -genkeypair -storepass $K_PASS -keyalg RSA -keystore $CA_JKS -dname "cn=root, ou=root-ca, o=camel-http-ssl, c=US"

echo generate intermediate
keytool -alias intermediate -genkeypair -storepass $K_PASS -keyalg RSA -keystore $CA_JKS -dname "cn=intermediate, ou=intermediate, o=camel-http-ssl, c=US"

echo generate CSR
keytool -alias intermediate -certreq -storepass $K_PASS -keyalg RSA -keystore $CA_JKS \
  | keytool -alias root -gencert -ext san=dns:intermediate -storepass $K_PASS -keyalg RSA -keystore $CA_JKS \
  | keytool -alias intermediate -importcert -storepass $K_PASS -keyalg RSA -keystore $CA_JKS

echo show generated certificates in $CA_JKS
keytool -list -keystore $CA_JKS -storepass $K_PASS

echo generate server certificates
keytool -alias server -dname "cn=localhost, ou=server, o=camel-http-ssl, c=US" -genkeypair -storepass $K_PASS -keyalg RSA -keystore $SERVER_JKS

echo generate server CSR
keytool -alias server -certreq -storepass $K_PASS -keyalg RSA -keystore $SERVER_JKS \
 | keytool -alias intermediate -gencert -storepass $K_PASS -keyalg RSA \
 | keytool -alias server -importcert -storepass $K_PASS -keyalg RSA -keystore $SERVER_JKS -noprompt -trustcacerts

echo export server certificates
keytool -export -alias root -storepass $K_PASS -keystore $CA_JKS \
 | keytool -import -alias root -keystore $SERVER_JKS -storepass $K_PASS -noprompt -trustcacerts

echo show generated certificates in $SERVER_JKS
keytool -list -keystore $SERVER_JKS -storepass $K_PASS

echo export server cert and import in client trust store
keytool -exportcert -alias server -storepass $K_PASS -keystore $SERVER_JKS -rfc -file $SERVER_CERT
keytool -import -keystore $CLIENT_JKS -storepass $K_PASS -file $SERVER_CERT -alias server -noprompt -trustcacerts

echo generate client certificates
keytool -alias client -dname "cn=localhost, ou=client, o=camel-http-ssl, c=US" -genkeypair -storepass $K_PASS -keyalg RSA -keystore $CLIENT_JKS

echo generate client CSR
keytool -alias client -certreq -storepass $K_PASS -keyalg RSA -keystore $CLIENT_JKS \
 | keytool -alias intermediate -gencert -storepass $K_PASS -keyalg RSA \
 | keytool -alias client -importcert -storepass $K_PASS -keyalg RSA -keystore $CLIENT_JKS -noprompt -trustcacerts

echo show generated certificates in $CLIENT_JKS
keytool -list -keystore $CLIENT_JKS -storepass $K_PASS

echo export client certificates
keytool -exportcert -alias client -storepass $K_PASS -keystore $CLIENT_JKS -rfc -file $CLIENT_CERT
