pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/your-repo/simple-app.git'
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
        
        stage('Docker Build & Run') {
            steps {
                script {
                    docker.build("simple-app:${env.BUILD_ID}").run("--rm -p 3000:3000")
                }
            }
        }
    }
}