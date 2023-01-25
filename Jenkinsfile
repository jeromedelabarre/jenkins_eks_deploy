pipeline{

    agent any

    environment{
        AWS_DEFAULT_REGION="eu-west-3"
        SKIP="N"
        TERRADESTROY="N"
        FIRST_DEPLOY="N"
        STATE_BUCKET="cley-tfstate-bucket"
        CLUSTER_NAME="cley-eks"
        PRISMA_API_URL=https://api2.eu.prismacloud.io
    }

    stages{
        stage('Checkout') {
          steps {
              git branch: 'master', url: ''https://github.com/chrisley75/jenkins_eks_deploy.git''
              stash includes: '**/*', name: 'source'
          }

        }
        stage('Checkov') {
            steps {
                withCredentials([string(credentialsId: '4de3ad41-d00f-41b1-af4d-2d67b05048f1', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    script {
                        docker.image('bridgecrew/checkov:latest').inside("--entrypoint=''") {
                          unstash 'source'
                          try {
                              sh 'checkov -d . --use-enforcement-rules -o cli -o junitxml --output-file-path console,results.xml --bc-api-key \$\{pc_user}::\$\{pc_password} --repo-id  chrisley75/jenkins_eks_deploy --branch main'
                              junit skipPublishingChecks: true, testResults: 'results.xml'
                          } catch (err) {
                              junit skipPublishingChecks: true, testResults: 'results.xml'
                              throw err
                          }
                        }
                    }
                }
            }
        }
        stage("Create Terraform State Buckets"){
            when{
                environment name:'FIRST_DEPLOY',value:'Y'
                environment name:'TERRADESTROY',value:'N'
                environment name:'SKIP',value:'N'
            }
            steps{
                echo "Check if bucket exists else create bucket phase"
                withAWS(credentials: '39725218-cd8f-42a5-8857-c434967b37f5', region: "${env.AWS_DEFAULT_REGION}") {
                    sh'''
                    aws s3 mb s3://${STATE_BUCKET}'''
                }
            }
        }

        stage("Deploy Cluster"){
            when{
                environment name:'TERRADESTROY',value:'N'
                environment name:'SKIP',value:'N'
            }
            stages{
                stage('Validate infra'){
                            steps{
                                withAWS(credentials: '39725218-cd8f-42a5-8857-c434967b37f5', region: "${env.AWS_DEFAULT_REGION}") {
                                    sh '''
                                    cd eks_cluster
                                    terraform init
                                    terraform validate'''
                                }
                            }
                        }
                        stage('spin up VPC and EKS Cluster'){
                             
                            steps{
                                withAWS(credentials: '39725218-cd8f-42a5-8857-c434967b37f5', region: "${env.AWS_DEFAULT_REGION}") {
                                    sh '''
                                    cd eks_cluster
                                    terraform plan -out outfile
                                    terraform apply outfile'''
                                }
                            }
                        }
            }
        }


        /*stage('Notify on Slack'){
             when{
                environment name:'FIRST_DEPLOY',value:'Y'
                environment name:'TERRADESTROY',value:'N'
                environment name:'SKIP',value:'N'
            }
            steps{
                slackSend botUser: true, channel: '<channel_name>', message: "EKS Cluster successfully deployed. Cluster Name: $CLUSTER_NAME", tokenCredentialId: '<token_name>'
            }
        }*/



        stage("Run Destroy"){

            when{
                environment name:'TERRADESTROY',value:'Y'
            }
            stages{

                stage("Destroy eks cluster and vpc"){
                    steps{
                        withAWS(credentials: '39725218-cd8f-42a5-8857-c434967b37f5', region: "${env.AWS_DEFAULT_REGION}") {
                            sh '''
                            cd eks_cluster
                            terraform init
                            terraform destroy -auto-approve
                            '''
                        }
                    }
                }


                stage("Delete state bucket"){
                    steps{
                        withAWS(credentials: '39725218-cd8f-42a5-8857-c434967b37f5', region: "${env.AWS_DEFAULT_REGION}") {
                            script {
                                sh(returnStdout: true, script: "aws s3 rb s3://'${env.STATE_BUCKET}' --force").trim()                    
                            }
                        }
                    }
                }

                //next steps


            }

        }


        




    }

    post { 
        always { 
            cleanWs()
        }
    }





}