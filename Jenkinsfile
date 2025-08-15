/**
 * A simple, streamlined Jenkinsfile for building and deploying a Docker container.
 */
pipeline {
    // Use any available agent that has Docker and Git installed.
    agent any

    stages {
        // All steps are combined into a single, easy-to-follow stage.
        stage('Build and Deploy') {
            steps {
                echo "--- Building the Docker image ---"
                // The Dockerfile in your repo handles npm install.
                // We tag the image with the unique Jenkins build number.
                sh "docker build -t simple-app:${env.BUILD_NUMBER} ."

                echo "--- Deploying the new container ---"
                // Stop and remove any container with the same name to avoid conflicts.
                sh "docker stop simple-app-container || true"
                sh "docker rm simple-app-container || true"

                // Run the new container from the image we just built.
                sh "docker run -d --name simple-app-container -p 3000:3000 simple-app:${env.BUILD_NUMBER}"

                echo "--- Verifying the running container ---"
                sh 'sleep 5'
                sh 'docker ps'
            }
        }
    }

    post {
        // This block runs after the pipeline finishes.
        always {
            echo "Pipeline finished."
        }
    }
}