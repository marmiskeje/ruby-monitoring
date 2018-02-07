# Server monitoring

Solution for simple server monitoring.

Supported monitoring of:
1. Services (state, name, display_name)
2. Hard drives (path, free bytes, total bytes)

Supported profiles with severity (info, warning, critical, error) and actions (emailing):
1. For services - reaction to state
2. For hdds - reaction to free space percentage threshold

Prerequisites:
1. installed RabbitMQ
2. installed RedisDB

![GitHub Logo](/ruby-server-monitoring.png)
