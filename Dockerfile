FROM node:alpine

ENV TMPDIR /tmp

RUN apk add -Uuv --no-cache python3 \
    && apk upgrade -v --available --no-cache \
    && apk add ca-certificates && pip3 install --no-cache-dir --upgrade pip setuptools wheel \
    && pip3 install requests certifi && npm install requests

ADD https://github.com/alexellis/faas/releases/download/0.5.6-alpha/fwatchdog /usr/bin

RUN chmod +x /usr/bin/fwatchdog

WORKDIR /root/

COPY time2nodejs.py .

ENV fprocess="python3 time2nodejs.py"

HEALTHCHECK --interval=1s CMD [ -e /tmp/.lock ] || exit 1

CMD ["fwatchdog"]