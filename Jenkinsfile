pipeline {
  agent {
    docker {
      image '4alldigital/ci'
    }
  }
  environment {
    DISABLE_AUTH = 'true'
    NPM_TOKEN = credentials('PRIVATE_NPM_TOKEN')
    NPM_REGISTRY_URL = 'https://registry.npmjs.org/'
    GH_TOKEN = credentials('GH_TOKEN')
    ECR_CONTAINER_NAME="ci-jenkins"
    ECR_REPO_URI="859167267990.dkr.ecr.eu-west-1.amazonaws.com"
    AWS_DEFAULT_REGION="eu-west-1"
    ECS_DEPLOY_TIMEOUT="600"
    ECS_CLUSTER_NAME="ci-cluster"
    ECS_SERVICE_NAME="jenkins"
  }
  options {
    timeout(time: 1, unit: 'HOURS')
  }
  stages {
    stage ('NOTIFY SLACK') {
      steps {
        slackSend (color: '#e7ec63', channel: "#jenkins", message: "STARTED: Job '$JOB_NAME [$BUILD_ID]' ($RUN_DISPLAY_URL)")
      }
    }
    stage('BUILD') {
      steps {
        sh '''
          docker build -t ${ECR_CONTAINER_NAME}:latest .
          docker tag ${ECR_CONTAINER_NAME}:latest ${ECR_REPO_URI}/${ECR_CONTAINER_NAME}:latest
          $(aws ecr get-login --region ${AWS_DEFAULT_REGION} --no-include-email)
          docker push ${ECR_REPO_URI}/${ECR_CONTAINER_NAME}:latest
        '''
      }
    }
    stage('DEPLOY') {
      steps {
        sh '''
          ecs -t ${ECS_DEPLOY_TIMEOUT} -c ${ECS_CLUSTER_NAME} -n ${ECS_SERVICE_NAME} -i ${ECR_REPO_URI}/${ECR_CONTAINER_NAME}:latest
        '''
      }
    }
  }
  post {
    success {
      slackSend (color: '#32d13c', channel: "#jenkins", message: "COMPLETED: Job '$JOB_NAME [$BUILD_ID]' ($RUN_DISPLAY_URL)")
    }
    failure {
      slackSend (color: '#FF0000', channel: "#jenkins", message: "FAILED: Job '$JOB_NAME [$BUILD_ID]' ($RUN_DISPLAY_URL)")
    }
    always {
      echo 'One way or another, I have finished'
      archiveArtifacts artifacts: 'tests/**', allowEmptyArchive: true, fingerprint: true
      deleteDir() /* clean up our workspace */
    }
  }
}
