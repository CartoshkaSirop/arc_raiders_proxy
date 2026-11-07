FROM alpine:latest

RUN apk add --no-cache curl unzip \
    && mkdir -p /etc/xray /usr/local/bin \
    && curl -L -H "Cache-Control: no-cache" -o /tmp/xray.zip https://github.com \
    && unzip /tmp/xray.zip -d /usr/local/bin \
    && chmod +x /usr/local/bin/xray \
    && rm -rf /tmp/xray.zip

RUN echo '{\
  "inbounds": [{\
    "port": 10000,\
    "protocol": "vless",\
    "settings": {\
      "clients": [{"id": "4e7b8c2d-9a1f-4b3c-8d5e-6f7a8b9c0d1e"}],\
      "decryption": "none"\
    },\
    "streamSettings": {\
      "network": "ws",\
      "wsSettings": {"path": "/"}\
    }\
  }],\
  "outbounds": [{"protocol": "freedom"}]\
}' > /etc/xray/config.json

EXPOSE 10000

CMD ["/usr/local/bin/xray", "-config", "/etc/xray/config.json"]
