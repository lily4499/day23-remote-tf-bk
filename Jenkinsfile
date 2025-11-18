pipeline {
    agent any

    // 🔹 Choose what this run should do
    parameters {
        choice(
            name: 'TF_ACTION',
            choices: ['apply', 'destroy'],
            description: 'Choose whether to apply Terraform changes or destroy the VPC.'
        )
    }

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
            when {
                expression { params.TF_ACTION == 'apply' }
            }
            steps {
                sh '''
                  cd terraform
                  terraform plan -input=false -out=tfplan     # Save the plan result into a file called tfplan
                '''
            }
        }

        stage('Terraform Apply') {
            when {
                expression { params.TF_ACTION == 'apply' }
            }
            steps {
                script {
                    // Manual confirmation before applying
                    input message: 'Apply Terraform changes to AWS VPC?'
                }

                sh '''
                  cd terraform
                  terraform apply -input=false -auto-approve tfplan   # Apply exactly this plan file, don’t recalculate.
                '''
            }
        }

        stage('Terraform Destroy') {
            when {
                expression { params.TF_ACTION == 'destroy' }
            }
            steps {
                script {
                    // Manual confirmation before destroying
                    input message: '⚠️ Destroy ALL Terraform-managed resources (VPC, etc.)?'
                }

                sh '''
                  cd terraform
                  terraform destroy -input=false -auto-approve   # Destroy using current remote state.
                '''
            }
        }
    }

    post {
        always {
            echo "Pipeline finished. Action selected: ${params.TF_ACTION}"

            // Archive Terraform files for traceability
            archiveArtifacts artifacts: 'terraform/**', fingerprint: true
        }
    }
}

