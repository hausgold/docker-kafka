FROM apache/kafka:3.7.0
MAINTAINER Hermann Mayer "hermann.mayer@hausgold.de"

# You can change this environment variable on run's with -e
ENV MDNS_HOSTNAME=kafka.local

# Switch to the root user
USER root

# Install system packages
RUN apk add --no-cache \
  dbus avahi avahi-tools supervisor bash

# Reconfigure supervisord
RUN sed \
  -e 's#^\(files =\).*#\1 /etc/supervisor/conf.d/*.conf#g' \
  -i /etc/supervisord.conf

# Copy custom scripts
COPY config/*.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/*

# Configure supervisord
COPY config/supervisor/* /etc/supervisor/conf.d/

# Define the command to run per default
CMD /usr/bin/supervisord -nc /etc/supervisord.conf
