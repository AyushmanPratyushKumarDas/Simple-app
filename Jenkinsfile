pipeline {
    agent any

    stages {
        stage('Checkout Code') {
            steps {
                echo '--- Checking out code ---'
                checkout scm
            }
        }
        stage('Build and Run') {
            agent {
                docker {
                    image 'docker:latest'
                    args '-v /var/run/docker.sock:/var/run/docker.sock -u root'
                }
            }
            steps {
                echo '--- Building Docker image ---'
                sh 'docker build -t my-app:1 .'
            }
        }
    }
    post {
        always {
            echo '--- Cleaning up ---'
            sh 'docker system prune -f'
        }
    }
}                                                           