# Setup moodle LMS Using Docker on linux host:

This project sets up a Moodle 5.0.5 environment using:

- **PHP 8.3** with Apache (in a Docker container)
- **MariaDB** (on host machine)
- **Moodle source code** cloned directly from Moodle's Git repository
- **Custom configuration** for performance and compatibility

## 🛠️ Setup Instructions

### 1. Clone This Repository

```bash
git clone <this-repo-url>
cd moodle-docker
2. Prepare the MariaDB Database (on Host)
Launch MySQL shell:

bash:
sudo mysql
Then run:

sql:
DROP DATABASE IF EXISTS moodle;
CREATE DATABASE moodle DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_unicode_ci;
CREATE USER 'maheshraj'@'%' IDENTIFIED BY 'Engineer@16';
GRANT ALL PRIVILEGES ON moodle.* TO 'maheshraj'@'%';
FLUSH PRIVILEGES;
EXIT;
Ensure MariaDB is listening on 0.0.0.0 (not just localhost) if needed for container access.

🧠 Troubleshooting
Error: Error reading from database
Ensure database is reachable:
mysql -h 127.0.0.1 -u maheshraj -p moodle

Check config.php for correct DB host (host.docker.internal)

Inspect logs:
docker logs moodle-php83 | tail -n 50

Error: Undefined constant "_DIR_"
Fix config.php to use __DIR__ (double underscore).

🧹 Resetting the Environment
bash
docker compose down -v
sudo rm -rf ./moodledata
Recreate database and rerun:

bash
docker compose up -d --build
📁 Directory Structure
moodle-docker/
├── Dockerfile
├── docker-compose.yml
├── moodledata/          <-- Mounted Moodle data directory
└── README.md

visit your site: http://localhost:8085

5. Build and Start the Container
bash:
docker compose up -d --build

6. Verify Service is Running
Check if Apache inside the container responds:
curl -I http://localhost:8085
Expected:

http
HTTP/1.1 302 Found
Location: install.php

7. Fix config.php if needed
If config.php was created manually or modified:
bash
docker exec -it moodle-php83 bash
nano /var/www/html/config.php
Replace _DIR_ with __DIR__ on line like:

php
require_once(__DIR__ . '/lib/setup.php');

bash
sudo mysql -u root
USE moodle;
SHOW TABLES;
You should see dozens of tables after install completes.

Summary of All Key Shell Commands
bash
# Create working dir
mkdir ~/Documents/moodle-docker && cd ~/Documents/moodle-docker

# Build and start container
docker compose up -d --build

# Check container status
docker ps

# Check Apache response
curl -I http://localhost:8085

# Access container to debug/fix
docker exec -it moodle-php83 bash

# View logs if error
docker logs moodle-php83 | tail -n 50

# Reset environment if needed
docker compose down -v
sudo rm -rf ./moodledata
