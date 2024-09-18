pipeline {
    agent any
    stages {
        stage("Choose combinations") {
            steps {
                script {
                    // กำหนดค่าของ matrix_axes
                    Map matrix_axes = [
                        PLATFORM: ['linux', 'windows', 'mac'],
                        BROWSER: ['firefox', 'chrome', 'safari', 'edge']
                    ]

                    // ฟังก์ชันในการคำนวณ matrix axes
                    List getMatrixAxes(Map matrix_axes) {
                        List axes = []
                        matrix_axes.each { axis, values ->
                            List axisList = []
                            values.each { value ->
                                axisList << [(axis): value]
                            }
                            axes << axisList
                        }
                        // คำนวณ Cartesian Product
                        axes.combinations()*.sum()
                    }

                    // ให้ผู้ใช้เลือกค่าต่างๆ
                    Map response = input(
                        id: 'Platform',
                        message: 'Customize your matrix build.',
                        parameters: [
                            choice(
                                choices: ['all', 'linux', 'mac', 'windows'],
                                description: 'Choose a single platform or all platforms to run tests.',
                                name: 'PLATFORM'),
                            choice(
                                choices: ['all', 'chrome', 'edge', 'firefox', 'safari'],
                                description: 'Choose a single browser or all browsers to run tests.',
                                name: 'BROWSER')
                        ]
                    )

                    // กรอง matrix axes ตามการเลือกของผู้ใช้
                    List axes = getMatrixAxes(matrix_axes).findAll { axis ->
                        (response['PLATFORM'] == 'all' || response['PLATFORM'] == axis['PLATFORM']) &&
                        (response['BROWSER'] == 'all' || response['BROWSER'] == axis['BROWSER']) &&
                        !(axis['BROWSER'] == 'safari' && axis['PLATFORM'] == 'linux') &&
                        !(axis['BROWSER'] == 'edge' && axis['PLATFORM'] != 'windows')
                    }

                    // จัดเก็บค่าที่กรองแล้วไว้ใน environment variables เพื่อใช้ในขั้นตอนถัดไป
                    env.AXES = axes.toString()
                }
            }
        }
        stage('Trigger Pipeline with Parameters') {
            steps {
                script {
                    // สร้าง map สำหรับพารามิเตอร์ที่จะส่งไปยัง job อื่น
                    Map tasks = [:]

                    // สำหรับแต่ละค่าของ axes ที่กรองแล้ว
                    for (Map axis : axes) {
                        // สร้างพารามิเตอร์สำหรับ job อื่น
                        String platform = axis['PLATFORM']
                        String browser = axis['BROWSER']
                        
                        tasks["${platform}-${browser}"] = {
                            build job: 'Pre-Test Automate',
                                  parameters: [
                                      string(name: 'PLATFORM', value: platform),
                                      string(name: 'BROWSER', value: browser)
                                  ]
                        }
                    }

                    // เรียกใช้ job อื่นใน parallel
                    parallel(tasks)
                }
            }
        }
    }
}