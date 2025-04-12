pipeline {
    agent any

    environment {
        ACR_NAME = 'codecraftacr'
        IMAGE_NAME = 'taskmanager-api'
        IMAGE_TAG = 'latest'
        DOCKER_CLI_EXPERIMENTAL = 'enabled'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${ACR_NAME}.azurecr.io/${IMAGE_NAME}:${IMAGE_TAG}")
                }
            }
        }

        stage('Login to ACR') {
            steps {
                script {
                    azureLogin()
                    docker.withRegistry("https://${ACR_NAME}.azurecr.io", "azure-service-principal") {
                        docker.image("${ACR_NAME}.azurecr.io/${IMAGE_NAME}:${IMAGE_TAG}").push()
                    }
                }
            }
        }

        stage('Deploy to AKS') {
            steps {
                script {
                    sh 'kubectl apply -f k8s/deployment.yaml'
                    sh 'kubectl apply -f k8s/service.yaml'
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}

def azureLogin() {
    withCredentials([string(credentialsId: 'azure-service-principal', variable: 'AZURE_CREDENTIALS_JSON')]) {
        writeFile file: 'azureauth.json', text: AZURE_CREDENTIALS_JSON
        def clientId = sh(script: "jq -r .clientId azureauth.json", returnStdout: true).trim()
        def clientSecret = sh(script: "jq -r .clientSecret azureauth.json", returnStdout: true).trim()
        def tenantId = sh(script: "jq -r .tenantId azureauth.json", returnStdout: true).trim()
        def subscriptionId = sh(script: "jq -r .subscriptionId azureauth.json", returnStdout: true).trim()

        sh """
            az login --service-principal -u $clientId -p $clientSecret --tenant $tenantId
            az account set --subscription $subscriptionId
            az acr login --name ${ACR_NAME}
            az aks get-credentials --resource-group codecraft-rg --name codecraft-aks
        """
    }
}
