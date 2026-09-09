node {

    stage('Checkout') {
        checkout scm
    }

    stage('Build') {
        sh 'mvn validate'
        sh 'mvn compile'
    }

    stage('Test') {
        sh 'mvn test'
    }

    stage('SonarQube Analysis') {
        withSonarQubeEnv('SonarQube1') {
            withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_TOKEN')]) {
                sh '''
                    mvn org.sonarsource.scanner.maven:sonar-maven-plugin:5.2.0.4988:sonar \
                    -Dsonar.projectKey=maven-web-app \
                    -Dsonar.token=$SONAR_TOKEN
                '''
            }
        }
    }

    stage('Quality Gate') {
        timeout(time: 5, unit: 'MINUTES') {
            def qualityGate = waitForQualityGate()

            if (qualityGate.status != 'OK') {
                error "Quality Gate failed: ${qualityGate.status}"
            }
        }
    }

    stage('Package') {
        sh 'mvn package'
    }

    stage('Archive Artifact') {
        archiveArtifacts artifacts: 'target/*.war'
    }

    stage('Docker Build') {
        sh """
            docker build \
            -t maven-web-app:${params.IMAGE_TAG} .
        """
    }

    stage('ECR Login') {
        sh '''
            aws ecr get-login-password --region us-east-1 |
            docker login \
            --username AWS \
            --password-stdin \
            463564115415.dkr.ecr.us-east-1.amazonaws.com
        '''
    }

    stage('Push to ECR') {
        sh """
            docker tag \
            maven-web-app:${params.IMAGE_TAG} \
            463564115415.dkr.ecr.us-east-1.amazonaws.com/maven-web-app:${params.IMAGE_TAG}

            docker push \
            463564115415.dkr.ecr.us-east-1.amazonaws.com/maven-web-app:${params.IMAGE_TAG}
        """
    }

    stage('Environment') {
        echo "Selected environment: ${params.ENVIRONMENT}"
    }

    stage('Deploy to EKS') {
        if (params.deploy) {

            sh """
                kubectl set image deployment/maven-web-app \
                maven-web-app=463564115415.dkr.ecr.us-east-1.amazonaws.com/maven-web-app:${params.IMAGE_TAG}

                kubectl rollout status deployment/maven-web-app --timeout=120s
            """

        } else {

            echo "deploy is disabled"
            echo "Skipping EKS deployment"

        }
    }
}
