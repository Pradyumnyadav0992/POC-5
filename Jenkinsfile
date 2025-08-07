pipeline {
    agent any

    environment {
        SONARQUBE_TOKEN  = credentials('sonar-token')
        AWS_REGION = 'us-east-1'
        ECR_REGISTRY = '963665911471.dkr.ecr.us-east-1.amazonaws.com/poc'
    }

    stages {
        stage("Git Checkout") {
            steps {
                git branch: 'main', url: 'https://github.com/Pradyumnyadav0992/POC-5.git'
            }
        }

        stage("SonarQube Analysis") {
            steps {
                withSonarQubeEnv('sonarqube') {
                    sh """
                        ${tool 'SonarQube Scanner'}/bin/sonar-scanner \
                        -Dsonar.projectKey=poc-5 \
                        -Dsonar.sources=. \
                        -Dsonar.host.url=http://54.224.7.27:9000 \
                        -Dsonar.login=${SONARQUBE_TOKEN}
                    """
                }
            }
        }

        stage("Quality Gate") {
            steps {
                waitForQualityGate abortPipeline: true
                credentialsId: 'sonar-token'
            }
        }

        stage("Docker Build") {
            steps {
                sh """
                    docker build -t ${ECR_REGISTRY}:${BUILD_NUMBER} .
                """
            }
        }

        stage("Trivy Scan") {
            steps {
                sh """
                    trivy image --exit-code 0 --severity HIGH,CRITICAL --format json -o trivy-report.json ${ECR_REGISTRY}:${BUILD_NUMBER}
                """
            }
        }

        stage("Docker Push") {
            steps {
                withCredentials([
                    string(credentialsId: 'aws-access-key', variable: 'AWS_ACCESS_KEY'),
                    string(credentialsId: 'aws-secret-key', variable: 'AWS_SECRET_KEY')
                ]) {
                    sh """
                        aws configure set aws_access_key_id $AWS_ACCESS_KEY
                        aws configure set aws_secret_access_key $AWS_SECRET_KEY
                        aws configure set region $AWS_REGION

                        aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin ${ECR_REGISTRY}
                        docker push ${ECR_REGISTRY}:${BUILD_NUMBER}
                    """
                }
            }
        }

        stage("Deployment") {
            steps {
                echo "Deployment stage (to be implemented)"
            }
        }
    }
}
