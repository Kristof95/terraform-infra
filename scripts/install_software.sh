echo "Update Repository...."
sudo apt-get update

echo "Installing tools on AMI..."
sudo apt-get install nginx docker.io vim lvm2 git nodejs npm -y