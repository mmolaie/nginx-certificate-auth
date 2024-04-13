# nginx-certificate-auth
nginx certificate auth

# Step1: Create self-sign cert
```
git clone https://github.com/mmolaie/nginx-certificate-auth 

cd cert && chmod +x make.sh

./make.sh

openssl pkcs12 -export -out agent.p12 -inkey agent.key -in agent.crt -chain -CAfile ca.crt
```
