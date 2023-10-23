pipeline {
    agent {
        label 'Monster'
    }

    stages {
        stage('Checkout Terraform Sources') {
            steps {
                deleteDir()
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/Kristof95/terraform-infra.git']])
            }
        }

        stage('Prepare AMI') {
            steps {
              script {
                def latestAMI = sh returnStdout: true, script: "aws ec2 describe-images --owners self --query 'sort_by(Images, &CreationDate)[0].ImageId' | tr -d '\n'"
                def stdout = ""
                echo "Latest ami id: ${latestAMI}"
                if(latestAMI != "null") {
                  stdout = sh returnStdout: true, script: """echo 'variable \"AMI_ID\" { default = \"'${latestAMI}'\" }' > amivar.tf"""
                } 
                else {
                   sh returnStdout: true, script: '''packer build -machine-readable packer.json
                        AMI_ID=`aws ec2 describe-images --owners self --query 'sort_by(Images, &CreationDate)[0].ImageId' | tr -d '\n'`
                        echo \'variable "AMI_ID" { default = ${AMI_ID} }\' > amivar.tf'''
                }
              }
            }
        }

        stage('Infra Provisioning') {
            steps {
                script {
                    def stdout = sh returnStdout: true, script: '''
                       terraform init
                       ls -1 | grep tf | terraform validate
                       terraform plan -out plan.out
                       terraform apply plan.out'''
                    echo "Command STDOUT: ${stdout}"
                }
            }
        }
    }
}