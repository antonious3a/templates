 #Portainer
docker run -d \
 --restart always \
 --name portainer \
 --net aaa-bridge \
 --hostname portainer.antonio3a.aaa \
 -p 9000:9000 \
 -v /var/run/docker.sock:/var/run/docker.sock \
 -v portainer-vol:/data \
 portainer/portainer-ce:2.23.0

 # Portainer agent
  docker run -d \
  -p 9001:9001 \
  --net aaa-net \
  --name aaa-portainer-agent \
  --hostname aaa-portainer-agent \
  --restart always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /var/lib/docker/volumes:/var/lib/docker/volumes \
  portainer/agent:2.26.0
