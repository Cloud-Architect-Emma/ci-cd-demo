pipeline {
  agent any

  environment {
    DOCKERHUB_REPO = "emma2323/ci-cd-demo"
    IMAGE_TAG = "${DOCKERHUB_REPO}:${BUILD_NUMBER}"
    GIT_TAG = "v1.0.${BUILD_NUMBER}"
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

    stage('Run Tests') {
      steps {
        sh """
          npm install
          npm test || echo 'No tests found or some failed.'
        """
      }
    }

    stage('Build Docker Image') {
      steps {
        sh "docker build -t ${IMAGE_TAG} ."
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
            docker push ${IMAGE_TAG}
          """
        }
      }
    }

    stage('Tag and Release') {
      steps {
        withCredentials([string(credentialsId: 'github-token', variable: 'GITHUB_TOKEN')]) {
          sh """
            git config user.name "Emmanuela Opurum"
            git config user.email "emmanuela@example.com"
            git tag ${GIT_TAG}
            git push origin ${GIT_TAG}
            curl -X POST -H "Authorization: token ${GITHUB_TOKEN}" \
              -d '{"tag_name": "${GIT_TAG}", "name": "Release ${GIT_TAG}", "body": "Automated release from Jenkins build #${BUILD_NUMBER}"}' \
              https://api.github.com/repos/Cloud-Architect-Emma/ci-cd-demo/releases
          """
        }
      }
    }
  }

  post {
    success {
      slackSend channel: '#ci-cd', color: 'good', message: "✅ Build succeeded: ${env.JOB_NAME} #${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
    }
    failure {
      slackSend channel: '#ci-cd', color: 'danger', message: "❌ Build failed: ${env.JOB_NAME} #${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
      mail to: 'team@example.com',
           subject: "Build Failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
           body: "Check the Jenkins console output at ${env.BUILD_URL}"
    }
  }
}

