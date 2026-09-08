@Library('shared-library') _

node {
    stage('Checkout') {
        checkout scm
    }

    stage('Build') {
        myBuild()
    }
}
