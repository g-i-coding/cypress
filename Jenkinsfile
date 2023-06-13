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
        withCredentials([usernamePassword(credentialsId: 'aws-credentials', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh '''
                        # Configure AWS CLI
                        aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID"
                        aws configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY"
                        aws configure set default.region "us-east-1"
                        aws configure set default.output "json"
                    '''
        }
      }
    }

  }
}