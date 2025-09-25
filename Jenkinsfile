pipeline {
    agent any

    environment {
        REGISTRY       = "localhost:5000"
        IMAGE_NAME     = "demo-app"
        IMAGE_TAG      = "${env.BUILD_NUMBER}"
        DOCKER_CREDS   = "github-ssh-key"   // 在 Jenkins 凭据里配置
    }

    tools {
    maven 'maven-3.9.11'  // 在Tools里配置Maven版本及自动安装
    }

    stages {
        stage('Checkout') {
            steps {
                echo "🔄 拉取代码"
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo "🔨 构建代码"
                sh "mvn clean package -DskipTests"
            }
            post {
                always {
                     junit allowEmptyResults: true, testResults: '**/target/surefire-reports/*.xml'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "📦 构建 Docker 镜像"
                sh """
                docker build -t $REGISTRY/$IMAGE_NAME:$IMAGE_TAG .
                """
            }
        }

        stage('Push Docker Image') {
            steps {
                echo "🚀 推送 Docker 镜像"
                withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDS}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                    echo $DOCKER_PASS | docker login $REGISTRY -u $DOCKER_USER --password-stdin
                    docker push $REGISTRY/$IMAGE_NAME:$IMAGE_TAG
                    docker logout $REGISTRY
                    """
                }
            }
        }
    }

    post {
        success {
            echo "✅ 构建成功：镜像已推送 -> $REGISTRY/$IMAGE_NAME:$IMAGE_TAG"
        }
        failure {
            echo "❌ 构建失败：请检查 Jenkins 控制台日志"
        }
    }
}
