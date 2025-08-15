/**
 * An improved pipeline that builds and deploys a Docker container.
 * It uses a Docker agent to be self-contained and a post block for reliable cleanup.
 */
pipeline {
    // Use a Docker agent for the entire pipeline. This removes the need for
    // Docker to be manually installed on the agent machine.
    agent {
        docker {
            image 'docker:latest'
            args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    environment {
        // Define the image name as a variable for easy reuse.
        IMAGE_NAME = "my-app:${env.BUILD_NUMBER}"
        CONTAINER_NAME = "my-app-container"
    }

    stages {
        stage('Build') {
            steps {
                echo "--- Building Docker image: ${IMAGE_NAME} ---"
                // The checkout step must be inside a stage when a global agent is defined.
                checkout scm
                sh "docker build -t ${IMAGE_NAME} ."
            }
        }

        stage('Deploy') {
            steps {
                echo "--- Deploying container: ${CONTAINER_NAME} ---"
                // First, stop and remove the old container to avoid port conflicts.
                // The '|| true' prevents the build from failing if the container doesn't exist yet.
                sh "docker stop ${CONTAINER_NAME} || true"
                sh "docker rm ${CONTAINER_NAME} || true"

                // Run the new container from the image we just built.
                sh "docker run -d --name ${CONTAINER_NAME} -p 8080:3000 ${IMAGE_NAME}"
            }
        }
    }

    post {
        // This block runs after all stages are complete.
        success {
            echo '--- Pipeline Successful! ---'
            sh 'docker ps'
        }
        failure {
            echo '--- Pipeline Failed! ---'
        }
    }
}