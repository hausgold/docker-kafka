![mDNS enabled Kafka](https://raw.githubusercontent.com/hausgold/docker-kafka/master/docs/assets/project.png)

[![Continuous Integration](https://github.com/hausgold/docker-kafka/actions/workflows/package.yml/badge.svg?branch=master)](https://github.com/hausgold/docker-kafka/actions/workflows/package.yml)
[![Source Code](https://img.shields.io/badge/source-on%20github-blue.svg)](https://github.com/hausgold/docker-kafka)
[![Docker Image](https://img.shields.io/badge/image-on%20docker%20hub-blue.svg)](https://hub.docker.com/r/hausgold/kafka/)

This Docker images provides the
[apache/kafka](https://hub.docker.com/r/apache/kafka/) image as base with the
mDNS/ZeroConf stack on top. (2.x tags used
[wurstmeister/kafka](https://hub.docker.com/r/wurstmeister/kafka/), which
required Zookeeper) So you can enjoy [Apache Kafka](https://kafka.apache.org)
while it is accessible by default as *kafka.local* (Port 9092) as a single-node
cluster using KRaft without Zookeeper.

- [Requirements](#requirements)
- [Getting starting](#getting-starting)
- [Host configs](#host-configs)
- [Configure a different mDNS hostname](#configure-a-different-mdns-hostname)
- [Other top level domains](#other-top-level-domains)
- [Further reading](#further-reading)

## Requirements

* Host enabled Avahi daemon
* Host enabled mDNS NSS lookup

## Getting starting

To get a single broker Apache Kafka service up and running create a
`docker-compose.yml` and insert the following snippet (based on the [original
example](https://github.com/apache/kafka/blob/trunk/docker/examples/jvm/single-node/plaintext/docker-compose.yml)):

```yaml
services:
  kafka:
    image: hausgold/kafka
    environment:
      MDNS_HOSTNAME: kafka.local
      # See: http://bit.ly/2UDzgqI for Kafka downscaling
      KAFKA_HEAP_OPTS: -Xmx256M -Xms32M
    ulimits:
      # Due to systemd/pam RLIMIT_NOFILE settings (max int inside the
      # container), the Java process seams to allocate huge limits which result
      # in a +unable to allocate file descriptor table - out of memory+ error.
      # Lowering this value fixes the issue for now.
      #
      # See: http://bit.ly/2U62A80
      # See: http://bit.ly/2T2Izit
      nofile:
        soft: 100000
        hard: 100000
```

Afterwards start the service with the following command:

```bash
$ docker-compose up
```

## Host configs

Install the nss-mdns package, enable and start the avahi-daemon.service. Then,
edit the file /etc/nsswitch.conf and change the hosts line like this:

```bash
hosts: ... mdns4_minimal [NOTFOUND=return] resolve [!UNAVAIL=return] dns ...
```

## Configure a different mDNS hostname

The magic environment variable is *MDNS_HOSTNAME*. Just pass it like that to
your docker run command:

```bash
$ docker run --rm -e MDNS_HOSTNAME=something.else.local hausgold/kafka
```

This will result in *something.else.local*.

You can also configure multiple aliases (CNAME's) for your container by
passing the *MDNS_CNAMES* environment variable. It will register all the comma
separated domains as aliases for the container, next to the regular mDNS
hostname.

```bash
$ docker run --rm \
  -e MDNS_HOSTNAME=something.else.local \
  -e MDNS_CNAMES=nothing.else.local,special.local \
  hausgold/kafka
```

This will result in *something.else.local*, *nothing.else.local* and
*special.local*.

## Other top level domains

By default *.local* is the default mDNS top level domain. This images does not
force you to use it. But if you do not use the default *.local* top level
domain, you need to [configure your host avahi][custom_mdns] to accept it.

## Further reading

* Docker/mDNS demo: https://github.com/Jack12816/docker-mdns
* Archlinux howto: https://wiki.archlinux.org/index.php/avahi
* Ubuntu/Debian howto: https://wiki.ubuntuusers.de/Avahi/

[custom_mdns]: https://wiki.archlinux.org/index.php/avahi#Configuring_mDNS_for_custom_TLD
