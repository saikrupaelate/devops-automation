pipeline {
  agent any

  environment {
    KEY = "/var/lib/jenkins/.ssh/krupa_keypair.pem"
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
          sh 'terraform apply -auto-approve'
        }
      }
    }

    stage('Generate Inventory') {
      steps {
        // ✅ FIXED: terraform output returns a plain list, use jq -r '.[]'
        sh '''
          cd terraform

          echo "[apache]" > ../ansible/inventory.ini
          terraform output -json apache_ips | jq -r '.[]' >> ../ansible/inventory.ini

          echo "" >> ../ansible/inventory.ini

          echo "[nginx]" >> ../ansible/inventory.ini
          terraform output -json nginx_ips | jq -r '.[]' >> ../ansible/inventory.ini

          echo "" >> ../ansible/inventory.ini
          echo "[all:vars]" >> ../ansible/inventory.ini
          echo "ansible_user=ubuntu" >> ../ansible/inventory.ini

          cat ../ansible/inventory.ini
        '''
      }
    }

    stage('Wait for EC2 SSH') {
      steps {
        // ✅ NEW: Wait for instances to be SSH-ready before Ansible runs
        sh '''
          sleep 30
        '''
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