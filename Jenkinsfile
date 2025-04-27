pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        TF_IN_AUTOMATION      = '1'
    }

    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically apply without manual approval?')
    }

    stages {
        stage('Plan') {
            steps {
                dir('terraform/code') {
                    bat """
                        terraform init -input=false
                        terraform plan -input=false -out=tfplan --var-file=terraform.tfvars ^
                            -var AWS_ACCESS_KEY_ID=%AWS_ACCESS_KEY_ID% ^
                            -var AWS_SECRET_ACCESS_KEY=%AWS_SECRET_ACCESS_KEY%
                        terraform show -no-color tfplan > tfplan.txt
                    """
                }
            }
        }

        stage('Approval') {
            when {
                not {
                    equals expected: true, actual: params.autoApprove
                }
            }
            steps {
                script {
                    def plan = readFile 'terraform/code/tfplan.txt'
                    input message: "Please review the plan before applying.", parameters: [
                        text(name: 'Terraform Plan', defaultValue: plan, description: 'Review the Terraform changes')
                    ]
                }
            }
        }

        stage('Apply') {
            steps {
                dir('terraform/code') {
                    bat "terraform apply -input=false tfplan"
                }
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'terraform/code/tfplan.txt'
        }
    }
}
