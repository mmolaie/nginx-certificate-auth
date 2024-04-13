#!/bin/bash
set -e

make_ca() {
    echo "Creating Self-Signed Root CA certificate and key"
    openssl req \
        -new \
        -nodes \
        -x509 \
        -keyout ca.key \
        -out ca.crt \
        -config ca.cnf \
        -extensions v3_req \
        -days 1826  # 5 years
}

make_int() {
    echo "Creating Intermediate CA certificate and key"
    openssl req \
        -new \
        -nodes \
        -keyout ca_int.key \
        -out ca_int.csr \
        -config ca-intermediate.cnf \
        -extensions v3_req
    openssl req -in ca_int.csr -noout -verify
    openssl x509 \
        -req \
        -CA ca.crt \
        -CAkey ca.key \
        -CAcreateserial \
        -in ca_int.csr \
        -out ca_int.crt \
        -extfile ca-intermediate.cnf \
        -extensions v3_req \
        -days 365 # 1 year
    openssl verify -CAfile ca.crt ca_int.crt
    echo "Creating CA chain"
    cat ca_int.crt ca.crt > ca.pem
}

make_server() {
    echo "Creating nginx-manger certificate and key"
    openssl req \
        -new \
        -nodes \
        -keyout server.key \
        -out server.csr \
        -config server.cnf
    openssl req -in server.csr -noout -verify
    openssl x509 \
        -req \
        -CA ca_int.crt \
        -CAkey ca_int.key \
        -CAcreateserial \
        -in server.csr \
        -out server.crt \
        -extfile server.cnf \
        -extensions v3_req \
        -days 365 # 1 year
    openssl verify -CAfile ca.pem server.crt
}

make_agent() {
    echo "Creating Agent certificate and key"
    openssl req \
        -new \
        -nodes \
        -keyout agent.key \
        -out agent.csr \
        -config agent.cnf
    openssl req -in agent.csr -noout -verify
    openssl x509 \
        -req \
        -CA ca.crt \
        -CAkey ca.key \
        -CAcreateserial \
        -in agent.csr \
        -out agent.crt \
        -extfile agent.cnf \
        -extensions v3_req \
        -days 365 # 1 year
    openssl verify -CAfile ca.pem agent.crt
}

# MAIN
make_ca
make_int
make_server
make_agent
