# nginx-certificate-auth
nginx certificate auth

# Step1: Create self-sign cert
```
git clone https://github.com/mmolaie/nginx-certificate-auth 

cd cert && chmod +x make.sh

./make.sh

openssl pkcs12 -export -out foad.p12 -inkey agent.key -in agent.crt -chain -CAfile ca.crt
```

# Step2: Change nginx conf
Set it to give a 403 response to unauth requests!
```
cp ./nginx/conf.d/base.conf /etc/nginx/conf.d

service nginx restart
```
# Step3: Import Cert to token
.. image:: img/import_cert.png
    :alt: Import
    :align: center
