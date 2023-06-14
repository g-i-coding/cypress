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
        withCredentials(bindings: [string(credentialsId: 'cypress-jenkins', variable: 'AWS_CREDENTIALS')]) {
          sh '''
            appid=$(aws amplify list-apps --query \'apps[0].appId\')
            aws amplify start-job --app-id ${appid} --branch-name main --job-type RELEASE
            '''
        }

      }
    }

  }

  triggers {
    githubPush()
  }
}