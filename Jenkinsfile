pipeline {
    agent any

    environment {
        PROJECT_ID = 'homework2-452219'
        IMAGE_NAME = 'us-east4-docker.pkg.dev/homework2-452219/my-repo/ramshak123/surveyyy:latest'
    }

    stages {
        stage('Clone Repository') {
            steps {
                cleanWs()
                git credentialsId: 'git-token', url: 'https://github.com/rkapadi/SWE645assign2', branch: 'main'
            }
        }

        stage('Check Git Status') {
            steps {
                sh 'git status'
            }
        }

        stage('Test Docker') {
            steps {
                sh 'docker version'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t "$IMAGE_NAME:$BUILD_NUMBER" .'
            }
        }

        stage('Push to Artifact Registry') {
            steps {
                withCredentials([file(credentialsId: 'gcp-key', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                    sh 'gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS'
                    sh 'gcloud auth configure-docker us-east4-docker.pkg.dev'
                    sh 'docker push "$IMAGE_NAME:$BUILD_NUMBER"'
                }
            }
        }

        stage('Deploy to GKE') {
            steps {
                withCredentials([file(credentialsId: 'gcp-key', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                    sh '''
                    gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS
                    gcloud config set project homework2-452219
                    gcloud container clusters get-credentials survey-cluster --zone us-east4-a
                    kubectl set image deployment/survey-app survey-app="$IMAGE_NAME:BUILD_NUMBER" --record
                    '''
                }
            }
        }
    }
}