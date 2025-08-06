pipeline {


    environment {
        SONARQUBE_TOKEN  = credentials('sonar-token')
        AWS_REGION = 'us-east-1'
        ECR_REGISTRY='963665911471.dkr.ecr.us-east-1.amazonaws.com/poc-project'


    }

    stages{
        stage("Git Checkout"){
               git branch: 'main' , url:'https://github.com/Pradyumnyadav0992/POC-5.git' 
        }
        
        
        stage("Sonarqube"){
            steps{
                    withSonarQubeEnv('Sonarqube') {
                        sh """
                            ${tool 'SonarQube Scanner'}/bin/sonar-scanner \
                            -Dsonar.projectKey=Poc-Project \
                            -Dsonar.sources=. \
                            -Dsonar.host.url=http://44.211.194.7:9000 \
                            -Dsonar.login=$SONARQUBE_TOKEN
                        """


                 }


        }
        }
        stage("Quality Check"){
            steps{
                waitForQualityGate abortPipeline: false,
                credentialsId: 'sonar-token'
            }

        }
        stage("docker build"){
            steps{
                sh """
                    docker build -t ${env.ECR_REGISTRY}:$BUILD_NUMBER .
                """
            }

        }
        stage("Trivy Scan"){
            steps{
                sh """
                trivy image  --exit-code 0 --severity HIGH,CRITICAL --format json -o "trivy-report.json" "${env.ECR_REGISTRY}:$BUILD_NUMBER"
                """
            }


        }
        stage("docker push"){
            steps {
                withCredentials([string(credentialsId: 'aws-access-key', variable: 'AWS_ACCESS_KEY'), 
                                 string(credentialsId: 'aws-secret-key', variable: 'AWS_SECRET_KEY')]) {
                    sh """
                    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${env.ECR_REGISTRY}
					docker push ${env.ECR_REGISTRY}:$BUILD_NUMBER
                    """
                }
            }

        }

        stage("Deployment"){
            echo "deployment"
        }
    }
}


