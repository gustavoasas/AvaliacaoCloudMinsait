pipeline {
  agent any

  tools {
    maven 'Maven'
  }

  environment {
    DOCKER_CREDENTIALS = credentials('docker-credential')
  }

  stages {
    stage('Build') {
      steps {
        script {
          echo "Construindo o projeto maven, aguarde..."
          sh 'mvn clean package'
        }
      }
    }

    stage('Testes') {
      steps {
        script {
          echo "Executando testes, aguarde..."
          sh 'mvn test'
        }
      }
    }

    stage('Build Imagem Docker') {
      steps {
        script {
          echo "Construindo a imagem docker, aguarde..."
          sh 'docker build -t gustavoasas/avaliacao-cloud:latest .'
        }
      }
    }

    stage('Push DockerHub') {
      steps {
        script {
          echo "Enviando novas alterações para o DockerHub, aguarde..."

          withCredentials([
            usernamePassword(credentialsId: 'docker-credential', passwordVariable: 'passwd', usernameVariable: 'user'
          )]) {
            sh "docker login -u ${env.user} -p ${env.passwd}"
            sh 'docker push gustavoasas/avaliacao-cloud:latest'
          }
        }
      }
    }

    stage('Kubernetes Manifestos') {
      steps {
        script {
          echo "Aplicando manifestos do Kubernetes, aguarde..."
          sh 'kubectl apply -f k8s/'
        }
      }
    }
  }
}
