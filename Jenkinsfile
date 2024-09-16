pipeline {
    agent any
    environment {
        REGION = "asse"
        SITE_TEST = "main"
        PATH = "/opt/homebrew/bin:${env.PATH}"
    }
    // triggers {
    //     githubPush()  // สำหรับ GitHub
    // }
    stages {
        stage('Test Checkout GitHub') {
            steps {
                script {
                    checkout scmGit(branches: [[name: "*/${env.SITE_TEST}"]], extensions: [], userRemoteConfigs: [[url: 'https://github.com/nyneeee/api-training-automate.git']])
                }
                sh 'ls -lrt'
            }
        }
        // stage('Test Grep CMD Run Robot') {
        //     steps {
        //         script {
        //             def CMD_RUN_PRE_TEST = sh(
        //                 script: """
        //                     grep 'cmd_run_robot_automate_pre_test_${REGION}_${SITE_TEST}' ./Config/cicd_workflow_config.yml | cut -d ':' -f 2-
        //                 """,
        //                 returnStdout: true
        //             ).trim()  
        //             echo "CMD_RUN_PRE_TEST: ${CMD_RUN_PRE_TEST}"
        //             env.CMD_RUN_PRE_TEST = CMD_RUN_PRE_TEST
        //         }
        //     }
        // }
        stage('Run Robot Test') {
            steps {
                sh(script: """
                    cd Testsuites
                    robot -d log test_api_basic.robot
                    
                """)
            // ${env.CMD_RUN_PRE_TEST}
            }
        }
    }
}
