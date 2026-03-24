pipeline {
  agent any

  environment {
    KEY = "/var/jenkins_home/.ssh/krupa_keypair.pem"  // ✅ Docker path, not /var/lib/jenkins
  }

  stages {

    stage('Checkout') {
      steps {
        git credentialsId: 'github-creds',
          url: 'https://github.com/saikrupaelate/devops-automation.git',
          branch: 'main'
      }
    }

    stage('Terraform Init') {
      steps {
        dir('terraform') {
          sh 'terraform init'
        }
      }
    }

    stage('Terraform Apply') {
      steps {
        dir('terraform') {
          sh 'echo "EC2s already provisioned, skipping apply"'
        }
      }
    }

    stage('Generate Inventory') {
      steps {
        sh '''
          cat > ansible/inventory.ini << EOF
    [apache]
    54.90.83.61
    98.80.120.254

    [nginx]
    54.162.210.206
    54.198.7.81

    [all:vars]
    ansible_user=ubuntu
    EOF
          cat ansible/inventory.ini
        '''
      }
    }

    stage('Wait for EC2 SSH') {
      steps {
        sh 'sleep 30'
      }
    }

    stage('Run Ansible') {
      steps {
        sh '''
          cd ansible
          ansible-playbook -i inventory.ini site.yml \
            --user ubuntu \
            --private-key $KEY \
            -e "ansible_ssh_common_args='-o StrictHostKeyChecking=no'"
        '''
      }
    }

  }

  post {
    success {
      echo '✅ Pipeline completed: Apache + Java and Nginx configured successfully!'
    }
    failure {
      echo '❌ Pipeline failed. Check logs above.'
    }
  }
}