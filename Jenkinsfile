/**
 * Improved Jenkinsfile for a Node.js and Docker project.
 *
 * Key Features:
 * 1. `agent none`: Forces each stage to declare its own environment for clarity.
 * 2. Caching: Caches npm dependencies to speed up subsequent builds.
 * 3. Git Commit Tagging: Tags Docker images with the Git commit hash for better traceability.
 * 4. Self-Contained Stages: Uses Docker agents for both Node.js and Docker commands.
 */
pipeline {
    // 1. Set top-level agent to 'none'.
    // This is a best practice that forces every stage to explicitly define its
    // execution environment, preventing accidental runs on the wrong agent.
    agent none

    environment {
        // Define the image name centrally
        DOCKER_IMAGE   = 'simple-app'
        CONTAINER_NAME = 'simple-app-container'
    }

    stages {
        stage('Build and Test') {
            // 2. Define a specific agent for this stage.
            // Jenkins will start a temporary 'node:18-alpine' container
            // and run the steps inside it.
            agent {
                docker {
                    image 'node:18-alpine'
                    // 3. Add caching for npm dependencies.
                    // This maps a directory from the host workspace into the container.
                    // The 'npm install' will be much faster on subsequent runs.
                    args '-v ${WORKSPACE}/.cache/npm:/root/.npm'
                }
            }
            steps {
                echo '--- Installing Dependencies (with caching) ---'
                sh 'npm install'

                echo '--- Running Tests ---'
                sh 'npm test'
            }
        }

        // 4. Group Docker-related tasks under a parent stage for better UI visualization.
        stage('Build and Publish Image') {
            // 5. Use a self-contained Docker agent for building the image.
            // This runs steps inside a container that has the Docker client,
            // which communicates with the host's Docker daemon via the mounted socket.
            // This avoids the "docker: not found" error without installing Docker in the agent's PATH.
            agent {
                docker {
                    image 'docker:24.0' // A recent, specific version of the Docker image
                    args '-v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            steps {
                script {
                    // 6. Use the Git commit hash for the image tag for better traceability.
                    def shortCommit = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
                    def taggedImage = "${DOCKER_IMAGE}:${shortCommit}"

                    echo "--- Building Docker image: ${taggedImage} ---"
                    docker.build(taggedImage, ".")

                    // Optional: Push to a registry
                    // withRegistry('https://your-registry.com', 'your-credentials-id') {
                    //     docker.image(taggedImage).push()
                    // }
                }
            }
        }

        stage('Deploy') {
            // This stage also needs to run on an agent that can execute Docker commands.
            agent {
                docker {
                    image 'docker:24.0'
                    args '-v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            steps {
                script {
                    def shortCommit = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
                    def taggedImage = "${DOCKER_IMAGE}:${shortCommit}"

                    echo '--- Stopping and removing old container ---'
                    // The '|| true' prevents the build from failing if the container doesn't exist
                    sh "docker stop ${CONTAINER_NAME} || true"
                    sh "docker rm ${CONTAINER_NAME} || true"

                    echo "--- Running new container from image ${taggedImage} ---"
                    docker.image(taggedImage).run("--name ${CONTAINER_NAME} -p 3000:3000 -d")

                    echo '--- Verifying container status ---'
                    sh 'sleep 5' // Wait a few seconds for the app to start
                    sh 'docker ps'
                }
            }
        }
    }

    post {
        // The 'post' block also needs an explicit agent if the top-level agent is 'none'.
        always {
            agent {
                docker {
                    image 'docker:24.0'
                    args '-v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            steps {
                echo '--- Post-build cleanup ---'
                // Stop and remove the container
                sh "docker stop ${CONTAINER_NAME} || true"
                sh "docker rm ${CONTAINER_NAME} || true"

                // Note: We don't remove the image here, as it might be the active deployment.
                // Image cleanup is typically handled by a separate, scheduled Jenkins job.
            }
        }
    }
}