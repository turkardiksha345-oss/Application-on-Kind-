pipeline {
  agent any

  environment {
    IMAGE_TAG = "${BUILD_NUMBER}"
    JFROG_URL = "jfrog.example.com"   // ❗ no https
    JFROG_REPO = "docker-local"

    BACKEND_IMAGE = "${JFROG_URL}/${JFROG_REPO}/student-registration-backend:${IMAGE_TAG}"
    FRONTEND_IMAGE = "${JFROG_URL}/${JFROG_REPO}/student-registration-frontend:${IMAGE_TAG}"

    BACKEND_LATEST = "${JFROG_URL}/${JFROG_REPO}/student-registration-backend:latest"
    FRONTEND_LATEST = "${JFROG_URL}/${JFROG_REPO}/student-registration-frontend:latest"

    NAMESPACE = "student-registration"
  }

  stages {

    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Docker Login to JFrog') {
      steps {
        withCredentials([usernamePassword(
          credentialsId: 'jfrog-docker-creds',
          usernameVariable: 'JFROG_USER',
          passwordVariable: 'JFROG_PASSWORD'
        )]) {
          sh '''
            echo "$JFROG_PASSWORD" | docker login $JFROG_URL -u "$JFROG_USER" --password-stdin
          '''
        }
      }
    }

    stage('Build Images') {
      steps {
        sh '''
          docker build -t $BACKEND_IMAGE -f backend/Dockerfile backend
          docker build -t $FRONTEND_IMAGE -f frontend/Dockerfile frontend

          docker tag $BACKEND_IMAGE $BACKEND_LATEST
          docker tag $FRONTEND_IMAGE $FRONTEND_LATEST
        '''
      }
    }

    stage('Push Images') {
      steps {
        sh '''
          docker push $BACKEND_IMAGE
          docker push $FRONTEND_IMAGE

          docker push $BACKEND_LATEST
          docker push $FRONTEND_LATEST
        '''
      }
    }

    stage('Deploy to Kubernetes') {
      steps {
        withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG_PATH')]) {
          sh '''
            export KUBECONFIG="$KUBECONFIG_PATH"

            # Ensure namespace exists
            kubectl get ns $NAMESPACE || kubectl create ns $NAMESPACE

            # Apply manifests
            kubectl apply -k k8s

            # Update images dynamically
            kubectl set image deployment/student-backend backend=$BACKEND_IMAGE -n $NAMESPACE
            kubectl set image deployment/student-frontend frontend=$FRONTEND_IMAGE -n $NAMESPACE

            # Wait for rollout
            kubectl rollout status deployment/student-backend -n $NAMESPACE
            kubectl rollout status deployment/student-frontend -n $NAMESPACE
          '''
        }
      }
    }

    stage('Cleanup') {
      steps {
        sh '''
          docker system prune -af || true
        '''
      }
    }
  }

  post {
    success {
      echo "✅ Deployment successful!"
    }
    failure {
      echo "❌ Pipeline failed. Check logs."
    }
  }
}