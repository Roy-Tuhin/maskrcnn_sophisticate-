import docker

## https://docs.docker.com/develop/sdk/examples/
client = docker.from_env()
for container in client.containers.list():
  container.stop()
