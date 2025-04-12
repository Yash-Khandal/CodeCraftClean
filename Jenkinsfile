pipeline {
    agent any

    environment {
        IMAGE_NAME = "taskmanager-api"
        REGISTRY = "codecraftacr.azurecr.io"
        TAG = "latest"
    }

    stages {
        stage('Clone') {
            steps {
                git branch: 'main', url: 'https://github.com/Yash-Khandal/CodeCraftClean.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t $REGISTRY/$IMAGE_NAME:$TAG ./app"
                }
            }
        }

        stage('Login to ACR') {
            steps {
                script {
                    sh "az acr login --name codecraftacr"
                }
            }
        }

        stage('Push Image') {
            steps {
                script {
                    sh "docker push $REGISTRY/$IMAGE_NAME:$TAG"
                }
            }
        }

        stage('Deploy to AKS') {
            steps {
                script {
                    sh "kubectl apply -f k8s/deployment.yaml"
                    sh "kubectl apply -f k8s/service.yaml"
                }
            }
        }
    }
}
