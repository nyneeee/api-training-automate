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
        stage('Validate Regions') {
            steps {
                script {
                    def regions = params.REGION.split(',').collect { it.trim() }
                    if (regions.size() == 0) {
                        error "No regions specified."
                    }
                    
                    // Parallel execution for each region
                    def branches = [:]
                    for (region in regions) {
                        branches["Build on ${region}"] = {
                            stage("Build on ${region}") {
                                steps {
                                    script {
                                        echo "Building on ${region}"
                                    }
                                }
                            }
                        }
                    }
                    parallel branches
                }
            }
        }
    }
}
