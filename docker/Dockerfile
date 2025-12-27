FROM caddy:latest

RUN apk add gcompat pcre

COPY bin/ /srv/bin
COPY config/ /srv/config
COPY public/ /srv/public
COPY resources/ /srv/resources
COPY docker/start.sh /srv/

CMD ["sh", "/srv/start.sh"]
