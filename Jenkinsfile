/**
 * Corrected Jenkinsfile for a Node.js and Docker project.
 *
 * This pipeline uses the "agent-per-stage" approach to ensure the correct tools
 * are available for each step.
 */
pipeline {
    // 1. Define a global agent. This agent MUST have Docker installed and running.
    agent any

    environment {
        DOCKER_IMAGE = 'simple-app'
        CONTAINER_NAME = 'simple-app-container'
    }

    stages {
        // NOTE: The initial 'checkout' stage has been removed.
        // Jenkins automatically checks out the code from Git before running the 'stages' block.

        // 2. For Node.js tasks, run them inside a temporary Docker container that has Node.js.
        stage('Build and Test') {
            agent {
                // This tells Jenkins to spin up a 'node:18-alpine' container
                // and run the steps inside it. This container already has npm.
                docker { image 'node:18-alpine' }
            }
            steps {
                echo 'Installing dependencies...'
                sh 'npm install'

                echo 'Running tests...'
                sh 'npm test'
            }
        }

        // 3. For Docker tasks, run them on the main Jenkins agent (which has Docker installed).
        stage('Docker Build') {
            steps {
                script {
                    echo "Building Docker image ${DOCKER_IMAGE}:${env.BUILD_ID}..."
                    // Corrected docker.build syntax. The second argument is the build context (path).
                    // The "-f dockerfile" part is usually not needed if your file is named "Dockerfile".
                    docker.build("${DOCKER_IMAGE}:${env.BUILD_ID}", ".")
                }
            }
        }

        stage('Docker Run') {
            steps {
                script {
                    echo "Stopping and removing old container if it exists..."
                    // Using 'sh' is perfectly fine for these commands.
                    sh "docker stop ${CONTAINER_NAME} || true"
                    sh "docker rm ${CONTAINER_NAME} || true"

                    echo "Running new container..."
                    // Use docker.image().run() to run the image built in the previous stage.
                    docker.image("${DOCKER_IMAGE}:${env.BUILD_ID}").run("--name ${CONTAINER_NAME} -p 3000:3000 -d")
                }
            }
        }
    }

    // 4. The post block runs on the main agent.
    post {
        always {
            echo "Cleaning up Docker image..."
            // This command is fine. It ensures the built image is removed to save space.
            sh "docker rmi ${DOCKER_IMAGE}:${env.BUILD_ID} || true"
        }
    }
}