# unifi-docker

[![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/vjacobs/unifi.svg)](https://hub.docker.com/r/vjacobs/unifi)

Unifi Controller dockerized.

## Usage

```bash
docker run -v $(pwd)/data:/unifi -p 6789:6789 -p 8080:8080 -p 8443:8443 -p 8880:8880 -p 8843:8843 -p 3478:3478/udp -p 10001:10001/udp vjacobs/unifi
```

The deb package for the controller by default installs a MongoDB server, but it's not included in this container. Credentials for an external MongoDB server need to be set in `/unifi/system.properties` ([example](./data/system.properties)).

Example usage seen in `docker-compose.yml`:

```bash
docker-compose up
```

Because the controller wrongly detects its own IP address (Docker IP address instead of host address), you need to enable `Override inform host with controller hostname/IP` in the controller settings and set the host IP address in `Controller Hostname/IP`.
