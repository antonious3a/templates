#Gen your ssh key
ssh-keygen -t ed25519 -C "antonio3a@my-pc"

#Copy your ssh key
ssh-copy-id -i ~/.ssh/id_ed25519.pub -p 22 user@host
