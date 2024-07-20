#Build docker image
docker build -t antonio3a/project:tag .

#Transger image
docker save antonio3a/project:tag | bzip2 | ssh -p 22 antonio3a@antonio3a-host docker load
