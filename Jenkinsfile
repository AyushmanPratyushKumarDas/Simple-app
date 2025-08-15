/**
 * A streamlined Jenkinsfile for building, testing, and deploying a Dockerized Node.js application.
 *
 * This pipeline calculates variables once and uses Docker agents for each step, ensuring a clean and
 * reproducible build environment.
 */
pipeline {
    // Top-level agent is 'none' to enforce explicit environments for each stage.
    agent none

    environment {
        // Centralized variables for the pipeline.
        DOCKER_IMAGE   = 'simple-app'
        CONTAINER_NAME = 'simple-app-container'
        // This will be populated in the 'Prepare' stage.
        GIT_COMMIT     = ''
    }

    stages {
        stage('Prepare') {
            // Use a lightweight agent to check out code and get the Git commit hash.
            agent {
                docker { image 'node:18-alpine' }
            }
            steps {
                script {
                    echo '--- Checking out source code and getting commit hash ---'
                    // Explicitly check out the code.
                    checkout scm
                    // Calculate the commit hash ONCE and save it as an environment variable.
                    env.GIT_COMMIT = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
                }
            }
        }

        stage('Build and Test') {
            // Run Node.js steps inside a Node container, with caching for speed.
            agent {
                docker {
                    image 'node:18-alpine'
                    args '-v ${WORKSPACE}/.cache/npm:/root/.npm'
                }
            }
            steps {
                echo '--- Installing Dependencies ---'
                sh 'npm install'

                echo '--- Running Tests ---'
                sh 'npm test'
            }
        }

        stage('Build Docker Image') {
            // Use a Docker agent to run Docker commands.
            agent {
                docker {
                    image 'docker:24.0'
                    args '-v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            steps {
                script {
                    def taggedImage = "${env.DOCKER_IMAGE}:${env.GIT_COMMIT}"
                    echo "--- Building Docker image: ${taggedImage} ---"
                    docker.build(taggedImage, ".")
                }
            }
        }

        stage('Deploy') {
            // Use a Docker agent for deployment commands.
            agent {
                docker {
                    image 'docker:24.0'
                    args '-v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            steps {
                script {
                    def taggedImage = "${env.DOCKER_IMAGE}:${env.GIT_COMMIT}"
                    echo '--- Stopping and removing any old container ---'
                    sh "docker stop ${env.CONTAINER_NAME} || true"
                    sh "docker rm ${env.CONTAINER_NAME} || true"

                    echo "--- Running new container from image ${taggedImage} ---"
                    docker.image(taggedImage).run("--name ${env.CONTAINER_NAME} -p 3000:3000 -d")
                }
            }
        }
    }

    post {
        // This block runs after all stages, regardless of the outcome.
        always {
            // Use a Docker agent for cleanup commands.
            agent {
                docker {
                    image 'docker:24.0'
                    args '-v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            steps {
                echo '--- Post-build cleanup: ensuring container is stopped ---'
                sh "docker stop ${env.CONTAINER_NAME} || true"
                sh "docker rm ${env.CONTAINER_NAME} || true"
            }
        }
    }
}