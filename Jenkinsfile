pipeline {
  agent any
  stages {
    stage('git') {
      steps {
        git(url: 'https://github.com/g-i-coding/cypress', branch: 'main')
      }
    }

    stage('amplify build') {
      steps {
        withCredentials([string(credentialsId: 'cypress-jenkins', variable: 'AWS_CREDENTIALS')]) {
                    sh '''
                        # Configure AWS CLI
                        aws configure set aws_access_key_id "$AWS_CREDENTIALS_USR"
                        aws configure set aws_secret_access_key "$AWS_CREDENTIALS_PSW"
                        aws configure set default.region "us-east-1"
                        aws configure set default.output "json"
                    '''
        }
      }
    }

  }
}