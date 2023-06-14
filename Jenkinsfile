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
        withCredentials([[
          $class: 'AmazonWebServicesCredentialsBinding',
          credentialsId: "cypress-jenkins",
          accessKeyVariable: 'AWS_ACCESS_KEY_ID',
          secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
        ]]) {
            sh '''
            appid=$(aws amplify list-apps --query 'apps[0].appId')
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