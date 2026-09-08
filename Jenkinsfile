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
        sh "docker build -t maven-web-app:${params.IMAGE_TAG} ."
    }

    stage('Environment') {
        echo "Selected environment: ${params.ENVIRONMENT}"
    }

    stage('Deploy') {
        if (params.DEPLOY) {
            echo "DEPLOY is enabled"
            echo "Deploying to ${params.ENVIRONMENT}"
        } else {
            echo "DEPLOY is disabled"
            echo "Skipping deployment"
        }
    }
}
