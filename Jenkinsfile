pipeline {
    agent any
    stages {
        stage('Trigger Pipeline with Parameters') {
            steps {
                build job: 'Pre-Test Automate',
                      parameters: [
                          string(name: 'param1', value: 'value1'),
                          booleanParam(name: 'flag', value: true)
                      ]
            }
        }
    }
}
