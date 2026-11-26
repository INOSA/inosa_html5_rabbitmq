# INOSA RabbitMQ image

Official `rabbitmq:<version>-management-alpine` image with:
- `rabbitmq_delayed_message_exchange` plugin: the API uses exchange `ex_delayed` (`x-delay`) to retry emails;
- `10-defaults.conf`: `consumer_timeout` = 24h (long video conversions in the node worker).

| Image tag | RabbitMQ | Plugin | Alpine |
|---|---|---|---|
| `4.2.9-management-alpine` | 4.2.9 | v4.2.0 | 3.23 |
| `3.10.6-management-alpine` (legacy) | 3.10.6 | 3.10.2 | 3.16 |

## Build
```shell
docker build -t public.ecr.aws/s6z8v3g0/inosadocker/rabbitmq:4.2.9-management-alpine .
trivy image --severity HIGH,CRITICAL public.ecr.aws/s6z8v3g0/inosadocker/rabbitmq:4.2.9-management-alpine
```

## Constraints
- The delayed-message plugin is **archived**. v4.2.0 is the last release and works only with RabbitMQ **4.2.x**
  (it depends on Mnesia, which was removed in 4.3). Moving to 4.3+/4.4 first requires replacing the delayed retries
  (native delay in quorum queues from 4.4, or DLX + TTL).
- RabbitMQ 4.2 is out of community support: rebuild regularly (`apk upgrade` runs at build time) and re-scan with Trivy.
- RabbitMQ >= 4.1 rejects AMQP clients that negotiate `frame_max` < 8192. The node worker (amqplib 0.5.6) therefore
  connects with `?frameMax=131072`.

## Upgrading from 3.10.6
3.10 → 4.2 cannot be done in place (5 intermediate minor upgrades). Use the blue-green + Shovel migration
from `inosa_docker_stack/rabbitmq/migration/` (keeps queued and delayed messages).
