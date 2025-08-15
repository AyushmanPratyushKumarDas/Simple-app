/**
 * A simple pipeline to build a Docker image and run it as a container.
 */
pipeline {
    // This pipeline will run on any available Jenkins agent.
    // The agent MUST have Git and Docker installed.
    agent any

    stages {
        stage('Build and Run') {
            steps {
                // Step 1: Check out the source code from your Git repository.
                echo '--- Checking out code ---'
                checkout scm

                // Step 2: Build the Docker image from your Dockerfile.
                // The image is tagged with the Jenkins build number for uniqueness.
                echo '--- Building Docker image ---'
                sh "docker build -t my-app:${env.BUILD_NUMBER} ."

                // Step 3: Stop and remove any old container with the same name.
                // This prevents errors if the pipeline is run more than once.
                echo '--- Cleaning up old containers ---'
                sh "docker stop my-app-container || true"
                sh "docker rm my-app-container || true"

                // Step 4: Run a new container from the image we just built.
                // -d runs the container in the background.
                // --name gives the container a consistent name.
                // -p maps port 8080 on the server to port 3000 in the container.
                echo '--- Starting new container ---'
                sh "docker run -d --name my-app-container -p 8080:3000 my-app:${env.BUILD_NUMBER}"

                echo '--- Done! ---'
                sh 'docker ps'
            }
        }
    }
}