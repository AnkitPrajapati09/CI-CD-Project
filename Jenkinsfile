pipeline {
    agent any
    tools {
        maven "MAVEN3.9.9"
        jdk "JDK17"
    }
    
    stages {
        stage('Build'){
            steps {
                sh 'mvn -s settings.xml -DskipTests install'
            }
            post {
                success{
                    echo "Archiving Artifact"
                    archiveArtifacts artifacts: '**/*.war' 
                }
            }
        }
        stage('Unit test'){
            steps {
                sh 'mvn test'
            }
        }
        stage('Checkstyle Analysis') {
            steps {
                sh'mvn checkstyle:checkstyle'
            }
        }
        
        
    }
}