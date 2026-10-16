def COLOR_MAP = [ 
    'SUCCESS': 'good', 
    'FAILURE': 'danger' 
]
pipeline {
    agent any
    tools {
        maven "MAVEN3.9.9"
        jdk "JDK17" 
    }
    environment {
        
        SONARSCANNER = 'sonarscanner'
        SONARSERVER = 'sonarserver'
        NEXUSIP = '172.31.33.34'
		NEXUSPORT = '8081'
		NEXUS_REPO = 'vprofile-repo'
        registryCredential = 'ecr:us-east-1:awscreds'
        appRegistry = '776648109966.dkr.ecr.us-east-1.amazonaws.com/vprofile-app-img-new'
        vprofileRegistry = "https://776648109966.dkr.ecr.us-east-1.amazonaws.com"
        dbRegistry = '776648109966.dkr.ecr.us-east-1.amazonaws.com/vprofile-db-image-repo'
    }
    stages {
        stage('Build') { 
            steps { 
                sh 'mvn clean install -DskipTests' 
            } 
            
        } 
 
        stage('Unit Test') { 
            steps { 
                sh 'mvn test' 
            } 
            
        } 
 
        stage('Checkstyle Analysis') { 
            steps { 
                sh 'mvn checkstyle:checkstyle' 
            } 
            post { 
                success { 
                    archiveArtifacts artifacts: '**/target/*.war' 
                } 
            } 
        }
        stage('Sonar Code analysis') {
          environment {
           scannerHome = tool "${SONARSCANNER}";
          }

          steps{
            withSonarQubeEnv("${SONARSERVER}") { 
              sh '''${scannerHome}/bin/sonar-scanner \
                  -Dsonar.projectKey=vprofile \
  				  -Dsonar.projectName=vprofile \
                  -Dsonar.projectVersion=1.0 \
                  -Dsonar.sources=src/ \
                  -Dsonar.java.binaries=target/classes \
                  -Dsonar.junit.reportsPath=target/surefire-reports \
                  -Dsonar.coverage.jacoco.xmlReportPaths=target/site/jacoco/jacoco.xml \
                  -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml'''
            }
          }
        }
        stage("Quality Gate") {
            steps {
                timeout(time: 1, unit: 'HOURS') {
                    // Parameter indicates whether to set pipeline to UNSTABLE if Quality Gate fails
                    // true = set pipeline to UNSTABLE, false = don't
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        stage("UploadArtifact"){
            steps{
                nexusArtifactUploader(
                  nexusVersion: 'nexus3',
                  protocol: 'http',
                  nexusUrl: "${NEXUSIP}:${NEXUSPORT}",
                  groupId: 'QA',
                  version: "${env.BUILD_ID}-${env.BUILD_TIMESTAMP}",
                  repository: "${NEXUS_REPO}",
                  credentialsId: 'nexuslogin',
                  artifacts: [
                    [artifactId: 'vproapp',
                     classifier: '',
                     file: 'target/vprofile-v2.war',
                     type: 'war']
                  ]
                )
            }
        }
        stage('Build App Image') {
            steps {
                script {
                    dockerImage = docker.build( appRegistry + ":$BUILD_NUMBER", "-f Docker-files/app/multistage/Dockerfile .")
    
                }
            }
        }
        stage('Build DB Image') {
            steps {
                script {
                    docker_dbImage = docker.build(
                        dbRegistry + ":${BUILD_NUMBER}",
                        "-f Docker-files/db/Dockerfile ."
                    )
                }
            }
        }
        stage('Trivy Scan') {
            steps {
                sh """
                mkdir -p /var/lib/jenkins/trivy-tmp
                export TMPDIR=/var/lib/jenkins/trivy-tmp

                trivy image \
                --cache-dir /var/lib/jenkins/.cache/trivy \
                --severity HIGH,CRITICAL \
                --exit-code 0 \
                -f table \
                -o trivy-report.json \
                ${appRegistry}:${BUILD_NUMBER}
                 """
            }
            post {
                always {
                    archiveArtifacts artifacts: 'trivy-report.json', allowEmptyArchive: true
                }
            }
        }
        stage('Upload App Image to ECR') {
          steps{
            script {
              docker.withRegistry( vprofileRegistry, registryCredential ) {
                dockerImage.push("$BUILD_NUMBER")
                dockerImage.push('latest')
              }
            }
          }
        }
        stage('Upload DB Image to ECR') {
            steps {
                script {
                    docker.withRegistry(vprofileRegistry, registryCredential) {
                        docker_dbImage.push("${BUILD_NUMBER}")
                        docker_dbImage.push('latest')
                    }
                }
            }
        }
        stage('Deploy To EKS') {
            steps {
                withAWS(credentials: 'awscreds', region: 'us-east-1') {
                    sh """
                    aws eks update-kubeconfig \
                    --region us-east-1 \
                    --name vprofile-eks

                    kubectl apply -f k8s/s

                    # Update App Image
                    kubectl set image deployment/vprofile \
                    vprofile=${appRegistry}:${BUILD_NUMBER}

                    # Update DB Image
                    kubectl set image deployment/vprodb \
                    vprodb=${dbRegistry}:${BUILD_NUMBER}

                    # Wait for rollouts
                    kubectl rollout status deployment/vprofile
                    kubectl rollout status deployment/vprodb
                    """
                }
            }
        }

    }
    post { 
        always { 
            slackSend( 
                channel: '#devopscicd', 
                color: COLOR_MAP[currentBuild.currentResult], 
                message: "*${currentBuild.currentResult}:* Job ${env.JOB_NAME} build ${env.BUILD_NUMBER}\n${env.BUILD_URL}" 
            ) 
        } 
    } 
}