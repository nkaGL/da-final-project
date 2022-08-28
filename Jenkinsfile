pipeline {
    agent { label 'aws-agent' }
    stages {
        stage('Initialization') {
            steps {
                sh '''
                sudo yum update -y
                sudo amazon-linux-extras install docker -y
                sudo systemctl enable docker
                sudo service docker start
                
                DIR="/home/ec2-user/workspace/demo-pipeline/dev"
                if [ -d "$DIR" ]
                then
                    cd $DIR
                else
                    cd /home/ec2-user/workspace/demo-pipeline/
                    mkdir dev
                    cd dev
                fi
                
                wget https://releases.hashicorp.com/terraform/1.2.8/terraform_1.2.8_linux_amd64.zip
                unzip terraform_1.2.8_linux_amd64.zip
                rm terraform_1.2.8_linux_amd64.zip
                sudo mv terraform /usr/bin
                
                REPO="/home/ec2-user/workspace/demo-pipeline/dev/da-final-project"
                if [ -d "$REPO" ]
                then
                    cd $REPO
                else
                    cd /home/ec2-user/workspace/demo-pipeline/dev
                    git clone https://github.com/nkaGL/da-final-project.git
                    cd da-final-project
                fi

                git checkout dev
                git pull
                
                '''
            }
        }
        
        stage('Build') {
            steps {
                sh '''
                cd /home/ec2-user/workspace/demo-pipeline/dev/da-final-project
                ./gradlew build
                '''
            }
        }
        stage('Tests') {
            steps {
                sh '''
                cd /home/ec2-user/workspace/demo-pipeline/dev/da-final-project
                echo "integration tests performance"
                echo "opensource tests performance"
                '''
                
            }
        }
        stage('Static Code Analysis') {
            steps {
                sh '''
                cd /home/ec2-user/workspace/demo-pipeline/dev/da-final-project

                echo "sonarcloud or sonarcube tests"
                ''' 
                //                ./gradle lint
                
            }
        }
        stage('Dockerization') {
            steps {
                sh '''
                cd /home/ec2-user/workspace/demo-pipeline/dev/da-final-project
                now=$(date +"%d%m%Y")
                sudo docker build . -t "jenkins-build-"$now
                '''
                
            }
        }
        
        stage('Deploy To AWS') {
            environment {
                AWS_ACCESS_KEY_ID = credentials('access-key')
                AWS_SECRET_ACCESS_KEY = credentials('secret-key')
              }
            steps {
                sh '''
                cd /home/ec2-user/workspace/demo-pipeline/dev/da-final-project/.terraform
                terraform init
                terraform apply -auto-approve
                sleep 60
                
                '''
                
            }
        }
    }
}
