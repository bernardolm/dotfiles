FROM alpine:3.19

ARG UID

RUN addgroup -S -g $UID mosquitto && \
	adduser -S -u $UID -D -H \
		-h /var/empty \
		-s /sbin/nologin \
		-G mosquitto \
		-g mosquitto mosquitto

RUN apk --no-cache add mosquitto ca-certificates

RUN mkdir -p /mosquitto/config /mosquitto/data /mosquitto/log

ADD https://raw.githubusercontent.com/eclipse/mosquitto/master/docker/generic/docker-entrypoint.sh /mosquitto

ADD https://raw.githubusercontent.com/eclipse/mosquitto/master/docker/generic/mosquitto-no-auth.conf /mosquitto/config/mosquitto.conf

RUN chown -R mosquitto:mosquitto /mosquitto && \
	chmod u+x /mosquitto/docker-entrypoint.sh

USER mosquitto

EXPOSE 1883

ENTRYPOINT ["/mosquitto/docker-entrypoint.sh"]

CMD ["/usr/sbin/mosquitto", "-c", "/mosquitto/config/mosquitto.conf"]
