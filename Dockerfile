FROM alpine:latest

COPY ./job /root/job

RUN set -ex \
 && mkdir /etc/periodic/minutely \
 && echo "* *	*	*	*	run-parts /etc/periodic/minutely" >> /var/spool/cron/crontabs/root \
 && apk add --update --no-cache \
    bash \
    docker \
    tini \
 && rm -rf /var/cache/apk/* \
 && cp /root/job/minutely/test /etc/periodic/minutely/ \
 && cp /root/job/hourly/cleanup /etc/periodic/hourly/ \
 && chmod a+x /etc/periodic/minutely/* \
 && chmod a+x /etc/periodic/hourly/*

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["/usr/sbin/crond", "-f"]
