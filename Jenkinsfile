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
        stage('Parallel Execution from List') {
            parallel {
                script {
                    // List of stages to run in parallel
                    def stagesList = params.REGION.split(',').collect { it.trim() }
                    
                    // Define a map to hold parallel stages
                    def parallelStages = [:]
                    
                    // Iterate over the list and create parallel stages
                    stagesList.each { region ->
                        parallelStages["Stage for ${region}"] = {
                            stage("Stage for ${region}") {
                                steps {
                                    echo "Running tests for region: ${region}"
                                    // คำสั่งที่ใช้รัน Job ตามชื่อ stage
                                }
                            }
                        }
                    }
                    
                    // Execute the parallel stages
                    parallel parallelStages
                }
            }
        }
    }
}
