#!/bin/bash

# Generate private key
openssl genpkey -algorithm RSA -out private.pem -aes256

# Create CSR
openssl req -new -key private.pem -out csr.pem

##This command will use the information passed in -subj option and 
#will not prompt for any information.
#openssl req -new -key private.pem -out csr.pem -subj '/C=US/ST=California/L=Los Angeles/O=MyCompany/CN=example.com'
