ARG BASE_VERSION=4.2.9

FROM rabbitmq:${BASE_VERSION}-management-alpine

# rabbitmq_delayed_message_exchange (used by the API: exchange "ex_delayed", header "x-delay").
# The plugin repository is archived; v4.2.0 is its last release and supports ONLY RabbitMQ 4.2.x.
# Do NOT bump BASE_VERSION to 4.3+ until delayed retries are migrated off this plugin.
ARG PLUGIN_VERSION=4.2.0
# sha256 of the .ez file, verified against the GitHub release asset digest
ARG PLUGIN_SHA256=f168b2c09810cde3726961d31f38e3408e6a7fbff3929908d6f962061d8e70a1

# Upstream no longer rebuilds 4.2 images (community support ended) -> pull Alpine security fixes at build time
RUN apk upgrade --no-cache

ADD --chown=rabbitmq:rabbitmq \
    https://github.com/rabbitmq/rabbitmq-delayed-message-exchange/releases/download/v${PLUGIN_VERSION}/rabbitmq_delayed_message_exchange-${PLUGIN_VERSION}.ez \
    /opt/rabbitmq/plugins/

RUN echo "${PLUGIN_SHA256}  /opt/rabbitmq/plugins/rabbitmq_delayed_message_exchange-${PLUGIN_VERSION}.ez" | sha256sum -c - \
    && rabbitmq-plugins enable --offline rabbitmq_delayed_message_exchange

COPY 10-defaults.conf /etc/rabbitmq/conf.d/10-defaults.conf
