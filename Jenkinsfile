pipeline {
    agent any // The pipeline will start on any available agent

    stages {
        stage('Checkout Code') {
            steps {
                echo '--- Checking out code ---'
                checkout scm
            }
        }
        stage('Build and Run') {
            // Use a Docker agent for this stage
            agent {
                docker {
                    image 'docker:latest' // Use a Docker image that has the Docker CLI
                    args '-v /var/run/docker.sock:/var/run/docker.sock' // Mount the Docker socket
                }
            }
            steps {
                echo '--- Building Docker image ---'
                sh 'docker build -t my-app:1 .' // This will now work
                // Add your 'docker run' or 'docker push' commands here
            }
        }
    }
}