#!/bin/bash


# Clean all certificates
rm *.crt *.key *.csr certindex* crlnumber* *.pem *.crl *.p12

# Generate CA's private key and self-signed certificate
openssl req -x509  -newkey rsa:2048 -days 365 -nodes -keyout ca.key -out ca.crt -subj "/C=IR/ST=Yazd/L=Yazd/O=ASAGroup/OU=ASA/CN=local"

touch certindex
echo 01 > certserial
echo 01 > crlnumber

# generate for servers :

# Generate web server's private key and certificate signing request (CSR)
openssl req -newkey  rsa:2048 -nodes -keyout server.key -out server.csr -subj "/C=IR/ST=Yazd/L=Yazd/O=ASAGroup/OU=ASA/CN=local"

openssl ca -batch -config ca.conf -notext -in server.csr -out server.crt
openssl pkcs12 -export -out server.p12 -inkey server.key -in server.crt -chain -CAfile ca.crt

openssl ca -config ca.conf -gencrl -keyfile ca.key -cert ca.crt -out rt.crl.pem
openssl crl -inform PEM -in rt.crl.pem -outform DER -out root.crl
rm rt.crl.pem

openssl crl -in root.crl -inform DER -out crl.pem
