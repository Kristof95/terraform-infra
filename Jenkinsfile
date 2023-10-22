pipeline {
    agent {
        label 'Monster'
    }

    tools {
        nodejs 'NodeJS 21.0.0'
    }

    stages {
        stage('Checkout Terraform Sources') {
            steps {
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/Kristof95/terraform-infra.git']])
            }
        }

        stage('Generate Keys') {
            steps {
                script {
                    sh "yes '' | ssh-keygen -f mykey -N '' > /dev/null"
                }
            }
        }

        stage('Build AMI') {
            steps {
              script {
                sh returnStdout: true, script: '''
                    ARTIFACT=`packer build -machine-readable packer.json |awk -F, \'$0 ~/artifact,0,id/ {print $6}\'`
                    AMI_ID=`echo $ARTIFACT | cut -d \':\' -f2`
                    echo \'variable "AMI_ID" { default = "\'${AMI_ID}\'" }\' > amivar.tf'''
              }
            }
        }

        stage('Infra Provisioning') {
            steps {
                script {
                    sh returnStdout: true, script: "terraform init && terraform validate *.tf && cat amivar.tf"
                }
            }
        }

    }
}