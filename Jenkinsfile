pipeline {
    agent any
    parameters {

        choice(name: 'GH_RUNNER_TAG', choices: ['cpc-ate-1-dev', 'cpc-ate-2-dev'], description: 'test')
        choice(name: 'REGION', choices: ['asse', 'asea'], description: 'test')
        choice(name: 'SITE_TEST', choices: ['prd', 'sit'], description: 'test')
        choice(name: 'BRANCH_REF', choices: ['main', 'sit'], description: 'test')
    }
    stages {
        stage('Trigger Pipeline with Parameters') {
            steps {
                build job: 'Pre-Test Automate',
                                  parameters: [
                                      string(name: 'GH_RUNNER_TAG', value: '${params.GH_RUNNER_TAG}'),
                                      string(name: 'REGION', value: '${params.REGION}'),
                                      string(name: 'SITE_TEST', value: '${params.SITE_TEST}'),
                                      string(name: 'BRANCH_REF', value: '${params.BRANCH_REF}')
                                  ]
            }
        }
    }
}
