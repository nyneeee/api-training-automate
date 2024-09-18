pipeline {
    agent any
    stages {
        stage('Trigger Pipeline with Parameters') {
            steps {
                build job: 'Pre-Test Automate',
                                  parameters: [
                                      string(name: 'GH_RUNNER_TAG', value: 'cpc-ate-1-dev'),
                                      string(name: 'REGION', value: 'asse'),
                                      string(name: 'SITE_TEST', value: 'main'),
                                      string(name: 'BRANCH_REF', value: 'main')
                                  ]
            }
        }
    }
}
