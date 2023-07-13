pipeline {
    agent any
    parameters {
      choice choices: ['dev', 'test', 'prod'], description: 'Please avail one of the environment', name: 'Environment'
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
				git branch: 'main', url: 'https://github.com/thangacodes/lms.git'
            }
        }
        stage('Build Phase'){
		    when{
		       expression {
			       params.environment == "dev"
				}
			}
            steps{
                echo "This is the stage of building artificate using maven tool"
                sh 'mvn clean package'
            }
        }
        stage('Testing Phase'){
		    when{
		       expression {
			       params.environment == "dev"
				}
			}
            steps{
                echo "This is the stage of doing manual or automation SDLC testing"
            }
        }
        stage('Deploy Phase'){
		    when{
		       expression {
			       params.environment == "dev"
				}
			}
            steps{
                echo "This is the stage of deploying jar/war file in app or web servers."
            }
        }
        stage('Sending email'){
		    when{
		       expression {
			       params.environment == "dev"
				}
			}
            steps{
                echo "This is the stage of sending emails to the admin or Job runner."
            }
        }
    }
}
