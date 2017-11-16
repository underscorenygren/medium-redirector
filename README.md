## medium-redirector

This project aims to provide a canned redirection solution when you
want to migrate from one custom medium domain to another, e.g.
blog.example.com -> blog.example.org, where both blogs are on medium.

## Usage

Deploy the container in your stack and point your DNS to it. It will
issue 301 redirects to the the unique medium suffix, which medium
will redirect for you once you've instructed it to use your new domain.

```
docker run --rm -e MEDIUM_NAME=myname -e ENABLE_SSL=true -e SSL_CERT=/etc/ssl/example.com.crt -e SSL_KEY=/etc/ssl/example.com.key -p 80:80 -p 443:443 -it -e DEBUG=true -v /path/to/ssl/dir/:/etc/ssl:ro underscorenygren/medium-redirector
```

## Options

- `MEDIUM_NAME` (Required): Your medium user name to redirect to
- `ENABLE_SSL` (Optional): Set to any string to enable SSL
- `SSL_CERT` (Required with SSL): Full path to your ssl cert file in the container
- `SSL_KEY` (Required with SSL): Full path to your ssl key file in the container
- `DEBUG` (Optional) set to truthy string to print config on start

## Guts

The container uses a nginx container that matches the suffixes and redirects,
so it's nice and performant. It uses some sed replacing to get config
flags to work correctly
