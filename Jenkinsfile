pipeline {
    agent any
    stages {
        stage('Trigger Pipeline with Parameters') {
            steps {
                script {
                    // รับค่าจาก input
                    def response = input(
                        id: 'Platform', 
                        message: 'Customize your matrix build.', 
                        parameters: [
                            choice(
                                choices: ['cpc-ate-dev', 'cpc-ate-prd'], 
                                description: 'Runner to run tests.', 
                                name: 'GH_RUNNER_TAG' 
                            ),
                            choice(
                                description: 'Region to run tests (comma-separated for multiple regions, e.g., asse,asea")', 
                                name: 'REGION' 
                            ),
                            choice(
                                choices: ['prd', 'sit'], 
                                description: 'Site to run tests.',
                                name: 'SITE_TEST' 
                            ),
                            choice(
                                choices: ['main', 'sit'], 
                                description: 'Branch to run tests.',
                                name: 'BRANCH_REF'
                            )
                        ]
                    )

                    // สร้าง task เพื่อรัน pipeline สำหรับ region ที่เลือก
                    def tasks = [:]
                    
                    // ค่าที่ผู้ใช้เลือกจาก input จะอยู่ใน response
                    def region = response.REGION

                    tasks["Test in ${region}"] = {
                        build job: 'Pre-Test Automate',
                            parameters: [
                                string(name: 'GH_RUNNER_TAG', value: response.GH_RUNNER_TAG),
                                string(name: 'REGION', value: response.REGION),
                                string(name: 'SITE_TEST', value: response.SITE_TEST),
                                string(name: 'BRANCH_REF', value: response.BRANCH_REF)
                            ]
                    }

                    // รัน task แบบ parallel
                    parallel tasks
                }
            }
        }
    }
}
