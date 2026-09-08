node {
    stage('Build') {
        sh 'mvn validate'
        sh 'mvn compile'
    }

    stage('Test') {
        sh 'mvn test'
    }

    stage('SonarQube Analysis') {
        withSonarQubeEnv('SonarQube') {
            withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_TOKEN')]) {
                sh '''
                    mvn sonar:sonar \
                    -Dsonar.projectKey=maven-web-app \
                    -Dsonar.host.url=$SONAR_HOST_URL \
                    -Dsonar.token=$SONAR_TOKEN
                '''
            }
        }
    }

    stage('Package') {
        sh 'mvn package'
    }

    stage('Archive Artifact') {
        archiveArtifacts artifacts: 'target/*.war'
    }
}
