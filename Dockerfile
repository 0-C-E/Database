# Use MariaDB version 11.5.2 as the base image
FROM mariadb:11.5.2

# Set environment variables
ENV TZ=America/Montreal

# Create a new user and group with limited privileges
RUN groupadd -r mariadbuser && useradd -r -g mariadbuser mariadbuser

# Copy SQL files from the repository root into the container and set permissions
COPY create_database.sql /docker-entrypoint-initdb.d/
COPY create_tables.sql /docker-entrypoint-initdb.d/
COPY create_get_procedures.sql /docker-entrypoint-initdb.d/
RUN chown -R mariadbuser:mariadbuser /docker-entrypoint-initdb.d

# Set permissions for MariaDB's default directories for its own user (typically `mysql`)
RUN chown -R mysql:mysql /var/lib/mysql /etc/mysql

# Expose the default MariaDB port (3306)
EXPOSE 3306

# Add health check for the container
HEALTHCHECK --interval=1m --timeout=10s --start-period=30s --retries=3 \
    CMD mysqladmin ping -h localhost || exit 1

# Switch to the limited user at the end
USER mariadbuser
