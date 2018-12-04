#!/usr/bin/groovy
pipeline {
  agent {
    kubernetes {
      label 'jenkins-postgris'
      yamlFile 'jenkinsPodTemplate.yml'
    }
  }
  stages {
    stage('Checkout code') {
      steps {
        container('jnlp'){
          script{
            inputFile = readFile('Jenkinsfile.json')
            config = new groovy.json.JsonSlurperClassic().parseText(inputFile)
            containerTag = env.BRANCH_NAME + '-' + env.GIT_COMMIT.substring(0, 7)
            println "pipeline config ==> ${config}"
          } // script
        } // container('jnlp')
      } // steps
    } // stage
    stage('Build Postgris Docker') {
      parallel{
        stage('Build & Push Postgris 9.6'){
          when {
            expression { config.docker.rebuildPostgris96 == 'true' }
          }
          steps{
            container('docker') {
                  sh "docker build \
                          --file ${WORKSPACE}/9.6/Dockerfile \
                          --tag=${config.docker.server}/${config.docker.postgrisRepository}:${config.docker.postgris96Version}-${containerTag} \
                          --tag=${config.docker.server}/${config.docker.postgrisRepository}:${config.docker.postgris96Version}-${env.BRANCH_NAME}_latest \
                          ${WORKSPACE}/9.6"
                  sh "docker login \
                              --username ${config.docker.username} \
                              --password \$(cat /tmp/docker-password/docker_password) \
                              ${config.docker.server}"
                  sh "docker push ${config.docker.server}/${config.docker.postgrisRepository}:${config.docker.postgris96Version}-${env.BRANCH_NAME}_latest"
                  sh "docker push ${config.docker.server}/${config.docker.postgrisRepository}:${config.docker.postgris96Version}-${containerTag}"
            } // container('docker')
          } // steps
        } // stage('Build & Push Potgris 9.6')
        stage('Build & Push Postgris 11'){
          when {
            expression { config.docker.rebuildPostgris11 == 'true' }
          }
          steps{
            container('docker') {
                  sh "docker build \
                          --file ${WORKSPACE}/11/Dockerfile \
                          --tag=${config.docker.server}/${config.docker.postgrisRepository}:${config.docker.postgris11Version}-${containerTag} \
                          --tag=${config.docker.server}/${config.docker.postgrisRepository}:${config.docker.postgris11Version}-${env.BRANCH_NAME}_latest \
                          ${WORKSPACE}/11"
                  sh "docker login \
                              --username ${config.docker.username} \
                              --password \$(cat /tmp/docker-password/docker_password) \
                              ${config.docker.server}"
                  sh "docker push ${config.docker.server}/${config.docker.postgrisRepository}:${config.docker.postgris11Version}-${env.BRANCH_NAME}_latest"
                  sh "docker push ${config.docker.server}/${config.docker.postgrisRepository}:${config.docker.postgris11Version}-${containerTag}"
            } // container('docker')
          } // steps
        } // stage('Build & Push Postgris 11')
      } // parallel
    } // stage('Build Postgris Docker')
  }// stages
}// pipeline