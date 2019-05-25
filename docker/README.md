# install docker 
 - `curl -sSL https://get.docker.com | sh`
 - `sudo usermod -aG docker pi`
 
 ## for zero w
 
 - `sh get-docker.sh --dry-run`
 - follow all steps like lister frm the dry-run except the latest
 - last step: `apt-get install -y -qq --no-install-recommends 'docker-ce=18.06.*'`
 
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
