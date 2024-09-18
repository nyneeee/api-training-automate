pipeline {
    agent any
    stages {
        stage('Trigger Pipeline with Parameters') {
            steps {
                build job: 'Test Training',
                      parameters: [
                          string(name: 'param1', value: 'value1'),
                          booleanParam(name: 'flag', value: true)
                      ]
            }
        }
    }
}
