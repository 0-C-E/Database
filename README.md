# 0 C.E. Database

This repository contains the database schema and setup files for **0 C.E.**, an open-source, web-based strategy game set in antiquity. The database is designed to store and manage game data, including players, cities, battles, and more.

## Table of Contents

- [Overview](#overview)
- [Getting Started](#getting-started)
- [Database Structure](#database-structure)
- [Indices](#Indices)
- [Running in Docker](#running-in-docker)
- [Future Development](#future-development)

## Overview

The **0 C.E.** database is implemented using **MariaDB**, storing essential game data to support game mechanics like city-building, battles, alliances, and player progression. The schema is optimized for efficient querying and will evolve as the game expands.

## Getting Started

To set up the database locally, you'll need Docker installed. Follow the steps below to build and run the database in a container.

### Setup Steps

1. **Build the Docker Image**:

   ```bash
   docker build -t 0ce-mariadb .
   ```

2. **Run the Docker Container**:

   ```bash
   docker run -d -p 3306:3306 --name 0CE_Database -e MYSQL_ROOT_PASSWORD=myrootpassword 0ce-mariadb
   ```

3. **Access the Database**:
   ```bash
   docker exec -it 0CE_Database mariadb -uroot -pmyrootpassword
   ```

## Database Structure

The schema consists of the following tables:

### 1. `player`

- Stores player information, including ID, name, email, password hash, and account-related timestamps.
- **Key Columns**: `id`, `name`, `email`, `password`, `gold`, `created_at`, `last_login`

### 2. `world`

- Defines the game world configurations, like speeds, bonuses, and protection settings.
- **Key Columns**: `id`, `name`, `description`, `seed`, `action_speed`, `unit_speed`, `trade_speed`, `night_bonus`, `BEGINNER_PROTECTION`, `MORALE`, `ALLIANCE_CAP`, `STATUS`, `created_at`

### 3. `player_world`

- Maps players to worlds they're part of, supporting the `many-to-many` relationship between `player` and `world`.
- **Primary Key**: (`player_id`, `world_id`)

### 4. `island`

- Represents island locations within worlds.
- **Key Columns**: `id`, `x`, `y`, `world_id`

### 5. `city`

- Represents individual cities with their name, coordinates, and owner details.
- **Key Columns**: `id`, `name`, `island_id`, `x`, `y`, `owner_id`

### 6. `building`

- Contains building details, including name, level, and maximum level constraints.
- **Key Columns**: `id`, `name`, `level`, `max_level`, `city_id`

### 7. `building_requirement`

- Specifies the resource requirements for constructing and upgrading buildings.
- **Key Columns**: `building_id`, `wood`, `stone`, `silver`, `population`

### 8. `building_prerequisite`

- Lists prerequisite buildings required before a given building can be constructed.
- **Primary Key**: (`building_id`, `prerequisite_id`)

### 9. `unit`

- Defines units (e.g., troops), including costs, training time, and combat attributes.
- **Key Columns**: `id`, `name`, `type`, `wood_cost`, `stone_cost`, `silver_cost`, `population_cost`, `training_time`, `damage`, `speed`, `can_fly`

### 10. `city_unit`

- Tracks the quantity of each unit type present in a city.
- **Primary Key**: (`city_id`, `unit_id`)

### 11. `battle`

- Logs battles between players, including winner, loser, and loot details.
- **Key Columns**: `id`, `attacker_id`, `defender_id`, `time`, `winner_id`, `loser_id`, `loot_wood`, `loot_stone`, `loot_silver`

### 12. `battle_unit`

- Stores the details of units involved in a battle on each side.
- **Primary Key**: (`battle_id`, `unit_id`, `side`)

## Indices

To optimize performance, several Indices are defined:

- **Player Email Index**: `idx_player_email` on `player(email)`
- **Player Last Login Index**: `idx_player_last_login` on `player(last_login)`
- **Player-World Index**: `idx_player_world_world_id` on `player_world(world_id)`
- **World Status Index**: `idx_world_status` on `world(STATUS)`
- **City Owner Index**: `idx_city_owner` on `city(owner_id)`
- **Composite Battle Index**: `idx_battle_attacker_defender` on `battle(attacker_id, defender_id)`

## Running in Docker

This repository includes a [Docker configuration](Dockerfile) to easily build and run the MariaDB database with the schema preloaded.

- **Schema Files**: SQL files for creating the database and tables are copied into the container (`/docker-entrypoint-initdb.d/`), where they're automatically executed during the container's initial run.

## Future Development

- **Data Seeding**: Initial data for testing and development will be added soon, providing base data for testing players, cities, buildings, etc.
- **Schema Expansion**: New tables and fields will be added to support game features, such as alliances, diplomacy, and quests.
