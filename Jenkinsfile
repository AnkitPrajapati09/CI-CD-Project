pipeline {
    agent any
    tools {
        maven "MAVEN3.9.9"
        jdk "JDK17"
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
        
    }
}