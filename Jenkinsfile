pipeline {
  agent any

  environment {
    IMAGE_NAME = "emma2323/ci-cd-demo:${BUILD_NUMBER}"
  }

  stages {
    stage('Checkout Code') {
      steps {
        checkout([$class: 'GitSCM',
          branches: [[name: '*/master']],
          userRemoteConfigs: [[
            url: 'https://github.com/Cloud-Architect-Emma/ci-cd-demo.git',
            credentialsId: '85be80d5-f16a-44fc-81e1-b7e34ab78149'
          ]]
        ])
      }
    }

    stage('Build Docker Image') {
      steps {
        sh "docker build -t ${IMAGE_NAME} ."
      }
    }

    stage('Push to DockerHub') {
      steps {
        withCredentials([usernamePassword(
          credentialsId: 'dockerhub-user',
          usernameVariable: 'DOCKERHUB_USER',
          passwordVariable: 'DOCKERHUB_PASS'
        )]) {
          sh """
            echo "${DOCKERHUB_PASS}" | docker login -u "${DOCKERHUB_USER}" --password-stdin
            docker push ${IMAGE_NAME}
          """
        }
      }
    }
  }
}

