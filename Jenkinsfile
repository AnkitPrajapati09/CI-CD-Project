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
		NEXUS_REPO = 'vpro-maven-group'
        registryCredential = 'ecr:us-east-1:awscreds'
        appRegistry = '776648109966.dkr.ecr.us-east-1.amazonaws.com/vprofile-app-img-repo'
        
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
                    dockerImage = docker.build( appRegistry + ":$BUILD_NUMBER", "./Docker-files/app/multistage/")
    
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