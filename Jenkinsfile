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
        withAWS(credentials: 'cypress-jenkins') {
                    sh '''
                      aws amplify list-apps
                    '''
        }
      }
    }

  }
}