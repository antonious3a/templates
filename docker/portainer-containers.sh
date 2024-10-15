 #Portainer
docker run -d \
 --restart unless-stopped \
 --name antonio3a-portainer \
 --net antonio3a-network \
 --hostname antonio3a-portainer \
 -p 8000:8000 \
 -p 9000:9000 \
 -p 9443:9443 \
 -v /var/run/docker.sock:/var/run/docker.sock \
 -v antonio3a-portainer-data-vol:/data \
 portainer/portainer-ce:2.21.3


 # Portainer agent
  docker run -d \
  -p 9001:9001 \
  --net aaa-net \
  --name aaa-portainer-agent \
  --hostname aaa-portainer-agent \
  --restart always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /var/lib/docker/volumes:/var/lib/docker/volumes \
  portainer/agent:2.20.3-alpine
