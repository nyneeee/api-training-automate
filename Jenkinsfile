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
                    // Split the REGION parameter into a list of regions and trim whitespace
                    def regions = params.REGION.split(',').collect { it.trim() }
                    def validRegions = ['asse', 'asea']
                    def invalidRegions = regions.findAll { !validRegions.contains(it) }
                    
                    if (invalidRegions) {
                        error "Invalid regions detected: ${invalidRegions.join(', ')}. Valid regions are: ${validRegions.join(', ')}."
                    } else {
                        echo "Regions are valid: ${regions.join(', ')}."
                    }

                    // Define a map of parallel tasks
                    def tasks = [:]
                    
                    // Iterate over regions and create a parallel task for each
                    regions.each { region ->
                        tasks["Test ${region}"] = {
                            echo "Running tests for region: ${region}"
                        }
                    }
                    
                    // Execute the tasks in parallel
                    parallel tasks
                }
            }
        }
    }
}
