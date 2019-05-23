# install docker 
 - `curl -sSL https://get.docker.com | sh`
 - `sudo usermod -aG docker pi`
 
# install docker-compose
 - sudo apt install -y python-pip
 - sudo apt install -y libffi-dev libssl-dev
 - sudo pip install docker-compose

# docker-compose
docker-compose up -c docker-compose.yml --no-start

# swarm init
 - docker swarm init

# deploy
 - docker stack deploy -c docker-compose.yml raspi
