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
        stage('Trigger Tests') {
            steps {
                script {
                    List getMatrixAxes(params.REGION) {
                        List axes = []
                        matrix_axes.each { axis, values ->
                            List axisList = []
                            values.each { value ->
                                axisList << [(axis): value]
                            }
                            axes << axisList
                        }
                        axes.combinations()*.sum()
                    }
                }
            }
        }
    }
}