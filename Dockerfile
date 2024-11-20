# Use MariaDB version 11.5.2 as the base image
FROM mariadb:11.5.2

# Set environment variables
ENV TZ=America/Montreal
ENV TEMP_SQL_DIR=/temp-sql-files

# Set the shell for safer execution
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Create a non-root user and group
RUN groupadd -r dbuser && useradd -r -g dbuser dbuser

# Copy all files into a temporary location
COPY . ${TEMP_SQL_DIR}/

# Flatten the directory structure and rename files to include folder names
RUN find "${TEMP_SQL_DIR:?}/" -type f -name "*.sql" | while read -r file; do \
    new_name=$(echo "$file" | sed "s|${TEMP_SQL_DIR:?}/||" | sed 's|/|_|g' | sed 's|^_||'); \
    cp "$file" "/docker-entrypoint-initdb.d/$new_name"; \
    done && \
    rm -rf "${TEMP_SQL_DIR:?}/"

# Set ownership
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
