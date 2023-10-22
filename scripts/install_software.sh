echo "Update Repository...."
sudo apt-get update

echo "Installing nginx on AMI..."
sudo apt-get install nginx docker.io vim lvm2 git node npm -y

echo "Installing pm2..."
sudo npm install pm2 -g

# echo "Installing NodeJS 20 on machine..."
# sudo apt-get install -y ca-certificates curl gnupg
# curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
# NODE_MAJOR=20
# echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
# sudo apt-get update && sudo apt-get install nodejs -y
# node -v