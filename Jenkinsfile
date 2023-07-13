pipeline {
    agent any
    parameters {
       choice choices: ['dev', 'test', 'pre-prod', 'prod'], description: 'Available environments', name: 'Environment'
    }
    
    stages {
        stage('Git Phase') {
		   when{
		       expression {
			       params.environment == "dev"
				}
			}
            steps {
                echo "This is the stage of Git cloning!"
				git branch: 'main', url: 'https://github.com/thangacodes/tf_ansible_cicd_project.git'
            }
        }
        stage('Build Phase'){
            steps{
                echo "This is the stage of building artificate using maven tool"
                sh 'mvn clean package'
            }
        }
        stage('Testing Phase'){
            steps{
                echo "This is the stage of doing manual or automation SDLC testing"
            }
        }
        stage('Deploy Phase'){
            steps{
                echo "This is the stage of deploying the product in app or web servers."
            }
        }
        stage('Sending email'){
            steps{
                echo "This is the stage of sending emails to the admin or Job runner."
            }
        }
    }
}
