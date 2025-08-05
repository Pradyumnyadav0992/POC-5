pipeline {
    agent {
        node {
        label 'Slave_node1'
        customWorkspace '/home/ubuntu/jenkins_workspace/' 
        }
    }
	
	tools {
	    ansible 'ansible-agent'
        maven 'Maven_3.9.6'  
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Pradyumnyadav0992/poc-2.git '
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }

		stage('Deploy') {
			steps {
				ansiblePlaybook(
					playbook: 'deploy.yml',
					inventory: 'localhost,',
					extraVars: [
						war_src: "${env.WORKSPACE}/target/poc-2.war"
					]
				)
			}
		}

		
		stage('Cleanup Workspace') {
            steps {
                cleanWs()
            }
        }
		
    }
}
