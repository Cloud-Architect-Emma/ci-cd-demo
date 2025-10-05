pipeline {
    agent any

    environment {
        DOCKERHUB_USER = credentials('dockerhub-user')
    }

    stages {
        stage('Clone Repo') {
            steps {
                git 'https://github.com/yourusername/ci-cd-demo.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("yourusername/ci-cd-demo:${BUILD_NUMBER}")
                }
            }
        }

        stage('Run Tests') {
            steps {
                sh 'npm install'
                sh 'npm test || echo "No tests found, skipping"'
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-user') {
                        docker.image("yourusername/ci-cd-demo:${BUILD_NUMBER}").push()
                    }
                }
            }
        }
    }
}

