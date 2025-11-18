pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
        TF_IN_AUTOMATION   = 'true'
    }

    options {
        timestamps()
    }

    stages {
        stage('Checkout') {
            steps {
                // Pull code from your Git repo
                git branch: 'main', url: 'https://github.com/lily4499/day23-remote-tf-bk.git'
            }
        }

        
        stage('Terraform Init') {
            steps {
                sh '''
                  cd terraform
                  terraform init -input=false               # Do not ask me any interactive questions.
                '''
            }
        }

        stage('Terraform Plan') {
            steps {
                sh '''
                  cd terraform
                  terraform plan -input=false -out=tfplan     # Save the plan result into a file called tfplan
                '''
            }
        }

        stage('Terraform Apply') {
            when {
                branch 'main'   // only auto-apply on main branch
            }
            steps {
                // Optional manual approval before apply
                script {
                    input message: 'Apply Terraform changes to AWS VPC?'
                }

                sh '''
                  cd terraform
                  terraform apply -input=false -auto-approve tfplan   #Apply exactly this plan file, don’t recalculate.
                '''
            }
        }
    }

    post {
        always {
            echo "Pipeline finished."

            // Archive Terraform logs / plan if you want
            archiveArtifacts artifacts: 'terraform/**', fingerprint: true
            // Save all Terraform files from this build into Jenkins, and track them so I know which build they came from.
        }
    }
}
