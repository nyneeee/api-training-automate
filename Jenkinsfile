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
                    def regions = params.REGION.split(',').collect { it.trim() }
                    // เช็คว่าต้องเป็น asse หรือ asea โดยที่เช็คว่าค่าที่ส่งเข้ามา จะต้องไม่ contains กับ "validRegions" = ['asse', 'asea'] 
                    //    1. กรณีที่ "ไม่ contains กัน" จะถูกมองเป็น "True" ตามเงื่อนไข !validRegions.contains(it) และจะ return ค่าเข้า "invalidRegions" จะมีค่า "REGION ที่ไม่กับ ['asse', 'asea']"
                    //    2. กรณีที่ "contains กัน" จะถูกมองเป็น "False" และไม่เข้าเงื่อนไข !validRegions.contains(it) และ "invalidRegions" จะเท่ากับ "0" หรือ "ไม่มีค่า" เพราะมีค่าที่ "contains" กันจึงไม่ถูกเก็บไว้ใน invalidRegions
                    def validRegions = ['asse', 'asea']                    
                    def invalidRegions = regions.findAll { !validRegions.contains(it) }
                    if (invalidRegions) {
                        error "Invalid regions detected: ${invalidRegions.join(', ')}. Valid regions are: ${validRegions.join(', ')}."
                    } else {
                        echo "Regions are valid: ${regions.join(', ')}."
                    }
                    def tasks = [:]
                    for (region in regions) {
                        tasks["Test in ${region}"] = {
                            echo "Running tests with parameters:"
                            echo "GH_RUNNER_TAG: ${params.GH_RUNNER_TAG}"
                            echo "REGION: ${region}"
                            echo "SITE_TEST: ${params.SITE_TEST}"
                            echo "BRANCH_REF: ${params.BRANCH_REF}"
                        }
                    }
                    // สั่งให้ทำงานแบบ parallel
                    parallel tasks
                }
            }
        }
    }
}
