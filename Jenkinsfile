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
                deleteDir()
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

        stage('Prepare AMI') {
            steps {
              script {
                def latestAMI = sh returnStdout: true, script: "aws ec2 describe-images --owners self --query 'sort_by(Images, &CreationDate)[0].ImageId' | xargs"
                echo "Latest ami id: ${latestAMI}"
                if(latestAMI) {
                   sh returnStdout: true, script: """echo 'variable \"AMI_ID\" { default = \"'${latestAMI}'\" }' > amivar.tf"""
                } 
                else {
                    sh returnStdout: true, script: '''
                        ARTIFACT=`packer build -machine-readable packer.json |awk -F, \'$0 ~/artifact,0,id/ {print $6}\'`
                        AMI_ID=`echo $ARTIFACT | cut -d \':\' -f2`
                        echo \'variable "AMI_ID" { default = "\'${AMI_ID}\'" }\' > amivar.tf'''
                }
              }
            }
        }

        stage('Infra Provisioning') {
            steps {
                script {
                    sh returnStdout: true, script: '''
                       TF_FILES=(`ls -1 | grep tf`)
                       for item in ${TF_FILES[@]};do terraform validate \"$item\";done
                       terraform plan -out output.tf
                    '''
                }
            }
        }

    }
}