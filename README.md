# unifi-docker

[![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/vjacobs/unifi.svg)](https://hub.docker.com/r/vjacobs/unifi)

Unifi Controller dockerized.

## Usage

```bash
docker run -v $(pwd)/data:/unifi -p 6789:6789 -p 8080:8080 -p 8443:8443 -p 8880:8880 -p 8843:8843 -p 3478:3478/udp vjacobs/unifi
```

Where the default installation of the Unifi Controller bundles a MongoDB server, it is not included in this container. Credentials for the external MongoDB server need to be set in `/unifi/system.properties` in the container ([example](./data/system.properties)).

Example usage seen in `docker-compose.yml`:

```bash
docker-compose up
```
