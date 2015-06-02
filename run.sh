#!/bin/bash

if [ "${VIRTUAL_HOST}" = "**None**" ]; then
    unset VIRTUAL_HOST
fi

if [ "${SSL_CERT}" = "**None**" ]; then
    unset SSL_CERT
fi

if [ "${BACKEND_PORTS}" = "**None**" ]; then
    unset BACKEND_PORTS
fi

if [ -n "$SSL_CERT" ]; then
    echo "SSL certificate provided!"
    echo -e "${SSL_CERT}" > /servercert.pem
    export SSL="ssl crt /servercert.pem"
elif [ -n "$SSL_CERTS_COUNT" ]; then
    echo "Multiple SSL certificates provided!"
    mkdir /certs

    for i in `seq 0 $SSL_CERTS_COUNT`; do
        var="SSL_CERT_$i"
        echo -e "${!var}" > /certs/${i}_servercert.pem
    done

    export SSL="ssl crt /certs/"
else
    echo "No SSL certificate provided"
fi

exec python /app/haproxy.py
