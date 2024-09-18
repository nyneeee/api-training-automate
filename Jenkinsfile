pipeline {
    agent none
    parameters {
        choice(
            name: 'GH_RUNNER_TAG',
            choices: ['cpc-ate-dev', 'cpc-ate-prd'],
            description: 'Runner to run tests.'
        )
        string(
            name: 'REGION',
            description: 'Region to run tests (comma-separated for multiple regions, e.g., "asse,asea")',
            defaultValue: 'asse,asea'
        )
        choice(
            name: 'SITE_TEST',
            choices: ['prd', 'sit'],
            description: 'Site to run tests.'
        )
        choice(
            name: 'BRANCH_REF',
            choices: ['main', 'sit'],
            description: 'Branch to run tests.'
        )
    }
    stages {
        stage('Prepare') {
            steps {
                script {
                    def regions = params.REGION.split(',').collect { it.trim() }
                    env.REGION_LIST = regions.join(' ')
                }
            }
        }
        stage('Test') {
            matrix {
                agent {
                    label "${NODENAME}"
                }
                axes {
                    axis {
                        name 'NODENAME'
                        values env.REGION_LIST.split(' ')
                    }
                }
                stages {
                    stage('Test') {
                        steps {
                            echo "Do Test for ${NODENAME}"
                            echo "GH_RUNNER_TAG: ${params.GH_RUNNER_TAG}"
                            echo "SITE_TEST: ${params.SITE_TEST}"
                            echo "BRANCH_REF: ${params.BRANCH_REF}"
                        }
                    }
                }
            }
        }
    }
}