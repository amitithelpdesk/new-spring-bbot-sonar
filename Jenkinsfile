    pipeline {
    agent any

    tools {
        maven "Maven"
    }
    environment {
        NEXUS_VERSION = "nexus3"
        NEXUS_PROTOCOL = "http"
        NEXUS_URL = "34.132.232.73:8081"
        NEXUS_REPOSITORY = "maven-hosted-repo"
        NEXUS_CREDENTIAL_ID = "nexus-upload"
    }
    stages {
        stage('Clone the code') {
            steps {
                git branch: 'Rnow',
                   //credentialsId: 'amitgithub',
                   url: 'https://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@github.com/amitithelpdesk/new-spring-bbot-sonar.git'
            }
        }
        stage('build the code') {
            steps {
                sh 'mvn clean install'
            }
        }
		stage("Publish to Nexus Repository Manager") {
            steps {
                script {
                    pom = readMavenPom file: "pom.xml";
                    filesByGlob = findFiles(glob: "target/*.${pom.packaging}");
                    echo "${filesByGlob[0].name} ${filesByGlob[0].path} ${filesByGlob[0].directory} ${filesByGlob[0].length} ${filesByGlob[0].lastModified}"
                    artifactPath = filesByGlob[0].path;
                    artifactExists = fileExists artifactPath;
                    if(artifactExists) {
                        echo "*** File: ${artifactPath}, group: ${pom.groupId}, packaging: ${pom.packaging}, version ${pom.version}";
                        nexusArtifactUploader(
                            nexusVersion: NEXUS_VERSION,
                            protocol: NEXUS_PROTOCOL,
                            nexusUrl: NEXUS_URL,
                            groupId: pom.groupId,
                            version: pom.version,
                            repository: NEXUS_REPOSITORY,
                            credentialsId: NEXUS_CREDENTIAL_ID,
                            artifacts: [
                                [artifactId: pom.artifactId,
                                classifier: '',
                                file: artifactPath,
                                type: pom.packaging],
                                [artifactId: pom.artifactId,
                                classifier: '',
                                file: "pom.xml",
                                type: "pom"]
                            ]
                        );
                    } else {
                        error "*** File: ${artifactPath}, could not be found";
                    }
                }
            }
        }
        stage('Code quailty check') {
            steps {
                sh 'mvn sonar:sonar -Dsonar.host.url=http://34.132.232.73:9000 -Dsonar.login=8128187d3aebfe7019c28168676ed18b78ff413c'
            }
        }
		stage('docker build') {
            steps {
                sh 'docker build -t gcr.io/concise-haven-327611/Rnow:${BUILD_NUMBER} .'
				sh 'gcloud auth activate-service-account devops@concise-haven-327611.iam.gserviceaccount.com --key-file=concise-haven-327611-236df64dbf41.json'
				sh 'cat concise-haven-327611-236df64dbf41.json | docker login -u _json_key --password-stdin https://gcr.io'
				sh 'docker push gcr.io/concise-haven-327611/Rnow:${BUILD_NUMBER} '
				
			
				
		
            }
        }
		stage('kubernetes connect and deploy') {
            steps {
                sh 'gcloud container clusters get-credentials cluster-1 --zone us-central1-c --project concise-haven-327611'
                sh "sed -i 's/00/${BUILD_NUMBER}/g' Rnow-deploy.yml"
				sh 'kubectl apply -f Rnow-deploy.yml'
				sh 'kubectl apply -f Rnow-service.yml'
				
				
		
            }
        }
	
    }
}
