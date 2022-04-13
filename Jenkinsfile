pipeline {

  agent {
    kubernetes {
      yamlFile 'pipelineAgent.yaml'   
    //  It means this pipeline will run in a pod defined in pipelineAgent.yaml file. The pod
    //  has 2 containers running inside it.
    //  1. Kaniko container (for building/pushing docker images)
    //  2. Kubectl container (to run kubectl commands inside our cluster using .kubeconfig credentials)
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
                             --destination=tashikmoin/blue-nginx:${BUILD_NUMBER}
            '''
            // --context for build context.

            // --dockerfile name of 'Dockerfile'.

            // --destination for pushing images to desired ("any") container registry like 
            // dockerhub, Azure Container Registry, etc.
          }
        }
      }
    }

    stage('Deploy App to Kubernetes') {     
      steps {
        container('kubectl') {
          withCredentials([file(credentialsId: 'k8credid', variable: 'KUBECONFIG')]) {
            sh 'sed -i "s/<TAG>/${BUILD_NUMBER}/" myweb.yaml'
            sh 'kubectl apply -f myweb.yaml'
          }
        }
      }
    }
  
  }
}