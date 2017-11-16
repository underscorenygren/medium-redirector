FROM nginx

ENV MEDIUM_NAME ""
ENV DEBUG ""
ENV ENABLE_SSL ""
ENV SSL_CERT ""
ENV SSL_KEY ""

EXPOSE 80
EXPOSE 443

COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /etc/nginx/
COPY include.ssl /etc/nginx/
COPY include.redirect /etc/nginx/

ENTRYPOINT /etc/nginx/entrypoint.sh
