pipeline {
  agent any

  environment {
    PROJECT_ID = 'homework2-452219'
    CLUSTER_NAME = 'survey-cluster'
    CLUSTER_ZONE = 'us-east4-a'
    IMAGE_NAME = 'ramshak123/backend-survey'
    IMAGE_TAG = 'latest'
    FULL_IMAGE = "${IMAGE_NAME}:${IMAGE_TAG}"
    DEPLOYMENT_NAME = 'student-survey-deployment'
  }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/rkapadi/SWE645assign2'
            }
        }

        stage('Build JAR') {
            steps {
                sh './mvnw clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${FULL_IMAGE} ."
            }
        }

        stage('Docker Hub Login & Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                sh """
                    echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                    docker push ${FULL_IMAGE}
                """
                }
            }
        }

        stage('Configure GKE') {
            steps {
                withCredentials([file(credentialsId: 'gcp-key', variable: 'GCLOUD_KEY')]) {
                sh """
                    gcloud auth activate-service-account --key-file=$GCLOUD_KEY
                    gcloud config set project $PROJECT_ID
                    gcloud config set compute/zone $CLUSTER_ZONE
                    gcloud container clusters get-credentials $CLUSTER_NAME
                """
                }
            }
        }

        stage('Deploy to GKE') {
            steps {
                sh """
                kubectl set image deployment/${DEPLOYMENT_NAME} backend-survey=${FULL_IMAGE} || \
                kubectl apply -f k8s/
                """
            }
        }
    }

    post {
        success {
            echo "Successfully deployed to GKE"
        }
        failure {
            echo "Deployment failed"
        }
    }
}



// pipeline {
//     agent any

//     environment {
//         PROJECT_ID = 'homework2-452219'
//         IMAGE_NAME = 'us-east4-docker.pkg.dev/homework2-452219/my-repo/ramshak123/surveyyy'
//     }

//     stages {
//         stage('Clone Repository') {
//             steps {
//                 cleanWs()
//                 git credentialsId: 'git-token', url: 'https://github.com/rkapadi/SWE645assign2', branch: 'main'
//             }
//         }

//         stage('Check Git Status') {
//             steps {
//                 sh 'git status'
//             }
//         }

//         stage('Test Docker') {
//             steps {
//                 sh 'docker version'
//             }
//         }

//         stage('Build Docker Image') {
//             steps {
//                 sh 'docker build -t "$IMAGE_NAME:$BUILD_NUMBER" .'
//             }
//         }

//         stage('Push to Artifact Registry') {
//             steps {
//                 withCredentials([file(credentialsId: 'gcp-key', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
//                     sh 'gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS'
//                     sh 'gcloud auth configure-docker us-east4-docker.pkg.dev'
//                     sh 'docker push "$IMAGE_NAME:$BUILD_NUMBER"'
//                 }
//             }
//         }

//         stage('Deploy to GKE') {
//             steps {
//                 withCredentials([file(credentialsId: 'gcp-key', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
//                     sh '''
//                     gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS
//                     gcloud config set project homework2-452219
//                     gcloud container clusters get-credentials survey-cluster --zone us-east4-a
//                     kubectl set image deployment/deployment-2 surveyyy-sha256-1="$IMAGE_NAME:$BUILD_NUMBER" --record
//                     '''
//                 }
//             }
//         }
//     }
// }