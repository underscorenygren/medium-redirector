#!/bin/bash

if [ -z "$MEDIUM_NAME" ]; then
  echo "MEDIUM_NAME not set"
  exit 1
else
  echo "redirecting to medium at [$MEDIUM_NAME]"
fi

CONF_FILE=/etc/nginx/nginx.conf
INCLUDE_FILE=/etc/nginx/include.redirect

sed -i "s/MEDIUM_NAME/${MEDIUM_NAME}/" $INCLUDE_FILE

if [ -n "$ENABLE_SSL" ]; then
  echo "enabling SSL"
  if [ -z "$SSL_KEY" ] || [ -z "$SSL_CERT" ]; then
    echo "SSL_KEY and SSL_CRT not set"
    exit 1
  else
    echo "SSL WITH $SSL_CERT and $SSL_KEY"
  fi

  TMP_FILE=/tmp/nginx.conf
  SSL_INCLUDE=/etc/nginx/include.ssl
  CERT_REPL=$(echo "$SSL_CERT" | sed -e 's/[]\/$*.^|[]/\\&/g')
  KEY_REPL=$(echo "$SSL_KEY" | sed -e 's/[]\/$*.^|[]/\\&/g')
  cat /etc/nginx/nginx.conf | head -n -1 > $TMP_FILE
  sed -i "s/SSL_CERT/${CERT_REPL}/" /etc/nginx/include.ssl
  sed -i "s/SSL_KEY/${KEY_REPL}/" $SSL_INCLUDE
  cat $SSL_INCLUDE >> $TMP_FILE
  echo "}" >> $TMP_FILE

  mv $TMP_FILE $CONF_FILE

else
  echo "no SSL support"
fi

if [ -n "$DEBUG" ]; then
  echo "---CONFIG---"
  cat $CONF_FILE
  echo "-----"
fi
echo "starting"
nginx
