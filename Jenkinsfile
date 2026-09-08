node {
    stage('Build') {
        sh 'mvn validate'
        sh 'mvn compile'
    }

    stage('Test') {
        sh 'mvn test'
    }

    stage('Package') {
        sh 'mvn package'
    }

    stage('Archive Artifact') {
        archiveArtifacts artifacts: 'target/*.war'
    }
}
