pipeline {

  agent {
    kubernetes {
      yamlFile 'pipelineAgent.yaml'
    }
  }

  stages {

    stage('Build & Push Images Using Google Kaniko') {
      steps {
        // container block to run script/shell commands in specified container of 
        // the Kubernetes agent <pipelineAgent.yaml> described above.
        container('kaniko') {
          script {
            sh '''
            /kaniko/executor --dockerfile `pwd`/Dockerfile \
                             --context `pwd` \ 
                             --destination=justmeandopensource/myweb:${BUILD_NUMBER}
            '''
            // --context for build context.
            // --dockerfile name of 'Dockerfile'.
            // --destination for pushing images to desired container registry.
          }
        }
      }
    }

    stage('Deploy App to Kubernetes') {     
      steps {
        container('kubectl') {
          withCredentials([file(credentialsId: 'mykubeconfig', variable: 'KUBECONFIG')]) {
            sh 'sed -i "s/<TAG>/${BUILD_NUMBER}/" myweb.yaml'
            sh 'kubectl apply -f myweb.yaml'
          }
        }
      }
    }
  
  }
}