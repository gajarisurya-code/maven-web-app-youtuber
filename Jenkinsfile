node {
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

    stage('Archive Artifact') {
        archiveArtifacts artifacts: 'target/*.war'
    }
}
