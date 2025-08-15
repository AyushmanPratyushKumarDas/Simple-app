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
            steps {
                echo '--- Building Docker image ---'
                sh 'docker build -t my-app:1 .'
                sh 'docker run --rm -p 3000:3000 my-app:1'
            }
        }
    }
}
