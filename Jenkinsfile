pipeline {
    agent any

    tools {
        nodejs 'NodeJS 7.8.0'
    }

    environment {
        // Set port based on branch name
        APP_PORT = "${env.BRANCH_NAME == 'main' ? '3005' : '3001'}"
        IMAGE_NAME = "${env.BRANCH_NAME == 'main' ? 'nodemain' : 'nodedev'}"
        IMAGE_TAG = 'v1.0'
        CONTAINER_NAME = "${env.BRANCH_NAME == 'main' ? 'app-main' : 'app-dev'}"
    }

    stages {

        stage('Declarative: Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Declarative: Tool Install') {
            steps {
                sh 'node --version'
                sh 'npm --version'
            }
        }

        stage('Build') {
            steps {
                echo "Building application for branch: ${env.BRANCH_NAME}"
                echo "Using port: ${APP_PORT}"
                sh 'npm install'
            }
        }

        stage('Test') {
            steps {
                echo "Running tests for branch: ${env.BRANCH_NAME}"
                sh 'npm test -- --watchAll=false || true'
            }
        }

        stage('Docker build') {
            steps {
                echo "Building Docker image: ${IMAGE_NAME}:${IMAGE_TAG}"
                sh """
                    docker build \
                        --build-arg BRANCH_NAME=${env.BRANCH_NAME} \
                        -t ${IMAGE_NAME}:${IMAGE_TAG} .
                """
            }
        }

        stage('Deploy') {
            steps {
                echo "Deploying to port ${APP_PORT} for branch: ${env.BRANCH_NAME}"

                // Stop and remove only the container for THIS env (branch)
                sh """
                    if [ \$(docker ps -aq -f name=${CONTAINER_NAME}) ]; then
                        docker stop ${CONTAINER_NAME} || true
                        docker rm ${CONTAINER_NAME} || true
                        echo "Removed existing container: ${CONTAINER_NAME}"
                    else
                        echo "No existing container to remove: ${CONTAINER_NAME}"
                    fi
                """

                // Run new container for this env
                sh """
                    docker run -d \
                        --name ${CONTAINER_NAME} \
                        -p ${APP_PORT}:3000 \
                        --restart unless-stopped \
                        ${IMAGE_NAME}:${IMAGE_TAG}
                """

                echo "✅ Application deployed!"
                echo "🌐 Access at: http://localhost:${APP_PORT}"
                echo "🐳 Container: ${CONTAINER_NAME}"
                echo "📦 Image: ${IMAGE_NAME}:${IMAGE_TAG}"
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline SUCCESS for branch: ${env.BRANCH_NAME}"
            echo "Application running on port: ${APP_PORT}"
        }
        failure {
            echo "❌ Pipeline FAILED for branch: ${env.BRANCH_NAME}"
        }
        always {
            echo "Pipeline finished for branch: ${env.BRANCH_NAME}"
        }
    }
}
