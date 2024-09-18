// Define the matrix axes
Map matrix_axes = [
    PLATFORM: ['linux', 'windows', 'mac'],
    BROWSER: ['firefox', 'chrome', 'safari', 'edge']
]

@NonCPS
List getMatrixAxes(Map matrix_axes) {
    List axes = []
    matrix_axes.each { axis, values ->
        List axisList = []
        values.each { value ->
            axisList << [(axis): value]
        }
        axes << axisList
    }
    // Calculate the cartesian product
    axes.combinations()*.sum()
}

// Filter out invalid combinations
List axes = getMatrixAxes(matrix_axes).findAll { axis ->
    !(axis['BROWSER'] == 'safari' && axis['PLATFORM'] == 'linux') &&
    !(axis['BROWSER'] == 'edge' && axis['PLATFORM'] != 'windows')
}

pipeline {
    agent none
    stages {
        stage('Matrix builds') {
            parallel {
                axes.each { axis ->
                    def axisEnv = axis.collect { k, v -> "${k}=${v}" }
                    def nodeLabel = "os:${axis['PLATFORM']} && browser:${axis['BROWSER']}"
                    stage("Build and Test for ${nodeLabel}") {
                        agent {
                            label nodeLabel
                        }
                        steps {
                            script {
                                withEnv(axisEnv) {
                                    echo "Running on ${nodeLabel}"
                                    // Build step
                                    sh 'echo Do Build for ${PLATFORM} - ${BROWSER}'
                                    // Test step
                                    sh 'echo Do Test for ${PLATFORM} - ${BROWSER}'
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
