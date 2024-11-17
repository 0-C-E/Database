# Use MariaDB version 11.5.2 as the base image
FROM mariadb:11.5.2

# Set environment variables
ENV TZ=America/Montreal

# Create a non-root user and group
RUN groupadd -r dbuser && useradd -r -g dbuser dbuser

# Copy SQL files and set ownership
COPY *.sql /docker-entrypoint-initdb.d/
RUN chown -R dbuser:dbuser /docker-entrypoint-initdb.d

# Ensure proper permissions for MariaDB directories
RUN chown -R dbuser:dbuser /var/lib/mysql /etc/mysql

# Expose the default MariaDB port (3306)
EXPOSE 3306

# Add health check for the container
HEALTHCHECK --interval=1m --timeout=10s --start-period=30s --retries=3 \
    CMD mysqladmin ping -h localhost || exit 1

# Switch to the non-root user
USER dbuser
