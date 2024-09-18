pipeline {
    agent any
    parameters {
        choice(
            name: 'GH_RUNNER_TAG',
            choices: ['cpc-ate-dev', 'cpc-ate-prd'],
            description: 'Runner to run tests.'
        )
        string(
            name: 'REGION',
            description: 'Region to run tests (comma-separated for multiple regions, e.g., "asse,asea")',
            defaultValue: 'asse,asea'  // ค่าพื้นฐานที่ควรตั้งไว้
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
        stage('Matrix Execution') {
            matrix {
                axes {
                    axis {
                        name 'REGION'
                        values params.REGION.split(',')
                    }
                }
                stages {
                    stage('Run Test') {
                        steps {
                            script {
                                echo "Running tests with parameters:"
                                echo "GH_RUNNER_TAG: ${params.GH_RUNNER_TAG}"
                                echo "REGION: ${env.REGION}"
                                echo "SITE_TEST: ${env.SITE_TEST}"
                                echo "BRANCH_REF: ${env.BRANCH_REF}"
                                // สั่งรัน build หรือขั้นตอนที่ต้องการที่นี่
                            }
                        }
                    }
                }
            }
        }
    }
}
