pipeline {
    agent any
    environment {
        PATH    = "${PATH}:${getTerraformPath()}"
        AMI_ID  = "stack-ami-${BUILD_NUMBER}"
        VERSION = "1.0.${BUILD_NUMBER}"
        RUNNER  = "Mohamed" 
    }
    stages{
        stage('Initial Stage') {
              steps {
                script {
                def userInput = input(id: 'confirm', message: 'Start Pipeline?', parameters: [ [$class: 'BooleanParameterDefinition', defaultValue: false, description: 'Start Pipeline', name: 'confirm'] ])
             }
           }
        }
         stage('terraform init'){
             steps {
                 //sh "returnStatus: true, script: 'terraform workspace new dev'"
                 sh "terraform init"
                 slackSend (color: '#FFFF00', message: "STARTING TERRAFORM DEPLOYMENT ${env.RUNNER}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
         }
         }
         stage('terraform plan'){
             steps {
                 //sh "returnStatus: true, script: 'terraform workspace new dev'"
                 //sh "terraform apply -auto-approve"
                 sh "terraform plan -out=tfplan -input=false"
             }
         }
        stage('Final Deployment Approval') {
              steps {
                script {
                def userInput = input(id: 'confirm', message: 'Apply Terraform?', parameters: [ [$class: 'BooleanParameterDefinition', defaultValue: false, description: 'Apply terraform', name: 'confirm'] ])
             }
           }
        }
         stage('Terraform Apply'){
             steps {
                 //sh "returnStatus: true, script: 'terraform workspace new dev'"
                 //sh "terraform apply -auto-approve"
                 sh "terraform apply  -input=false tfplan"
             }
         }

          
    }
}
 def getTerraformPath(){
        def tfHome= tool name: 'terraform-14', type: 'terraform'
        return tfHome
    }
