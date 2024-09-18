node {
    // กำหนดค่าของ matrix_axes
    def matrix_axes = [
        PLATFORM: ['linux', 'windows', 'mac'],
        BROWSER: ['firefox', 'chrome', 'safari', 'edge']
    ]

    // ฟังก์ชันในการคำนวณ matrix axes
    def getMatrixAxes(matrix_axes) {
        def axes = []
        matrix_axes.each { axis, values ->
            def axisList = []
            values.each { value ->
                axisList << [(axis): value]
            }
            axes << axisList
        }
        // คำนวณ Cartesian Product
        return axes.combinations()*.sum()
    }

    // ให้ผู้ใช้เลือกค่าต่างๆ
    def response = input(
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
    def axes = getMatrixAxes(matrix_axes).findAll { axis ->
        (response['PLATFORM'] == 'all' || response['PLATFORM'] == axis['PLATFORM']) &&
        (response['BROWSER'] == 'all' || response['BROWSER'] == axis['BROWSER']) &&
        !(axis['BROWSER'] == 'safari' && axis['PLATFORM'] == 'linux') &&
        !(axis['BROWSER'] == 'edge' && axis['PLATFORM'] != 'windows')
    }

    // สร้าง map สำหรับพารามิเตอร์ที่จะส่งไปยัง job อื่น
    def tasks = [:]

    // สำหรับแต่ละค่าของ axes ที่กรองแล้ว
    for (axis in axes) {
        def platform = axis['PLATFORM']
        def browser = axis['BROWSER']
        
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
