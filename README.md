# Docker Minecraft Purpur
This Dockerfile always builds the latest version of purpur

## Quick Start
```sh
docker pull buddyspencer/purpur
```

```sh
docker run \
  --rm \
  --name mc \
  -e MEMORYSIZE='1G' \
  -v /path/to/volume:/data:rw \
  -p 25565:25565 \
-i buddyspencer/purpur:latest
```
```sh
docker attach mc
```

## Docker Compose

```version: '2'
services:
    'purpur':
        image: 'buddyspencer/purpur:latest'
        container_name: mc
        environment:
            - MEMORYSIZE=1G
        volumes:
            - '/path/to/volume:/data:rw'
        ports:
            - '25565:25565'
```
**example file in repo*

## Availability
This container will be available for AMD64 and ARM64
