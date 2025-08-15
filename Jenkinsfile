pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'simple-app'
        CONTAINER_NAME = 'simple-app-container'
    }
    
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/AyushmanPratyushKumarDas/Simple-app.git'
            }
        }
        
        stage('Build') {
            steps {
                sh 'npm install'
            }
        }
        
        stage('Test') {
            steps {
                sh 'npm test'
            }
        }
        
        stage('Docker Build') {
            steps {
                script {
                    dockerImage = docker.build("${DOCKER_IMAGE}:${env.BUILD_ID}", "-f dockerfile .")
                }
            }
        }
        
        stage('Docker Run') {
            steps {
                script {
                    sh "docker stop ${CONTAINER_NAME} || true"
                    sh "docker rm ${CONTAINER_NAME} || true"
                    dockerImage.run("--name ${CONTAINER_NAME} -p 3000:3000 -d")
                }
            }
        }
    }
    
    post {
        always {
            sh "docker rmi ${DOCKER_IMAGE}:${env.BUILD_ID} || true"
        }
    }
}