#!/bin/bash

vgchange -ay


DEVICE_FS=`blkid -o value -s TYPE ${DEVICE}`
if [ "`echo -n $DEVICE_FS`" == "" ]; then
    DEVICE_NAME=`echo "$DEVICE" | awk -F '/' '{print $3}'`
    DEVICE_EXISTS=''
    while [[ -z $DEVICE_EXISTS ]]; do
        echo "Checking $DEVICE_NAME"
        DEVICE_EXISTS=`lsblk | grep "$DEVICE_NAME" | wc -l`
        if [[ $DEVICE_EXISTS != "1" ]]; then
            sleep 15
        fi
    done
    pvcreate ${DEVICE}
    vgcreate data ${DEVICE}
    lvcreate --name volume1 -l 100%FREE data
    mkfs.ext4 /dev/data/volume1
fi

mkdir -p /var/lib/jenkins
echo "/dev/data/volume1 /var/lib/jenkins ext4 defaults 0 0" >> /etc/fstab
mount /var/lib/jenkins

apt-get update
apt-get install -y default-jre

# install jenkins and docker
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
   /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
 https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
 /etc/apt/sources.list.d/jenkins.list > /dev/null
apt-get update
apt-get install -y jenkins=${JENKINS_VERSION} unzip docker.io


# enable docker and add perms
usermod -G docker jenkins
systemctl enable docker
service docker start
service jenkins restart


# install pip
wget -q https://bootstrap.pypa.io/get-pip.py
python get-pip.py
python3 get-pip.py
rm -f get-pip.py
# install awscli
pip install awscli

# install terraform
TERRAFORM_VERSION="1.6.2"
wget -q https://releases.hashicorp.com/terraform/$${TERRAFORM_VERSION}/terraform_$${TERRAFORM_VERSION}_linux_amd64.zip \
&& unzip -o terraform_$${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin \
&& rm terraform_$${TERRAFORM_VERSION}_linux_amd64.zip

# install packer
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add - && \
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
sudo apt-get update && sudo apt-get install packer -y

# clean up
apt-get clean
rm terraform_$${TERRAFORM_VERSION}_linux_amd64.zip