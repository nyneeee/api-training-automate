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
        stage('Trigger Pipeline with Parameters') {
            steps {
                script {
                    def regions = params.REGION.split(',').collect { it.trim() }
                    echo "Regions selected: ${regions}"
                    for(run_region in regions){
                        echo "Regions selected: ${run_region}"
                    }
                }
            }
        }
    }
}