ARG BASE_VERSION=3.10.6
ARG PLUGIN_VERSION=3.10.2

FROM rabbitmq:${BASE_VERSION}-management-alpine

ARG PLUGIN_VERSION
RUN apk add curl && \
        curl -vvv -L -o "$RABBITMQ_HOME/plugins/rabbitmq_delayed_message_exchange-${PLUGIN_VERSION}.ez" \
        https://github.com/rabbitmq/rabbitmq-delayed-message-exchange/releases/download/${PLUGIN_VERSION}/rabbitmq_delayed_message_exchange-${PLUGIN_VERSION}.ez

COPY 10-defaults.conf /etc/rabbitmq/conf.d/10-defaults.conf

RUN rabbitmq-plugins enable --offline rabbitmq_delayed_message_exchange