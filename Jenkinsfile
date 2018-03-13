#!groovy

version    = "0.0.${env.BUILD_NUMBER}"
repo       = "dlish27"
helloworld = "$repo/helloworld"

node {
    stage('checkout') {
        checkout scm
        sh 'git submodule update --init'
    }

    stage('docker build/test Helloworld Site') {
        sh "docker build -t $helloworld:$version . --no-cache"
    }

    withCredentials([
            usernamePassword(credentialsId: 'docker-hub-id', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')
    ]) {
        stage('docker publish') {
            sh "docker login -u $USERNAME -p $PASSWORD"
            sh "docker push $helloworld:$version"
        }
    }

    if (isMaster()) {
        // Jenkins commit version to infrastructure repo
        git branch: 'qa', credentialsId: 'bb7477ad-50e9-4a82-8f97-c49d2fa012e5', poll: false, url: 'https://github.com/dlish/helloworld-infrastructure.git'

        setVersion()
        sh "git add docker-compose.yml"
        sh "git commit -m 'jenkins-bot: Update the Helloworld Site -> $version'"

        withCredentials([
            usernamePassword(credentialsId: 'bb7477ad-50e9-4a82-8f97-c49d2fa012e5', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
            sh "git push https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/dlish/helloworld-infrastructure.git qa"
        }

    }
}

def setVersion() {
    sh "sed -i.bak 's,$helloworld:.*,$helloworld:$version,' docker-compose.yml"
}

def isMaster() {
    return env.BRANCH_NAME == "master"
}

def isPR() {
    return env.BRANCH_NAME =~ /(?i)^pr-/
}