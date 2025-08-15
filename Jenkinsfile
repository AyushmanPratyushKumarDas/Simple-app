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
                    image 'docker:latest' // Container with Docker CLI
                    args """
                        -v /var/run/docker.sock:/var/run/docker.sock \
                        -v ${env.WORKSPACE}:/workspace \
                        -e HOME=/workspace
                    """
                }
            }
            steps {
                echo '--- Building Docker image ---'
                sh 'docker build -t my-app:1 /workspace'
                // Example run
                // sh 'docker run --rm -p 3000:3000 my-app:1'
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