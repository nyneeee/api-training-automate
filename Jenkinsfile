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
                    def validRegions = ['asse', 'asea']
                    def invalidRegions = regions.findAll { !validRegions.contains(it) }
                    
                    if (invalidRegions) {
                        error "Invalid regions detected: ${invalidRegions.join(', ')}. Valid regions are: ${validRegions.join(', ')}."
                    } else {
                        echo "Regions are valid: ${regions.join(', ')}."
                    }
                    
                    // Save regions to environment variable
                    env.REGIONS = params.REGION
                }
                // Echo regions from environment variable
                echo "Regions from environment variable: ${env.REGIONS}"
            }
        }
        
        stage('Parallel Execution') {
            parallel {
                stage('test'){
                    echo "Regions from environment variable: ${env.REGIONS}"
                }
            }
        }
    }
}
