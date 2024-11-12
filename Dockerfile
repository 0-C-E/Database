# Use MariaDB version 11.5.2 as the base image
FROM mariadb:11.5.2

# Set environment variables
ENV TZ=America/Montreal

# Copy SQL files from the repository root into the container
# /docker-entrypoint-initdb.d/: Is the directory where MariaDB automatically runs any .sql, .sql.gz, or .sh files placed inside during the container's first run.
COPY create_database.sql /docker-entrypoint-initdb.d/
COPY create_tables.sql /docker-entrypoint-initdb.d/
COPY create_get_procedures.sql /docker-entrypoint-initdb.d/

# Expose the default MariaDB port (3306)
EXPOSE 3306
