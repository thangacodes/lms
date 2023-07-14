pipeline {
    agent any
    parameters {
      choice choices: ['dev', 'test', 'prod'], description: 'Please avail one of the environment', name: 'Environment'
	}
    stages {
       stage('Code Checkout') {
		   when{
		      expression {
			  params.Environment == "dev"
				}
			}
            steps {
		 sh "Code checkout in progress..."
	         git branch: 'main', url: 'https://github.com/thangacodes/lms.git'
            }
        }
        stage('MVN Build'){
		   when{
		      expression {
			    params.Environment == "dev"
				}
			}
            steps{
                echo "Maven build in progress..."
                sh 'mvn clean package'
            }
        }
        stage('Artifact Upload'){
		   when{
		     expression {
			   params.Environment == "dev"
			}
		}
            steps{
                echo "Artifact like war file uploading to the S3 bucket..."
		sh '''
                pwd
		cd target/
                ls -lrt
		aws s3 cp lms.war s3://gitops-demo-bucket-tf/Java_Build_Artifacts/
		'''
            }
        }
        stage('Deploy Phase'){
		    when{
		       expression {
			    params.Environment == "dev"
				}
			}
            steps{
                echo "Terraform Script kicks in..."
		sh '''
		cd Iac/
		ls -lrt
		terraform init
	        terraform fmt
		terraform validate
		 terraform plan
		'''
            }
        }
        stage('Sending email'){
		    when{
		       expression {
			    params.Environment == "dev"
				}
			}
            steps{
                echo "Sending email to the Build & Release on the Job Status..."
            }
        }
    }
}
