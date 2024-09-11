*** Variables ***
# Clear Cache
${body_clear_cache}                                          ${CURDIR}/../Body/${Testsite}/body_clear_cache.json

# 1 
${1_body_authentication}                                     ${CURDIR}/../Body/${Testsite}/1_body_security_authentication.json

${1_2_body_authentication}                                   ${CURDIR}/../Body/${Testsite}/TestCaseCondition/1_2_body_security_authentication.json
${1_response_security_authentication}                        ${CURDIR}/../Response/Schema/1_response_security_authentication.json
${1_2_response_security_authentication}                      ${CURDIR}/../Response/${Testsite}_ExpectResult/1_2_response_security_authentication.json

# 2
${2_response_security_validate_token}                        ${CURDIR}/../Response/Schema/2_response_security_validate_token.json
${2_1_response_security_validate_token}                      ${CURDIR}/../Response/${Testsite}_ExpectResult/2_1_response_security_validate_token.json
${2_2_response_security_validate_token}                      ${CURDIR}/../Response/${Testsite}_ExpectResult/2_2_response_security_validate_token.json

# 3
${3_body_get_promotion_shelves}                              ${CURDIR}/../Body/${Testsite}/3_body_get_promotion_shelves.json 
${3_1_body_get_promotion_shelves}                            ${CURDIR}/../Body/${Testsite}/TestCaseCondition/3_1_body_get_promotion_shelves.json
${3_2_body_get_promotion_shelves}                            ${CURDIR}/../Body/${Testsite}/TestCaseCondition/3_2_body_get_promotion_shelves.json
${3_3_1_body_get_promotion_shelves}                          ${CURDIR}/../Body/${Testsite}/TestCaseCondition/3_3_1_body_get_promotion_shelves.json
${3_3_2_body_get_promotion_shelves}                          ${CURDIR}/../Body/${Testsite}/TestCaseCondition/3_3_2_body_get_promotion_shelves.json

${3_response_get_promotion_shelves}                          ${CURDIR}/../Response/Schema/3_response_get_promotion_shelves.json
${3_1_response_get_promotion_shelves}                        ${CURDIR}/../Response/${Testsite}_ExpectResult/3_1_response_get_promotion_shelves.json
${3_2_response_get_promotion_shelves}                        ${CURDIR}/../Response/${Testsite}_ExpectResult/3_2_response_get_promotion_shelves.json
${3_3_1_response_get_promotion_shelves}                      ${CURDIR}/../Response/${Testsite}_ExpectResult/3_3_1_response_get_promotion_shelves.json
${3_3_2_response_get_promotion_shelves}                      ${CURDIR}/../Response/${Testsite}_ExpectResult/3_3_2_response_get_promotion_shelves.json

# 4 
${4_body_get_all_catalog_configurations_by_cosde}            ${CURDIR}/../Body/${Testsite}/4_body_get_all_catalog_configurations_by_code.json
${4_1_body_get_all_catalog_configurations_by_code}           ${CURDIR}/../Body/${Testsite}/TestCaseCondition/4_1_body_get_all_catalog_configurations_by_code.json
${4_2_body_get_all_catalog_configurations_by_code}           ${CURDIR}/../Body/${Testsite}/TestCaseCondition/4_2_body_get_all_catalog_configurations_by_code.json
${4_3_1_body_get_all_catalog_configurations_by_code}         ${CURDIR}/../Body/${Testsite}/TestCaseCondition/4_3_1_body_get_all_catalog_configurations_by_code.json
${4_3_2_body_get_all_catalog_configurations_by_code}         ${CURDIR}/../Body/${Testsite}/TestCaseCondition/4_3_2_body_get_all_catalog_configurations_by_code.json

${4_response_get_all_catalog_configurations_by_code}         ${CURDIR}/../Response/Schema/4_response_get_all_catalog_configurations_by_code.json
${4_1_response_get_all_catalog_configurations_by_code}       ${CURDIR}/../Response/${Testsite}_ExpectResult/4_1_response_get_all_catalog_configurations_by_code.json
${4_2_response_get_all_catalog_configurations_by_code}       ${CURDIR}/../Response/${Testsite}_ExpectResult/4_2_response_get_all_catalog_configurations_by_code.json
${4_3_1_response_get_all_catalog_configurations_by_code}     ${CURDIR}/../Response/${Testsite}_ExpectResult/4_3_1_response_get_all_catalog_configurations_by_code.json
${4_3_2_response_get_all_catalog_configurations_by_code}     ${CURDIR}/../Response/${Testsite}_ExpectResult/4_3_2_response_get_all_catalog_configurations_by_code.json

# 5
${5_body_get_all_packages_by_criterias}                      ${CURDIR}/../Body/${Testsite}/5_body_get_all_pasckages_by_criterias.json
${5_1_1_body_get_all_pasckages_by_criterias}                 ${CURDIR}/../Body/${Testsite}/TestCaseCondition/5_1_1_body_get_all_pasckages_by_criterias.json
${5_1_2_body_get_all_pasckages_by_criterias}                 ${CURDIR}/../Body/${Testsite}/TestCaseCondition/5_1_2_body_get_all_pasckages_by_criterias.json
${5_2_1_body_get_all_pasckages_by_criterias}                 ${CURDIR}/../Body/${Testsite}/TestCaseCondition/5_2_1_body_get_all_pasckages_by_criterias.json
${5_2_2_body_get_all_pasckages_by_criterias}                 ${CURDIR}/../Body/${Testsite}/TestCaseCondition/5_2_2_body_get_all_pasckages_by_criterias.json
${5_3_1_body_get_all_pasckages_by_criterias}                 ${CURDIR}/../Body/${Testsite}/TestCaseCondition/5_3_1_body_get_all_pasckages_by_criterias.json
${5_3_2_body_get_all_pasckages_by_criterias}                 ${CURDIR}/../Body/${Testsite}/TestCaseCondition/5_3_2_body_get_all_pasckages_by_criterias.json
${5_3_3_body_get_all_pasckages_by_criterias}                 ${CURDIR}/../Body/${Testsite}/TestCaseCondition/5_3_3_body_get_all_pasckages_by_criterias.json
${5_4_1_body_get_all_pasckages_by_criterias}                 ${CURDIR}/../Body/${Testsite}/TestCaseCondition/5_4_1_body_get_all_pasckages_by_criterias.json
${5_4_2_body_get_all_pasckages_by_criterias}                 ${CURDIR}/../Body/${Testsite}/TestCaseCondition/5_4_2_body_get_all_pasckages_by_criterias.json

${5_response_get_all_packages_by_criterias}                  ${CURDIR}/../Response/Schema/5_response_get_all_pasckages_by_criterias.json
${5_2_2_response_get_all_pasckages_by_criterias}             ${CURDIR}/../Response/${Testsite}_ExpectResult/5_2_2_response_get_all_pasckages_by_criterias.json

# 6 
${6_body_get_all_promotions_by_shelf}                        ${CURDIR}/../Body/${Testsite}/6_body_get_all_promotions_by_shelf.json
${6_1_body_get_all_promotions_by_shelf}                      ${CURDIR}/../Body/${Testsite}/TestCaseCondition/6_1_body_get_all_promotions_by_shelf.json
${6_2_body_get_all_promotions_by_shelf}                      ${CURDIR}/../Body/${Testsite}/TestCaseCondition/6_2_body_get_all_promotions_by_shelf.json
${6_3_1_body_get_all_promotions_by_shelf}                    ${CURDIR}/../Body/${Testsite}/TestCaseCondition/6_3_1_body_get_all_promotions_by_shelf.json
${6_3_2_body_get_all_promotions_by_shelf}                    ${CURDIR}/../Body/${Testsite}/TestCaseCondition/6_3_2_body_get_all_promotions_by_shelf.json
${6_3_3_body_get_all_promotions_by_shelf}                    ${CURDIR}/../Body/${Testsite}/TestCaseCondition/6_3_3_body_get_all_promotions_by_shelf.json
${6_3_4_body_get_all_promotions_by_shelf}                    ${CURDIR}/../Body/${Testsite}/TestCaseCondition/6_3_4_body_get_all_promotions_by_shelf.json
${6_3_5_body_get_all_promotions_by_shelf}                    ${CURDIR}/../Body/${Testsite}/TestCaseCondition/6_3_5_body_get_all_promotions_by_shelf.json
${6_3_6_body_get_all_promotions_by_shelf}                    ${CURDIR}/../Body/${Testsite}/TestCaseCondition/6_3_6_body_get_all_promotions_by_shelf.json
${6_3_7_body_get_all_promotions_by_shelf}                    ${CURDIR}/../Body/${Testsite}/TestCaseCondition/6_3_7_body_get_all_promotions_by_shelf.json
${6_3_8_body_get_all_promotions_by_shelf}                    ${CURDIR}/../Body/${Testsite}/TestCaseCondition/6_3_8_body_get_all_promotions_by_shelf.json

${6_response_get_all_promotions_by_shelf}                    ${CURDIR}/../Response/Schema/6_response_get_all_promotions_by_shelf.json
${6_1_response_get_all_promotions_by_shelf}                  ${CURDIR}/../Response/${Testsite}_ExpectResult/6_1_response_get_all_promotions_by_shelf.json
${6_3_3_response_get_all_promotions_by_shelf}                ${CURDIR}/../Response/${Testsite}_ExpectResult/6_3_3_response_get_all_promotions_by_shelf.json
${6_3_6_response_get_all_promotions_by_shelf}                ${CURDIR}/../Response/${Testsite}_ExpectResult/6_3_6_response_get_all_promotions_by_shelf.json
${6_3_8_response_get_all_promotions_by_shelf}                ${CURDIR}/../Response/${Testsite}_ExpectResult/6_3_8_response_get_all_promotions_by_shelf.json

# 7 
${7_body_get_term_and_condition_for_my_channel}              ${CURDIR}/../Body/${Testsite}/7_body_get_term_and_condition_for_my_channel.json
${7_1_body_get_term_and_condition_for_my_channel}            ${CURDIR}/../Body/${Testsite}/TestCaseCondition/7_1_body_get_term_and_condition_for_my_channel.json
${7_2_body_get_term_and_condition_for_my_channel}            ${CURDIR}/../Body/${Testsite}/TestCaseCondition/7_2_body_get_term_and_condition_for_my_channel.json
${7_3_1_body_get_term_and_condition_for_my_channel}          ${CURDIR}/../Body/${Testsite}/TestCaseCondition/7_3_1_body_get_term_and_condition_for_my_channel.json
${7_3_2_body_get_term_and_condition_for_my_channel}          ${CURDIR}/../Body/${Testsite}/TestCaseCondition/7_3_2_body_get_term_and_condition_for_my_channel.json
${7_3_3_body_get_term_and_condition_for_my_channel}          ${CURDIR}/../Body/${Testsite}/TestCaseCondition/7_3_3_body_get_term_and_condition_for_my_channel.json

${7_response_get_term_and_condition_for_my_channel}          ${CURDIR}/../Response/Schema/7_response_get_term_and_condition_for_my_channel.json
${7_1_response_get_term_and_condition_for_my_channel}        ${CURDIR}/../Response/${Testsite}_ExpectResult/7_1_response_get_term_and_condition_for_my_channel.json
${7_3_1_response_get_term_and_condition_for_my_channel}      ${CURDIR}/../Response/${Testsite}_ExpectResult/7_3_1_response_get_term_and_condition_for_my_channel.json
${7_3_2_response_get_term_and_condition_for_my_channel}      ${CURDIR}/../Response/${Testsite}_ExpectResult/7_3_2_response_get_term_and_condition_for_my_channel.json
${7_3_3_response_get_term_and_condition_for_my_channel}      ${CURDIR}/../Response/${Testsite}_ExpectResult/7_3_3_response_get_term_and_condition_for_my_channel.json

# 8 
${8_body_get_package_service_content_vdo}                    ${CURDIR}/../Body/${Testsite}/8_body_get_package_service_content_vdo.json
${8_1_body_get_package_service_content_vdo}                  ${CURDIR}/../Body/${Testsite}/TestCaseCondition/8_1_body_get_package_service_content_vdo.json
${8_2_body_get_package_service_content_vdo}                  ${CURDIR}/../Body/${Testsite}/TestCaseCondition/8_2_body_get_package_service_content_vdo.json

${8_response_get_package_service_content_vdo}                ${CURDIR}/../Response/Schema/8_response_get_package_service_content_vdo.json
${8_1_response_get_package_service_content_vdo}              ${CURDIR}/../Response/${Testsite}_ExpectResult/8_1_response_get_package_service_content_vdo.json

# 9
${9_body_get_package_service_internet}                       ${CURDIR}/../Body/${Testsite}/9_body_get_package_service_internet.json
${9_1_body_get_package_service_internet}                     ${CURDIR}/../Body/${Testsite}/TestCaseCondition/9_1_body_get_package_service_internet.json
${9_2_body_get_package_service_internet}                     ${CURDIR}/../Body/${Testsite}/TestCaseCondition/9_2_body_get_package_service_internet.json

${9_response_get_package_service_internet}                   ${CURDIR}/../Response/Schema/9_response_get_package_service_internet.json
${9_1_response_get_package_service_internet}                 ${CURDIR}/../Response/${Testsite}_ExpectResult/9_1_response_get_package_service_internet.json

# 10
${10_body_get_package_service_mms}                           ${CURDIR}/../Body/${Testsite}/10_body_get_package_service_mms.json
${10_1_body_get_package_service_mms}                         ${CURDIR}/../Body/${Testsite}/TestCaseCondition/10_1_body_get_package_service_mms.json
${10_2_body_get_package_service_mms}                         ${CURDIR}/../Body/${Testsite}/TestCaseCondition/10_2_body_get_package_service_mms.json

${10_response_get_package_service_mms}                       ${CURDIR}/../Response/Schema/10_response_get_package_service_mms.json 
${10_1_response_get_package_service_mms}                     ${CURDIR}/../Response/${Testsite}_ExpectResult/10_1_response_get_package_service_mms.json

# 11
${11_body_get_package_service_sms}                           ${CURDIR}/../Body/${Testsite}/11_body_get_package_service_sms.json
${11_1_body_get_package_service_sms}                         ${CURDIR}/../Body/${Testsite}/TestCaseCondition/11_1_body_get_package_service_sms.json
${11_2_body_get_package_service_sms}                         ${CURDIR}/../Body/${Testsite}/TestCaseCondition/11_2_body_get_package_service_sms.json

${11_response_get_package_service_sms}                       ${CURDIR}/../Response/Schema/11_response_get_package_service_sms.json
${11_1_response_get_package_service_sms}                     ${CURDIR}/../Response/${Testsite}_ExpectResult/11_1_response_get_package_service_sms.json

# 12
${12_body_get_package_vertical_apps}                         ${CURDIR}/../Body/${Testsite}/12_body_get_package_vertical_apps.json
${12_1_body_get_package_vertical_apps}                       ${CURDIR}/../Body/${Testsite}/TestCaseCondition/12_1_body_get_package_vertical_apps.json
${12_2_body_get_package_vertical_apps}                       ${CURDIR}/../Body/${Testsite}/TestCaseCondition/12_2_body_get_package_vertical_apps.json

${12_response_get_package_vertical_apps}                     ${CURDIR}/../Response/Schema/12_response_get_package_vertical_apps.json
${12_1_response_get_package_vertical_apps}                   ${CURDIR}/../Response/${Testsite}_ExpectResult/12_1_response_get_package_vertical_apps.json

# 13 
${13_body_get_package_service_voice}                         ${CURDIR}/../Body/${Testsite}/13_body_get_package_service_voice.json
${13_1_body_get_package_service_voice}                       ${CURDIR}/../Body/${Testsite}/TestCaseCondition/13_1_body_get_package_service_voice.json
${13_2_body_get_package_service_voice}                       ${CURDIR}/../Body/${Testsite}/TestCaseCondition/13_2_body_get_package_service_voice.json

${13_response_get_package_service_voice}                     ${CURDIR}/../Response/Schema/13_response_get_package_service_voice.json
${13_1_response_get_package_service_voice}                   ${CURDIR}/../Response/${Testsite}_ExpectResult/13_1_response_get_package_service_voice.json

# 14
${14_body_get_package_service_voice_free_number}             ${CURDIR}/../Body/${Testsite}/14_body_get_package_service_voice_free_number.json
${14_1_body_get_package_service_voice_free_number}           ${CURDIR}/../Body/${Testsite}/TestCaseCondition/14_1_body_get_package_service_voice_free_number.json
${14_2_body_get_package_service_voice_free_number}           ${CURDIR}/../Body/${Testsite}/TestCaseCondition/14_2_body_get_package_service_voice_free_number.json

${14_response_get_package_service_voice_free_number}         ${CURDIR}/../Response/Schema/14_response_get_package_service_voice_free_number.json
${14_1_response_get_package_service_voice_free_number}       ${CURDIR}/../Response/${Testsite}_ExpectResult/14_1_response_get_package_service_voice_free_number.json

# 15
${15_body_get_package_service_wift}                          ${CURDIR}/../Body/${Testsite}/15_body_get_package_service_wift.json
${15_1_body_get_package_service_wift}                        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/15_1_body_get_package_service_wift.json
${15_2_body_get_package_service_wift}                        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/15_2_body_get_package_service_wift.json

${15_response_get_package_service_wift}                      ${CURDIR}/../Response/Schema/15_response_get_package_service_wift.json
${15_1_response_get_package_service_wift}                    ${CURDIR}/../Response/${Testsite}_ExpectResult/15_1_response_get_package_service_wift.json

# 16
${16_body_get_all_promotions_by_shelf_for_pre_paid}          ${CURDIR}/../Body/${Testsite}/16_body_get_all_promotions_by_shelf_for_pre_paid.json
${16_1_body_get_all_promotions_by_shelf_for_pre_paid}        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/16_1_body_get_all_promotions_by_shelf_for_pre_paid.json
${16_2_body_get_all_promotions_by_shelf_for_pre_paid}        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/16_2_body_get_all_promotions_by_shelf_for_pre_paid.json
${16_3_1_body_get_all_promotions_by_shelf_for_pre_paid}      ${CURDIR}/../Body/${Testsite}/TestCaseCondition/16_3_1_body_get_all_promotions_by_shelf_for_pre_paid.json
${16_3_2_body_get_all_promotions_by_shelf_for_pre_paid}      ${CURDIR}/../Body/${Testsite}/TestCaseCondition/16_3_2_body_get_all_promotions_by_shelf_for_pre_paid.json
${16_3_3_body_get_all_promotions_by_shelf_for_pre_paid}      ${CURDIR}/../Body/${Testsite}/TestCaseCondition/16_3_3_body_get_all_promotions_by_shelf_for_pre_paid.json
${16_3_4_body_get_all_promotions_by_shelf_for_pre_paid}      ${CURDIR}/../Body/${Testsite}/TestCaseCondition/16_3_4_body_get_all_promotions_by_shelf_for_pre_paid.json
${16_3_5_body_get_all_promotions_by_shelf_for_pre_paid}      ${CURDIR}/../Body/${Testsite}/TestCaseCondition/16_3_5_body_get_all_promotions_by_shelf_for_pre_paid.json

${16_response_get_all_promotions_by_shelf_for_pre_paid}      ${CURDIR}/../Response/Schema/16_response_get_all_promotions_by_shelf_for_pre_paid.json
${16_1_response_get_all_promotions_by_shelf_for_pre_paid}    ${CURDIR}/../Response/${Testsite}_ExpectResult/16_1_response_get_all_promotions_by_shelf_for_pre_paid.json

# 17
${17_body_get_promotion_product_rules}                       ${CURDIR}/../Body/${Testsite}/17_body_get_promotion_product_rules.json
${17_1_body_get_promotion_product_rules}                     ${CURDIR}/../Body/${Testsite}/TestCaseCondition/17_1_body_get_promotion_product_rules.json
${17_2_body_get_promotion_product_rules}                     ${CURDIR}/../Body/${Testsite}/TestCaseCondition/17_2_body_get_promotion_product_rules.json
${17_3_1_body_get_promotion_product_rules}                   ${CURDIR}/../Body/${Testsite}/TestCaseCondition/17_3_1_body_get_promotion_product_rules.json
${17_3_2_body_get_promotion_product_rules}                   ${CURDIR}/../Body/${Testsite}/TestCaseCondition/17_3_2_body_get_promotion_product_rules.json
${17_3_3_body_get_promotion_product_rules}                   ${CURDIR}/../Body/${Testsite}/TestCaseCondition/17_3_3_body_get_promotion_product_rules.json
${17_3_4_body_get_promotion_product_rules}                   ${CURDIR}/../Body/${Testsite}/TestCaseCondition/17_3_4_body_get_promotion_product_rules.json

${17_response_get_promotion_product_rules}                   ${CURDIR}/../Response/Schema/17_response_get_promotion_product_rules.json
${17_1_response_get_promotion_product_rules}                 ${CURDIR}/../Response/${Testsite}_ExpectResult/17_1_response_get_promotion_product_rules.json
${17_3_4_response_get_promotion_product_rules}               ${CURDIR}/../Response/${Testsite}_ExpectResult/17_3_4_response_get_promotion_product_rules.json

# 18
${18_body_get_promotions}                                    ${CURDIR}/../Body/${Testsite}/18_body_get_promotions.json
${18_1_body_get_promotions}                                  ${CURDIR}/../Body/${Testsite}/TestCaseCondition/18_1_body_get_promotions.json
${18_2_body_get_promotions}                                  ${CURDIR}/../Body/${Testsite}/TestCaseCondition/18_2_body_get_promotions.json
${18_3_1_body_get_promotions}                                ${CURDIR}/../Body/${Testsite}/TestCaseCondition/18_3_1_body_get_promotions.json
${18_3_2_body_get_promotions}                                ${CURDIR}/../Body/${Testsite}/TestCaseCondition/18_3_2_body_get_promotions.json
${18_4_1_body_get_promotions}                                ${CURDIR}/../Body/${Testsite}/TestCaseCondition/18_4_1_body_get_promotions.json
${18_4_2_body_get_promotions}                                ${CURDIR}/../Body/${Testsite}/TestCaseCondition/18_4_2_body_get_promotions.json
${18_4_3_body_get_promotions}                                ${CURDIR}/../Body/${Testsite}/TestCaseCondition/18_4_3_body_get_promotions.json

${18_response_get_promotions}                                ${CURDIR}/../Response/Schema/18_response_get_promotions.json
${18_1_response_get_promotions}                              ${CURDIR}/../Response/${Testsite}_ExpectResult/18_1_response_get_promotions.json

# 19
${19_body_get_promotions_by_promotion_codes}                 ${CURDIR}/../Body/${Testsite}/19_body_get_promotions_by_promotion_codes.json
${19_1_1_body_get_promotions_by_promotion_codes}             ${CURDIR}/../Body/${Testsite}/TestCaseCondition/19_1_1_body_get_promotions_by_promotion_codes.json
${19_1_2_body_get_promotions_by_promotion_codes}             ${CURDIR}/../Body/${Testsite}/TestCaseCondition/19_1_2_body_get_promotions_by_promotion_codes.json
${19_1_3_body_get_promotions_by_promotion_codes}             ${CURDIR}/../Body/${Testsite}/TestCaseCondition/19_1_3_body_get_promotions_by_promotion_codes.json
${19_1_4_body_get_promotions_by_promotion_codes}             ${CURDIR}/../Body/${Testsite}/TestCaseCondition/19_1_4_body_get_promotions_by_promotion_codes.json
${19_1_5_body_get_promotions_by_promotion_codes}             ${CURDIR}/../Body/${Testsite}/TestCaseCondition/19_1_5_body_get_promotions_by_promotion_codes.json
${19_1_6_body_get_promotions_by_promotion_codes}             ${CURDIR}/../Body/${Testsite}/TestCaseCondition/19_1_6_body_get_promotions_by_promotion_codes.json
${19_1_7_body_get_promotions_by_promotion_codes}             ${CURDIR}/../Body/${Testsite}/TestCaseCondition/19_1_7_body_get_promotions_by_promotion_codes.json
${19_1_8_body_get_promotions_by_promotion_codes}             ${CURDIR}/../Body/${Testsite}/TestCaseCondition/19_1_8_body_get_promotions_by_promotion_codes.json
${19_1_9_body_get_promotions_by_promotion_codes}             ${CURDIR}/../Body/${Testsite}/TestCaseCondition/19_1_9_body_get_promotions_by_promotion_codes.json
${19_1_10_body_get_promotions_by_promotion_codes}            ${CURDIR}/../Body/${Testsite}/TestCaseCondition/19_1_10_body_get_promotions_by_promotion_codes.json
${19_2_1_body_get_promotions_by_promotion_codes}             ${CURDIR}/../Body/${Testsite}/TestCaseCondition/19_2_1_body_get_promotions_by_promotion_codes.json
${19_2_2_body_get_promotions_by_promotion_codes}             ${CURDIR}/../Body/${Testsite}/TestCaseCondition/19_2_2_body_get_promotions_by_promotion_codes.json
${19_2_3_body_get_promotions_by_promotion_codes}             ${CURDIR}/../Body/${Testsite}/TestCaseCondition/19_2_3_body_get_promotions_by_promotion_codes.json
${19_2_4_body_get_promotions_by_promotion_codes}             ${CURDIR}/../Body/${Testsite}/TestCaseCondition/19_2_4_body_get_promotions_by_promotion_codes.json

${19_response_get_promotions_by_promotion_codes}             ${CURDIR}/../Response/Schema/19_response_get_promotions_by_promotion_codes.json
${19_1_2_response_get_promotions_by_promotion_codes}         ${CURDIR}/../Response/${Testsite}_ExpectResult/19_1_2_response_get_promotions_by_promotion_codes.json
${19_1_4_response_get_promotions_by_promotion_codes}         ${CURDIR}/../Response/${Testsite}_ExpectResult/19_1_4_response_get_promotions_by_promotion_codes.json
${19_1_6_response_get_promotions_by_promotion_codes}         ${CURDIR}/../Response/${Testsite}_ExpectResult/19_1_6_response_get_promotions_by_promotion_codes.json
${19_1_8_response_get_promotions_by_promotion_codes}         ${CURDIR}/../Response/${Testsite}_ExpectResult/19_1_8_response_get_promotions_by_promotion_codes.json
${19_1_10_response_get_promotions_by_promotion_codes}        ${CURDIR}/../Response/${Testsite}_ExpectResult/19_1_10_response_get_promotions_by_promotion_codes.json

# 20
${20_body_get_zones_of_package}                              ${CURDIR}/../Body/${Testsite}/20_body_get_zones_of_package.json
${20_1_body_get_zones_of_package}                            ${CURDIR}/../Body/${Testsite}/TestCaseCondition/20_1_body_get_zones_of_package.json
${20_2_body_get_zones_of_package}                            ${CURDIR}/../Body/${Testsite}/TestCaseCondition/20_2_body_get_zones_of_package.json

${20_response_get_zones_of_package}                          ${CURDIR}/../Response/Schema/20_response_get_zones_of_package.json
${20_1_response_get_zones_of_package}                        ${CURDIR}/../Response/${Testsite}_ExpectResult/20_1_response_get_zones_of_package.json
${20_2_response_get_zones_of_package}                        ${CURDIR}/../Response/${Testsite}_ExpectResult/20_2_response_get_zones_of_package.json

# 21
${21_body_update_table_price_master}                         ${CURDIR}/../Body/${Testsite}/21_body_update_table_price_master.json
${21_response_update_table_price_master}                     ${CURDIR}/../Response/Schema/21_response_update_table_price_master.json

# 22
${22_body_sync_trades_daily_for_my_channel}                  ${CURDIR}/../Body/${Testsite}/22_body_sync_trades_daily_for_my_channel.json
${22_1_body_sync_trades_daily_for_my_channel}                ${CURDIR}/../Body/${Testsite}/TestCaseCondition/22_1_body_sync_trades_daily_for_my_channel.json
${22_2_body_sync_trades_daily_for_my_channel}                ${CURDIR}/../Body/${Testsite}/TestCaseCondition/22_2_body_sync_trades_daily_for_my_channel.json

${22_response_sync_trades_daily_for_my_channel}              ${CURDIR}/../Response/Schema/22_response_sync_trades_daily_for_my_channel.json
${22_1_response_sync_trades_daily_for_my_channel}            ${CURDIR}/../Response/${Testsite}_ExpectResult/22_1_response_sync_trades_daily_for_my_channel.json
${22_2_response_sync_trades_daily_for_my_channel}            ${CURDIR}/../Response/${Testsite}_ExpectResult/22_2_response_sync_trades_daily_for_my_channel.json

# 23
${23_body_get_all_vas_items_by_shelf}                        ${CURDIR}/../Body/${Testsite}/23_body_get_all_vas_items_by_shelf.json
${23_1_body_get_all_vas_items_by_shelf}                      ${CURDIR}/../Body/${Testsite}/TestCaseCondition/23_1_body_get_all_vas_items_by_shelf.json
${23_2_1_body_get_all_vas_items_by_shelf}                    ${CURDIR}/../Body/${Testsite}/TestCaseCondition/23_2_1_body_get_all_vas_items_by_shelf.json
${23_2_2_body_get_all_vas_items_by_shelf}                    ${CURDIR}/../Body/${Testsite}/TestCaseCondition/23_2_2_body_get_all_vas_items_by_shelf.json

${23_response_get_all_vas_items_by_shelf}                    ${CURDIR}/../Response/Schema/23_response_get_all_vas_items_by_shelf.json

# 24 
${24_body_get_all_accessories_by_category}                   ${CURDIR}/../Body/${Testsite}/24_body_get_all_accessories_by_category.json
${24_response_get_all_accessories_by_category}               ${CURDIR}/../Response/Schema/24_response_get_all_accessories_by_category.json

# 25 
${25_body_get_all_accessories_by_product}                    ${CURDIR}/../Body/${Testsite}/25_body_get_all_accessories_by_product.json
${25_response_get_all_accessories_by_product}                ${CURDIR}/../Response/Schema/25_response_get_all_accessories_by_product.json

# 26 
${26_body_get_accessory_categories}                          ${CURDIR}/../Body/${Testsite}/26_body_get_accessory_categories.json
${26_response_get_accessory_categories}                      ${CURDIR}/../Response/Schema/26_response_get_accessory_categories.json

# 27 
${27_body_get_asp_banks}                                     ${CURDIR}/../Body/${Testsite}/27_body_get_asp_banks.json
${27_1_body_get_asp_banks}                                   ${CURDIR}/../Body/${Testsite}/TestCaseCondition/27_1_body_get_asp_banks.json
${27_2_body_get_asp_banks}                                    ${CURDIR}/../Body/${Testsite}/TestCaseCondition/27_2_body_get_asp_banks.json

${27_response_get_asp_banks}                                 ${CURDIR}/../Response/Schema/27_response_get_asp_banks.json
${27_1_response_get_asp_banks}                               ${CURDIR}/../Response/${Testsite}_ExpectResult/27_1_response_get_asp_banks.json
${27_2_response_get_asp_banks}                               ${CURDIR}/../Response/${Testsite}_ExpectResult/27_2_response_get_asp_banks.json

# 28 
${28_body_get_banks_promotion}                               ${CURDIR}/../Body/${Testsite}/28_body_get_banks_promotion.json
${28_1_body_get_banks_promotion}                             ${CURDIR}/../Body/${Testsite}/TestCaseCondition/28_1_body_get_banks_promotion.json
${28_2_body_get_banks_promotion}                             ${CURDIR}/../Body/${Testsite}/TestCaseCondition/28_2_body_get_banks_promotion.json

${28_response_get_banks_promotion}                           ${CURDIR}/../Response/Schema/28_response_get_banks_promotion.json
${28_1_response_get_banks_promotion}                         ${CURDIR}/../Response/${Testsite}_ExpectResult/28_1_response_get_banks_promotion.json
${28_2_response_get_banks_promotion}                         ${CURDIR}/../Response/${Testsite}_ExpectResult/28_2_response_get_banks_promotion.json

# 29 
${29_body_get_installments_for_partner}                      ${CURDIR}/../Body/${Testsite}/29_body_get_installments_for_partner.json
${29_3_1_body_get_installments_for_partner}                  ${CURDIR}/../Body/${Testsite}/TestCaseCondition/29_3_1_body_get_installments_for_partner.json
${29_3_2_body_get_installments_for_partner}                  ${CURDIR}/../Body/${Testsite}/TestCaseCondition/29_3_2_body_get_installments_for_partner.json
${29_4_1_body_get_installments_for_partner}                  ${CURDIR}/../Body/${Testsite}/TestCaseCondition/29_4_1_body_get_installments_for_partner.json
${29_4_2_body_get_installments_for_partner}                  ${CURDIR}/../Body/${Testsite}/TestCaseCondition/29_4_2_body_get_installments_for_partner.json
${29_5_body_get_installments_for_partner}                    ${CURDIR}/../Body/${Testsite}/TestCaseCondition/29_5_body_get_installments_for_partner.json

${29_response_get_installments_for_partner}                  ${CURDIR}/../Response/Schema/29_response_get_installments_for_partner.json

# 30 
${30_body_get_brands_of_product}                             ${CURDIR}/../Body/${Testsite}/30_body_get_brands_of_product.json
${30_1_body_get_brands_of_product}                           ${CURDIR}/../Body/${Testsite}/TestCaseCondition/30_1_body_get_brands_of_product.json
${30_2_body_get_brands_of_product}                           ${CURDIR}/../Body/${Testsite}/TestCaseCondition/30_2_body_get_brands_of_product.json

${30_response_get_brands_of_product}                         ${CURDIR}/../Response/Schema/30_response_get_brands_of_product.json
${30_1_response_get_brands_of_product}                       ${CURDIR}/../Response/${Testsite}_ExpectResult/30_1_response_get_brands_of_product.json
${30_2_response_get_brands_of_product}                       ${CURDIR}/../Response/${Testsite}_ExpectResult/30_2_response_get_brands_of_product.json

# 31 
${31_body_get_campaign_by_trade_model}                       ${CURDIR}/../Body/${Testsite}/31_body_get_campaign_by_trade_model.json
${31_1_1_body_get_campaign_by_trade_model}                   ${CURDIR}/../Body/${Testsite}/TestCaseCondition/31_1_1_body_get_campaign_by_trade_model.json
${31_1_2_body_get_campaign_by_trade_model}                   ${CURDIR}/../Body/${Testsite}/TestCaseCondition/31_1_2_body_get_campaign_by_trade_model.json
${31_1_3_body_get_campaign_by_trade_model}                   ${CURDIR}/../Body/${Testsite}/TestCaseCondition/31_1_3_body_get_campaign_by_trade_model.json
${31_1_4_body_get_campaign_by_trade_model}                   ${CURDIR}/../Body/${Testsite}/TestCaseCondition/31_1_4_body_get_campaign_by_trade_model.json
${31_2_1_body_get_campaign_by_trade_model}                   ${CURDIR}/../Body/${Testsite}/TestCaseCondition/31_2_1_body_get_campaign_by_trade_model.json
${31_2_2_body_get_campaign_by_trade_model}                   ${CURDIR}/../Body/${Testsite}/TestCaseCondition/31_2_2_body_get_campaign_by_trade_model.json
${31_2_3_body_get_campaign_by_trade_model}                   ${CURDIR}/../Body/${Testsite}/TestCaseCondition/31_2_3_body_get_campaign_by_trade_model.json
${31_3_1_body_get_campaign_by_trade_model}                   ${CURDIR}/../Body/${Testsite}/TestCaseCondition/31_3_1_body_get_campaign_by_trade_model.json
${31_3_2_body_get_campaign_by_trade_model}                   ${CURDIR}/../Body/${Testsite}/TestCaseCondition/31_3_2_body_get_campaign_by_trade_model.json
${31_4_1_body_get_campaign_by_trade_model}                   ${CURDIR}/../Body/${Testsite}/TestCaseCondition/31_4_1_body_get_campaign_by_trade_model.json
${31_4_2_body_get_campaign_by_trade_model}                   ${CURDIR}/../Body/${Testsite}/TestCaseCondition/31_4_2_body_get_campaign_by_trade_model.json
${31_5_1_body_get_campaign_by_trade_model}                   ${CURDIR}/../Body/${Testsite}/TestCaseCondition/31_5_1_body_get_campaign_by_trade_model.json
${31_5_2_body_get_campaign_by_trade_model}                   ${CURDIR}/../Body/${Testsite}/TestCaseCondition/31_5_2_body_get_campaign_by_trade_model.json
${31_6_1_body_get_campaign_by_trade_model}                   ${CURDIR}/../Body/${Testsite}/TestCaseCondition/31_6_1_body_get_campaign_by_trade_model.json
${31_6_2_body_get_campaign_by_trade_model}                   ${CURDIR}/../Body/${Testsite}/TestCaseCondition/31_6_2_body_get_campaign_by_trade_model.json
${31_7_1_body_get_campaign_by_trade_model}                   ${CURDIR}/../Body/${Testsite}/TestCaseCondition/31_7_1_body_get_campaign_by_trade_model.json
${31_7_2_body_get_campaign_by_trade_model}                   ${CURDIR}/../Body/${Testsite}/TestCaseCondition/31_7_2_body_get_campaign_by_trade_model.json
${31_8_1_body_get_campaign_by_trade_model}                   ${CURDIR}/../Body/${Testsite}/TestCaseCondition/31_8_1_body_get_campaign_by_trade_model.json
${31_8_2_body_get_campaign_by_trade_model}                   ${CURDIR}/../Body/${Testsite}/TestCaseCondition/31_8_2_body_get_campaign_by_trade_model.json
${31_1_1_body_get_campaign_by_trade_model}                   ${CURDIR}/../Body/${Testsite}/TestCaseCondition/31_1_1_body_get_campaign_by_trade_model.json
${31_1_4_body_get_campaign_by_trade_model}                   ${CURDIR}/../Body/${Testsite}/TestCaseCondition/31_1_4_body_get_campaign_by_trade_model.json
${31_2_2_body_get_campaign_by_trade_model}                   ${CURDIR}/../Body/${Testsite}/TestCaseCondition/31_2_2_body_get_campaign_by_trade_model.json

${31_response_get_campaign_by_trade_model}                   ${CURDIR}/../Response/Schema/31_response_get_campaign_by_trade_model.json
${31_1_1_response_get_campaign_by_trade_model}               ${CURDIR}/../Response/${Testsite}_ExpectResult/31_1_1_response_get_campaign_by_trade_model.json
${31_1_4_response_get_campaign_by_trade_model}               ${CURDIR}/../Response/${Testsite}_ExpectResult/31_1_4_response_get_campaign_by_trade_model.json
${31_2_2_response_get_campaign_by_trade_model}               ${CURDIR}/../Response/${Testsite}_ExpectResult/31_2_2_response_get_campaign_by_trade_model.json
${31_3_1_response_get_campaign_by_trade_model}               ${CURDIR}/../Response/${Testsite}_ExpectResult/31_3_1_response_get_campaign_by_trade_model.json
${31_4_1_response_get_campaign_by_trade_model}               ${CURDIR}/../Response/${Testsite}_ExpectResult/31_4_1_response_get_campaign_by_trade_model.json
${31_5_1_response_get_campaign_by_trade_model}               ${CURDIR}/../Response/${Testsite}_ExpectResult/31_5_1_response_get_campaign_by_trade_model.json
${31_6_1_response_get_campaign_by_trade_model}               ${CURDIR}/../Response/${Testsite}_ExpectResult/31_6_1_response_get_campaign_by_trade_model.json
${31_7_1_response_get_campaign_by_trade_model}               ${CURDIR}/../Response/${Testsite}_ExpectResult/31_7_1_response_get_campaign_by_trade_model.json

# 32 
${32_body_get_catalog_subtypes_by_catalogtype}               ${CURDIR}/../Body/${Testsite}/32_body_get_catalog_subtypes_by_catalogtype.json
${32_1_body_get_catalog_subtypes_by_catalogtype}             ${CURDIR}/../Body/${Testsite}/TestCaseCondition/32_1_body_get_catalog_subtypes_by_catalogtype.json
${32_2_body_get_catalog_subtypes_by_catalogtype}             ${CURDIR}/../Body/${Testsite}/TestCaseCondition/32_2_body_get_catalog_subtypes_by_catalogtype.json
${32_3_body_get_catalog_subtypes_by_catalogtype}             ${CURDIR}/../Body/${Testsite}/TestCaseCondition/32_3_body_get_catalog_subtypes_by_catalogtype.json
${32_4_1_body_get_catalog_subtypes_by_catalogtype}           ${CURDIR}/../Body/${Testsite}/TestCaseCondition/32_4_1_body_get_catalog_subtypes_by_catalogtype.json
${32_4_2_body_get_catalog_subtypes_by_catalogtype}           ${CURDIR}/../Body/${Testsite}/TestCaseCondition/32_4_2_body_get_catalog_subtypes_by_catalogtype.json

${32_response_get_catalog_subtypes_by_catalogtype}           ${CURDIR}/../Response/Schema/32_response_get_catalog_subtypes_by_catalogtype.json
${32_1_response_get_catalog_subtypes_by_catalogtype}         ${CURDIR}/../Response/${Testsite}_ExpectResult/32_1_response_get_catalog_subtypes_by_catalogtype.json

# 33 
${33_body_get_catalogtypes}                                  ${CURDIR}/../Body/${Testsite}/33_body_get_catalogtypes.json
${33_1_body_get_catalogtypes}                                ${CURDIR}/../Body/${Testsite}/TestCaseCondition/33_1_body_get_catalogtypes.json
${33_2_1_body_get_catalogtypes}                              ${CURDIR}/../Body/${Testsite}/TestCaseCondition/33_2_1_body_get_catalogtypes.json
${33_2_2_body_get_catalogtypes}                              ${CURDIR}/../Body/${Testsite}/TestCaseCondition/33_2_2_body_get_catalogtypes.json

${33_response_get_catalogtypes}                              ${CURDIR}/../Response/Schema/33_response_get_catalogtypes.json
${33_1_response_get_catalogtypes}                            ${CURDIR}/../Response/${Testsite}_ExpectResult/33_1_response_get_catalogtypes.json

# 34 
${34_body_get_category_by_catalog}                           ${CURDIR}/../Body/${Testsite}/34_body_get_category_by_catalog.json
${34_1_1_body_get_category_by_catalog}                       ${CURDIR}/../Body/${Testsite}/TestCaseCondition/34_1_1_body_get_category_by_catalog.json
${34_1_2_body_get_category_by_catalog}                       ${CURDIR}/../Body/${Testsite}/TestCaseCondition/34_1_2_body_get_category_by_catalog.json
${34_1_3_body_get_category_by_catalog}                       ${CURDIR}/../Body/${Testsite}/TestCaseCondition/34_1_3_body_get_category_by_catalog.json
${34_2_body_get_category_by_catalog}                         ${CURDIR}/../Body/${Testsite}/TestCaseCondition/34_2_body_get_category_by_catalog.json
${34_3_body_get_category_by_catalog}                         ${CURDIR}/../Body/${Testsite}/TestCaseCondition/34_3_body_get_category_by_catalog.json
${34_4_1_body_get_category_by_catalog}                       ${CURDIR}/../Body/${Testsite}/TestCaseCondition/34_4_1_body_get_category_by_catalog.json
${34_4_2_body_get_category_by_catalog}                       ${CURDIR}/../Body/${Testsite}/TestCaseCondition/34_4_2_body_get_category_by_catalog.json

${34_response_get_category_by_catalog}                       ${CURDIR}/../Response/Schema/34_response_get_category_by_catalog.json
${34_1_1_response_get_category_by_catalog}                   ${CURDIR}/../Response/${Testsite}_ExpectResult/34_1_1_response_get_category_by_catalog.json
${34_1_2_response_get_category_by_catalog}                   ${CURDIR}/../Response/${Testsite}_ExpectResult/34_1_2_response_get_category_by_catalog.json
${34_1_3_response_get_category_by_catalog}                   ${CURDIR}/../Response/${Testsite}_ExpectResult/34_1_3_response_get_category_by_catalog.json
${34_2_response_get_category_by_catalog}                     ${CURDIR}/../Response/${Testsite}_ExpectResult/34_2_response_get_category_by_catalog.json

# 35 
${35_body_get_products_by_criteria}                          ${CURDIR}/../Body/${Testsite}/35_body_get_products_by_criteria.json
${35_1_body_get_products_by_criteria}                        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/35_1_body_get_products_by_criteria.json
${35_2_body_get_products_by_criteria}                        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/35_2_body_get_products_by_criteria.json
${35_3_1_body_get_products_by_criteria}                      ${CURDIR}/../Body/${Testsite}/TestCaseCondition/35_3_1_body_get_products_by_criteria.json
${35_3_2_body_get_products_by_criteria}                      ${CURDIR}/../Body/${Testsite}/TestCaseCondition/35_3_2_body_get_products_by_criteria.json
${35_4_body_get_products_by_criteria}                        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/35_4_body_get_products_by_criteria.json
${35_5_body_get_products_by_criteria}                        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/35_5_body_get_products_by_criteria.json
${35_6_1_body_get_products_by_criteria}                      ${CURDIR}/../Body/${Testsite}/TestCaseCondition/35_6_1_body_get_products_by_criteria.json
${35_6_2_body_get_products_by_criteria}                      ${CURDIR}/../Body/${Testsite}/TestCaseCondition/35_6_2_body_get_products_by_criteria.json

${35_response_get_products_by_criteria}                      ${CURDIR}/../Response/Schema/35_response_get_products_by_criteria.json

# 36 
${36_body_get_all_product}                                   ${CURDIR}/../Body/${Testsite}/36_body_get_all_product.json
${36_1_body_get_all_product}                                 ${CURDIR}/../Body/${Testsite}/TestCaseCondition/36_1_body_get_all_product.json
${36_2_1_body_get_all_product}                               ${CURDIR}/../Body/${Testsite}/TestCaseCondition/36_2_1_body_get_all_product.json
${36_2_2_body_get_all_product}                               ${CURDIR}/../Body/${Testsite}/TestCaseCondition/36_2_2_body_get_all_product.json
${36_3_1_body_get_all_product}                               ${CURDIR}/../Body/${Testsite}/TestCaseCondition/36_3_1_body_get_all_product.json
${36_3_2_body_get_all_product}                               ${CURDIR}/../Body/${Testsite}/TestCaseCondition/36_3_2_body_get_all_product.json
${36_4_1_body_get_all_product}                               ${CURDIR}/../Body/${Testsite}/TestCaseCondition/36_4_1_body_get_all_product.json
${36_4_2_body_get_all_product}                               ${CURDIR}/../Body/${Testsite}/TestCaseCondition/36_4_2_body_get_all_product.json

${36_response_get_all_product}                               ${CURDIR}/../Response/Schema/36_response_get_all_product.json

# 37 
${37_body_get_products_by_brand_and_model}                   ${CURDIR}/../Body/${Testsite}/37_body_get_products_by_brand_and_model.json
${37_1_body_get_products_by_brand_and_model}                 ${CURDIR}/../Body/${Testsite}/TestCaseCondition/37_1_body_get_products_by_brand_and_model.json
${37_2_1_body_get_products_by_brand_and_model}               ${CURDIR}/../Body/${Testsite}/TestCaseCondition/37_2_1_body_get_products_by_brand_and_model.json
${37_2_2_body_get_products_by_brand_and_model}               ${CURDIR}/../Body/${Testsite}/TestCaseCondition/37_2_2_body_get_products_by_brand_and_model.json
${37_2_3_body_get_products_by_brand_and_model}               ${CURDIR}/../Body/${Testsite}/TestCaseCondition/37_2_3_body_get_products_by_brand_and_model.json
${37_3_1_body_get_products_by_brand_and_model}               ${CURDIR}/../Body/${Testsite}/TestCaseCondition/37_3_1_body_get_products_by_brand_and_model.json
${37_3_2_body_get_products_by_brand_and_model}               ${CURDIR}/../Body/${Testsite}/TestCaseCondition/37_3_2_body_get_products_by_brand_and_model.json

${37_response_get_products_by_brand_and_model}               ${CURDIR}/../Response/Schema/37_response_get_products_by_brand_and_model.json
${37_1_response_get_products_by_brand_and_model}             ${CURDIR}/../Response/${Testsite}_ExpectResult/37_1_response_get_products_by_brand_and_model.json

# 38 
${38_body_get_best_seller_products}                          ${CURDIR}/../Body/${Testsite}/38_body_get_best_seller_products.json
${38_1_body_get_best_seller_products}                        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/38_1_body_get_best_seller_products.json                                    
${38_2_body_get_best_seller_products}                        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/38_2_body_get_best_seller_products.json                                    

${38_response_get_best_seller_products}                      ${CURDIR}/../Response/Schema/38_response_get_best_seller_products.json

# 39 
${39_body_get_pay_advance_details}                           ${CURDIR}/../Body/${Testsite}/39_body_get_pay_advance_details.json
${39_1_body_get_pay_advance_details}                         ${CURDIR}/../Body/${Testsite}/TestCaseCondition/39_1_body_get_pay_advance_details.json
${39_2_body_get_pay_advance_details}                         ${CURDIR}/../Body/${Testsite}/TestCaseCondition/39_2_body_get_pay_advance_details.json
${39_3_body_get_pay_advance_details}                         ${CURDIR}/../Body/${Testsite}/TestCaseCondition/39_3_body_get_pay_advance_details.json

${39_response_get_pay_advance_details}                       ${CURDIR}/../Response/Schema/39_response_get_pay_advance_details.json
${39_1_response_get_pay_advance_details}                     ${CURDIR}/../Response/${Testsite}_ExpectResult/39_1_response_get_pay_advance_details.json
${39_2_response_get_pay_advance_details}                     ${CURDIR}/../Response/${Testsite}_ExpectResult/39_2_response_get_pay_advance_details.json
${39_3_response_get_pay_advance_details}                     ${CURDIR}/../Response/${Testsite}_ExpectResult/39_3_response_get_pay_advance_details.json

# 40 
${40_body_get_payments}                                      ${CURDIR}/../Body/${Testsite}/40_body_get_payments.json                                    
${40_1_2_body_get_payments}                                  ${CURDIR}/../Body/${Testsite}/TestCaseCondition/40_1_2_body_get_payments.json
${40_2_body_get_payments}                                    ${CURDIR}/../Body/${Testsite}/TestCaseCondition/40_2_body_get_payments.json
${40_3_1_body_get_payments}                                  ${CURDIR}/../Body/${Testsite}/TestCaseCondition/40_3_1_body_get_payments.json
${40_3_2_body_get_payments}                                  ${CURDIR}/../Body/${Testsite}/TestCaseCondition/40_3_2_body_get_payments.json
${40_4_1_body_get_payments}                                  ${CURDIR}/../Body/${Testsite}/TestCaseCondition/40_4_1_body_get_payments.json
${40_4_2_body_get_payments}                                  ${CURDIR}/../Body/${Testsite}/TestCaseCondition/40_4_2_body_get_payments.json
${40_4_3_body_get_payments}                                  ${CURDIR}/../Body/${Testsite}/TestCaseCondition/40_4_3_body_get_payments.json
${40_5_1_body_get_payments}                                  ${CURDIR}/../Body/${Testsite}/TestCaseCondition/40_5_1_body_get_payments.json
${40_5_2_body_get_payments}                                  ${CURDIR}/../Body/${Testsite}/TestCaseCondition/40_5_2_body_get_payments.json
${40_6_1_body_get_payments}                                  ${CURDIR}/../Body/${Testsite}/TestCaseCondition/40_6_1_body_get_payments.json
${40_6_2_body_get_payments}                                  ${CURDIR}/../Body/${Testsite}/TestCaseCondition/40_6_2_body_get_payments.json
${40_7_1_body_get_payments}                                  ${CURDIR}/../Body/${Testsite}/TestCaseCondition/40_7_1_body_get_payments.json
${40_7_2_body_get_payments}                                  ${CURDIR}/../Body/${Testsite}/TestCaseCondition/40_7_2_body_get_payments.json

${40_response_get_payments}                                  ${CURDIR}/../Response/Schema/40_response_get_payments.json

# 41 
${41_body_get_ais_points}                                    ${CURDIR}/../Body/${Testsite}/41_body_get_ais_points.json
${41_1_body_get_ais_points}                                  ${CURDIR}/../Body/${Testsite}/TestCaseCondition/41_1_body_get_ais_points.json 
${41_2_body_get_ais_points}                                  ${CURDIR}/../Body/${Testsite}/TestCaseCondition/41_2_body_get_ais_points.json 

${41_response_get_ais_points}                                ${CURDIR}/../Response/Schema/41_response_get_ais_points.json

# 42 
${42_body_search_products_by_criteria}                       ${CURDIR}/../Body/${Testsite}/42_body_search_products_by_criteria.json
${42_1_body_search_products_by_criteria}                     ${CURDIR}/../Body/${Testsite}/TestCaseCondition/42_1_body_search_products_by_criteria.json 
${42_2_body_search_products_by_criteria}                     ${CURDIR}/../Body/${Testsite}/TestCaseCondition/42_2_body_search_products_by_criteria.json 
${42_3_1_body_search_products_by_criteria}                   ${CURDIR}/../Body/${Testsite}/TestCaseCondition/42_3_1_body_search_products_by_criteria.json 
${42_3_2_body_search_products_by_criteria}                   ${CURDIR}/../Body/${Testsite}/TestCaseCondition/42_3_2_body_search_products_by_criteria.json 
${42_4_body_search_products_by_criteria}                     ${CURDIR}/../Body/${Testsite}/TestCaseCondition/42_4_body_search_products_by_criteria.json 
${42_5_body_search_products_by_criteria}                     ${CURDIR}/../Body/${Testsite}/TestCaseCondition/42_5_body_search_products_by_criteria.json 
${42_6_1_body_search_products_by_criteria}                   ${CURDIR}/../Body/${Testsite}/TestCaseCondition/42_6_1_body_search_products_by_criteria.json 
${42_6_2_body_search_products_by_criteria}                   ${CURDIR}/../Body/${Testsite}/TestCaseCondition/42_6_2_body_search_products_by_criteria.json 
${42_7_body_search_products_by_criteria}                     ${CURDIR}/../Body/${Testsite}/TestCaseCondition/42_7_body_search_products_by_criteria.json 

${42_response_search_products_by_criteria}                   ${CURDIR}/../Response/Schema/42_response_search_products_by_criterias.json

# 43 
${43_body_get_product_with_promotions_by_product}            ${CURDIR}/../Body/${Testsite}/43_body_get_product_with_promotions_by_product.json
${43_1_1_body_get_product_with_promotions_by_product}        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/43_1_1_body_get_product_with_promotions_by_product.json   
${43_1_2_body_get_product_with_promotions_by_product}        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/43_1_2_body_get_product_with_promotions_by_product.json 
${43_1_3_body_get_product_with_promotions_by_product}        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/43_1_3_body_get_product_with_promotions_by_product.json 
${43_1_4_body_get_product_with_promotions_by_product}        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/43_1_4_body_get_product_with_promotions_by_product.json 
${43_2_1_body_get_product_with_promotions_by_product}        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/43_2_1_body_get_product_with_promotions_by_product.json 
${43_2_2_body_get_product_with_promotions_by_product}        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/43_2_2_body_get_product_with_promotions_by_product.json 
${43_2_3_body_get_product_with_promotions_by_product}        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/43_2_3_body_get_product_with_promotions_by_product.json 
${43_3_1_body_get_product_with_promotions_by_product}        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/43_3_1_body_get_product_with_promotions_by_product.json 
${43_3_2_body_get_product_with_promotions_by_product}        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/43_3_2_body_get_product_with_promotions_by_product.json 
${43_4_1_body_get_product_with_promotions_by_product}        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/43_4_1_body_get_product_with_promotions_by_product.json 
${43_4_2_body_get_product_with_promotions_by_product}        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/43_4_2_body_get_product_with_promotions_by_product.json 
${43_5_1_body_get_product_with_promotions_by_product}        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/43_5_1_body_get_product_with_promotions_by_product.json 
${43_5_2_body_get_product_with_promotions_by_product}        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/43_5_2_body_get_product_with_promotions_by_product.json 
${43_6_1_body_get_product_with_promotions_by_product}        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/43_6_1_body_get_product_with_promotions_by_product.json 
${43_6_2_body_get_product_with_promotions_by_product}        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/43_6_2_body_get_product_with_promotions_by_product.json 
${43_7_1_body_get_product_with_promotions_by_product}        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/43_7_1_body_get_product_with_promotions_by_product.json 
${43_7_2_body_get_product_with_promotions_by_product}        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/43_7_2_body_get_product_with_promotions_by_product.json 
${43_8_1_body_get_product_with_promotions_by_product}        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/43_8_1_body_get_product_with_promotions_by_product.json 
${43_8_2_body_get_product_with_promotions_by_product}        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/43_8_2_body_get_product_with_promotions_by_product.json 

${43_response_get_product_with_promotions_by_product}        ${CURDIR}/../Response/Schema/43_response_get_product_with_promotions_by_products.json

# 44 
${44_body_get_trade_limit_quota_by_location}                 ${CURDIR}/../Body/${Testsite}/44_body_get_trade_limit_quota_by_location.json
${44_1_body_get_trade_limit_quota_by_location}               ${CURDIR}/../Body/${Testsite}/TestCaseCondition/44_1_body_get_trade_limit_quota_by_location.json
${44_2_body_get_trade_limit_quota_by_location}               ${CURDIR}/../Body/${Testsite}/TestCaseCondition/44_2_body_get_trade_limit_quota_by_location.json

${44_response_get_trade_limit_quota_by_location}             ${CURDIR}/../Response/Schema/44_response_get_trade_limit_quota_by_location.json

# 45 
${45_body_search_campaign_with_discount_by_text}             ${CURDIR}/../Body/${Testsite}/45_body_search_campaign_with_discount_by_text.json
${45_1_1_body_search_campaign_with_discount_by_text}         ${CURDIR}/../Body/${Testsite}/TestCaseCondition/45_1_1_body_search_campaign_with_discount_by_text.json 
${45_1_2_body_search_campaign_with_discount_by_text}         ${CURDIR}/../Body/${Testsite}/TestCaseCondition/45_1_2_body_search_campaign_with_discount_by_text.json 
${45_1_3_body_search_campaign_with_discount_by_text}         ${CURDIR}/../Body/${Testsite}/TestCaseCondition/45_1_3_body_search_campaign_with_discount_by_text.json 
${45_1_4_body_search_campaign_with_discount_by_text}         ${CURDIR}/../Body/${Testsite}/TestCaseCondition/45_1_4_body_search_campaign_with_discount_by_text.json 
${45_2_1_body_search_campaign_with_discount_by_text}         ${CURDIR}/../Body/${Testsite}/TestCaseCondition/45_2_1_body_search_campaign_with_discount_by_text.json 
${45_2_2_body_search_campaign_with_discount_by_text}         ${CURDIR}/../Body/${Testsite}/TestCaseCondition/45_2_2_body_search_campaign_with_discount_by_text.json 
${45_2_3_body_search_campaign_with_discount_by_text}         ${CURDIR}/../Body/${Testsite}/TestCaseCondition/45_2_3_body_search_campaign_with_discount_by_text.json 
${45_3_1_body_search_campaign_with_discount_by_text}         ${CURDIR}/../Body/${Testsite}/TestCaseCondition/45_3_1_body_search_campaign_with_discount_by_text.json 
${45_3_2_body_search_campaign_with_discount_by_text}         ${CURDIR}/../Body/${Testsite}/TestCaseCondition/45_3_2_body_search_campaign_with_discount_by_text.json 
${45_4_1_body_search_campaign_with_discount_by_text}         ${CURDIR}/../Body/${Testsite}/TestCaseCondition/45_4_1_body_search_campaign_with_discount_by_text.json 
${45_4_2_body_search_campaign_with_discount_by_text}         ${CURDIR}/../Body/${Testsite}/TestCaseCondition/45_4_2_body_search_campaign_with_discount_by_text.json 
${45_5_1_body_search_campaign_with_discount_by_text}         ${CURDIR}/../Body/${Testsite}/TestCaseCondition/45_5_1_body_search_campaign_with_discount_by_text.json 
${45_5_2_body_search_campaign_with_discount_by_text}         ${CURDIR}/../Body/${Testsite}/TestCaseCondition/45_5_2_body_search_campaign_with_discount_by_text.json 
${45_6_1_body_search_campaign_with_discount_by_text}         ${CURDIR}/../Body/${Testsite}/TestCaseCondition/45_6_1_body_search_campaign_with_discount_by_text.json 
${45_6_2_body_search_campaign_with_discount_by_text}         ${CURDIR}/../Body/${Testsite}/TestCaseCondition/45_6_2_body_search_campaign_with_discount_by_text.json 
${45_7_1_body_search_campaign_with_discount_by_text}         ${CURDIR}/../Body/${Testsite}/TestCaseCondition/45_7_1_body_search_campaign_with_discount_by_text.json 
${45_7_2_body_search_campaign_with_discount_by_text}         ${CURDIR}/../Body/${Testsite}/TestCaseCondition/45_7_2_body_search_campaign_with_discount_by_text.json 
${45_8_1_body_search_campaign_with_discount_by_text}         ${CURDIR}/../Body/${Testsite}/TestCaseCondition/45_8_1_body_search_campaign_with_discount_by_text.json 
${45_8_2_body_search_campaign_with_discount_by_text}         ${CURDIR}/../Body/${Testsite}/TestCaseCondition/45_8_2_body_search_campaign_with_discount_by_text.json 

${45_response_search_campaign_with_discount_by_text}         ${CURDIR}/../Response/Schema/45_response_search_campaign_with_discount_by_text.json

# 46 
${46_body_get_campaign_by_trade_discount}                    ${CURDIR}/../Body/${Testsite}/46_body_get_campaign_by_trade_discount.json
${46_1_body_get_campaign_by_trade_discount}                  ${CURDIR}/../Body/${Testsite}/TestCaseCondition/46_1_body_get_campaign_by_trade_discount.json 
${46_2_1_body_get_campaign_by_trade_discount}                ${CURDIR}/../Body/${Testsite}/TestCaseCondition/46_2_1_body_get_campaign_by_trade_discount.json 
${46_2_2_body_get_campaign_by_trade_discount}                ${CURDIR}/../Body/${Testsite}/TestCaseCondition/46_2_2_body_get_campaign_by_trade_discount.json 
${46_3_1_body_get_campaign_by_trade_discount}                ${CURDIR}/../Body/${Testsite}/TestCaseCondition/46_3_1_body_get_campaign_by_trade_discount.json 
${46_3_2_body_get_campaign_by_trade_discount}                ${CURDIR}/../Body/${Testsite}/TestCaseCondition/46_3_2_body_get_campaign_by_trade_discount.json 

${46_response_get_campaign_by_trade_discount}                ${CURDIR}/../Response/Schema/46_response_get_campaign_by_trade_discount.json
${46_1_response_get_campaign_by_trade_discount}              ${CURDIR}/../Response/${Testsite}_ExpectResult/46_1_response_get_campaign_by_trade_discount.json

# 47 
${47_body_get_campaigns}                                     ${CURDIR}/../Body/${Testsite}/47_body_get_campaigns.json  
${47_response_get_campaigns}                                 ${CURDIR}/../Response/Schema/47_response_get_campaigns.json

# 48 
${48_body_get_free_goods}                                    ${CURDIR}/../Body/${Testsite}/48_body_get_free_goods.json 
${48_1_body_get_free_goods}                                  ${CURDIR}/../Body/${Testsite}/TestCaseCondition/48_1_body_get_free_goods.json 
${48_2_body_get_free_goods}                                  ${CURDIR}/../Body/${Testsite}/TestCaseCondition/48_2_body_get_free_goods.json 
${48_3_body_get_free_goods}                                  ${CURDIR}/../Body/${Testsite}/TestCaseCondition/48_3_body_get_free_goods.json 

${48_response_get_free_goods}                                ${CURDIR}/../Response/Schema/48_response_get_free_goods.json

# 49 
${49_body_get_location}                                      ${CURDIR}/../Body/${Testsite}/49_body_get_location.json  
${49_1_body_get_location}                                    ${CURDIR}/../Body/${Testsite}/TestCaseCondition/49_1_body_get_location.json 
${49_2_body_get_location}                                    ${CURDIR}/../Body/${Testsite}/TestCaseCondition/49_2_body_get_location.json 

${49_response_get_location}                                  ${CURDIR}/../Response/Schema/49_response_get_location.json

# 50 
${50_body_get_product_price_options_by_material_code}        ${CURDIR}/../Body/${Testsite}/50_body_get_product_price_options_by_material_code.json  
${50_1_1_body_get_product_price_options_by_material_code}    ${CURDIR}/../Body/${Testsite}/TestCaseCondition/50_1_1_body_get_product_price_options_by_material_code.json
${50_1_2_body_get_product_price_options_by_material_code}    ${CURDIR}/../Body/${Testsite}/TestCaseCondition/50_1_2_body_get_product_price_options_by_material_code.json
${50_2_1_body_get_product_price_options_by_material_code}    ${CURDIR}/../Body/${Testsite}/TestCaseCondition/50_2_1_body_get_product_price_options_by_material_code.json
${50_2_2_body_get_product_price_options_by_material_code}    ${CURDIR}/../Body/${Testsite}/TestCaseCondition/50_2_2_body_get_product_price_options_by_material_code.json
${50_3_1_body_get_product_price_options_by_material_code}    ${CURDIR}/../Body/${Testsite}/TestCaseCondition/50_3_1_body_get_product_price_options_by_material_code.json
${50_3_2_body_get_product_price_options_by_material_code}    ${CURDIR}/../Body/${Testsite}/TestCaseCondition/50_3_2_body_get_product_price_options_by_material_code.json
${50_4_1_body_get_product_price_options_by_material_code}    ${CURDIR}/../Body/${Testsite}/TestCaseCondition/50_4_1_body_get_product_price_options_by_material_code.json
${50_4_2_body_get_product_price_options_by_material_code}    ${CURDIR}/../Body/${Testsite}/TestCaseCondition/50_4_2_body_get_product_price_options_by_material_code.json

${50_response_get_product_price_options_by_material_code}    ${CURDIR}/../Response/Schema/50_response_get_product_price_options_by_material_code.json

# 51 
${51_body_get_product_detail}                                ${CURDIR}/../Body/${Testsite}/51_body_get_product_detail.json
${51_1_body_get_product_detail}                              ${CURDIR}/../Body/${Testsite}/TestCaseCondition/51_1_body_get_product_detail.json
${51_2_1_body_get_product_detail}                            ${CURDIR}/../Body/${Testsite}/TestCaseCondition/51_2_1_body_get_product_detail.json
${51_2_2_body_get_product_detail}                            ${CURDIR}/../Body/${Testsite}/TestCaseCondition/51_2_2_body_get_product_detail.json
${51_3_1_body_get_product_detail}                            ${CURDIR}/../Body/${Testsite}/TestCaseCondition/51_3_1_body_get_product_detail.json
${51_3_2_body_get_product_detail}                            ${CURDIR}/../Body/${Testsite}/TestCaseCondition/51_3_2_body_get_product_detail.json
${51_3_3_body_get_product_detail}                            ${CURDIR}/../Body/${Testsite}/TestCaseCondition/51_3_3_body_get_product_detail.json

${51_response_get_product_detail}                            ${CURDIR}/../Response/Schema/51_response_get_product_detail.json
${51_3_1_response_get_product_detail}                        ${CURDIR}/../Response/${Testsite}_ExpectResult/51_3_1_response_get_product_detail.json

# 52 
${52_body_get_product_detail_by_criteria}                    ${CURDIR}/../Body/${Testsite}/52_body_get_product_detail_by_criteria.json
${52_1_body_get_product_detail_by_criteria}                  ${CURDIR}/../Body/${Testsite}/TestCaseCondition/52_1_body_get_product_detail_by_criteria.json
${52_2_1_body_get_product_detail_by_criteria}                ${CURDIR}/../Body/${Testsite}/TestCaseCondition/52_2_1_body_get_product_detail_by_criteria.json
${52_2_2_body_get_product_detail_by_criteria}                ${CURDIR}/../Body/${Testsite}/TestCaseCondition/52_2_2_body_get_product_detail_by_criteria.json

${52_response_get_product_detail_by_criteria}                ${CURDIR}/../Response/Schema/52_response_get_product_detail_by_criteria.json

# 53 
${53_body_get_product_price_options}                         ${CURDIR}/../Body/${Testsite}/53_body_get_product_price_options.json
${53_1_1_body_get_product_price_options}                     ${CURDIR}/../Body/${Testsite}/TestCaseCondition/53_1_1_body_get_product_price_options.json
${53_1_2_body_get_product_price_options}                     ${CURDIR}/../Body/${Testsite}/TestCaseCondition/53_1_2_body_get_product_price_options.json
${53_2_1_body_get_product_price_options}                     ${CURDIR}/../Body/${Testsite}/TestCaseCondition/53_2_1_body_get_product_price_options.json
${53_2_2_body_get_product_price_options}                     ${CURDIR}/../Body/${Testsite}/TestCaseCondition/53_2_2_body_get_product_price_options.json
${53_2_3_body_get_product_price_options}                     ${CURDIR}/../Body/${Testsite}/TestCaseCondition/53_2_3_body_get_product_price_options.json

${53_response_get_product_price_options}                     ${CURDIR}/../Response/Schema/53_response_get_product_price_options.json

# 54 
${54_body_get_products_by_material_code}                     ${CURDIR}/../Body/${Testsite}/54_body_get_products_by_material_code.json
${54_1_body_get_products_by_material_code}                   ${CURDIR}/../Body/${Testsite}/TestCaseCondition/54_1_body_get_products_by_material_code.json
${54_2_1_body_get_products_by_material_code}                 ${CURDIR}/../Body/${Testsite}/TestCaseCondition/54_2_1_body_get_products_by_material_code.json
${54_2_2_body_get_products_by_material_code}                 ${CURDIR}/../Body/${Testsite}/TestCaseCondition/54_2_2_body_get_products_by_material_code.json
${54_2_3_body_get_products_by_material_code}                 ${CURDIR}/../Body/${Testsite}/TestCaseCondition/54_2_3_body_get_products_by_material_code.json
${54_3_1_body_get_products_by_material_code}                 ${CURDIR}/../Body/${Testsite}/TestCaseCondition/54_3_1_body_get_products_by_material_code.json
${54_3_2_body_get_products_by_material_code}                 ${CURDIR}/../Body/${Testsite}/TestCaseCondition/54_3_2_body_get_products_by_material_code.json

${54_response_get_products_by_material_code}                 ${CURDIR}/../Response/Schema/54_response_get_products_by_material_code.json

# 55 
${55_body_get_all_product_search}                            ${CURDIR}/../Body/${Testsite}/55_body_get_all_product_search.json
${55_1_body_get_all_product_search}                          ${CURDIR}/../Body/${Testsite}/TestCaseCondition/55_1_body_get_all_product_search.json
${55_2_1_body_get_all_product_search}                        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/55_2_1_body_get_all_product_search.json
${55_2_2_body_get_all_product_search}                        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/55_2_2_body_get_all_product_search.json
${55_3_1_body_get_all_product_search}                        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/55_3_1_body_get_all_product_search.json
${55_3_3_body_get_all_product_search}                        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/55_3_2_body_get_all_product_search.json

${55_response_get_all_product_search}                        ${CURDIR}/../Response/Schema/55_response_get_all_product_search.json

# 56 
${56_body_get_all_products_for_searching}                    ${CURDIR}/../Body/${Testsite}/56_body_get_all_products_for_searching.json
${56_1_body_get_all_products_for_searching}                  ${CURDIR}/../Body/${Testsite}/TestCaseCondition/56_1_body_get_all_products_for_searching.json
${56_2_1_body_get_all_products_for_searching}                ${CURDIR}/../Body/${Testsite}/TestCaseCondition/56_2_1_body_get_all_products_for_searching.json
${56_2_2_body_get_all_products_for_searching}                ${CURDIR}/../Body/${Testsite}/TestCaseCondition/56_2_2_body_get_all_products_for_searching.json
${56_3_1_body_get_all_products_for_searching}                ${CURDIR}/../Body/${Testsite}/TestCaseCondition/56_3_1_body_get_all_products_for_searching.json
${56_3_2_body_get_all_products_for_searching}                ${CURDIR}/../Body/${Testsite}/TestCaseCondition/56_3_2_body_get_all_products_for_searching.json

${56_response_get_all_products_for_searching}                ${CURDIR}/../Response/Schema/56_response_get_all_products_for_searching.json

# 57 
${57_body_get_all_products_by_price}                         ${CURDIR}/../Body/${Testsite}/57_body_get_all_products_by_price.json
${57_1_body_get_all_products_by_price}                       ${CURDIR}/../Body/${Testsite}/TestCaseCondition/57_1_body_get_all_products_by_price.json
${57_2_1_body_get_all_products_by_price}                     ${CURDIR}/../Body/${Testsite}/TestCaseCondition/57_2_1_body_get_all_products_by_price.json
${57_2_2_body_get_all_products_by_price}                     ${CURDIR}/../Body/${Testsite}/TestCaseCondition/57_2_2_body_get_all_products_by_price.json
${57_3_1_body_get_all_products_by_price}                     ${CURDIR}/../Body/${Testsite}/TestCaseCondition/57_3_1_body_get_all_products_by_price.json
${57_3_2_body_get_all_products_by_price}                     ${CURDIR}/../Body/${Testsite}/TestCaseCondition/57_3_2_body_get_all_products_by_price.json

${57_response_get_all_products_by_price}                     ${CURDIR}/../Response/Schema/57_response_get_all_products_by_price.json

# 58 
${58_body_get_all_products_by_campaign}                      ${CURDIR}/../Body/${Testsite}/58_body_get_all_products_by_campaign.json
${58_1_1_body_get_all_products_by_campaign}                  ${CURDIR}/../Body/${Testsite}/TestCaseCondition/58_1_1_body_get_all_products_by_campaign.json
${58_1_2_body_get_all_products_by_campaign}                  ${CURDIR}/../Body/${Testsite}/TestCaseCondition/58_1_2_body_get_all_products_by_campaign.json
${58_2_1_body_get_all_products_by_campaign}                  ${CURDIR}/../Body/${Testsite}/TestCaseCondition/58_2_1_body_get_all_products_by_campaign.json
${58_2_2_body_get_all_products_by_campaign}                  ${CURDIR}/../Body/${Testsite}/TestCaseCondition/58_2_2_body_get_all_products_by_campaign.json

${58_response_get_all_products_by_campaign}                  ${CURDIR}/../Response/Schema/58_response_get_all_products_by_campaign.json

# 59 
${59_body_custom_search_all_product}                         ${CURDIR}/../Body/${Testsite}/59_body_custom_search_all_product.json
${59_1_body_custom_search_all_product}                       ${CURDIR}/../Body/${Testsite}/TestCaseCondition/59_1_body_custom_search_all_product.json
${59_2_1_body_custom_search_all_product}                     ${CURDIR}/../Body/${Testsite}/TestCaseCondition/59_2_1_body_custom_search_all_product.json
${59_2_2_body_custom_search_all_product}                     ${CURDIR}/../Body/${Testsite}/TestCaseCondition/59_2_2_body_custom_search_all_product.json
${59_3_body_custom_search_all_product}                       ${CURDIR}/../Body/${Testsite}/TestCaseCondition/59_3_body_custom_search_all_product.json
${59_4_body_custom_search_all_product}                       ${CURDIR}/../Body/${Testsite}/TestCaseCondition/59_4_body_custom_search_all_product.json
${59_5_body_custom_search_all_product}                       ${CURDIR}/../Body/${Testsite}/TestCaseCondition/59_5_body_custom_search_all_product.json
${59_6_body_custom_search_all_product}                       ${CURDIR}/../Body/${Testsite}/TestCaseCondition/59_6_body_custom_search_all_product.json
${59_7_body_custom_search_all_product}                       ${CURDIR}/../Body/${Testsite}/TestCaseCondition/59_7_body_custom_search_all_product.json
${59_8_body_custom_search_all_product}                       ${CURDIR}/../Body/${Testsite}/TestCaseCondition/59_8_body_custom_search_all_product.json

${59_response_custom_search_all_product}                     ${CURDIR}/../Response/Schema/59_response_custom_search_all_product.json

# 60 
${60_body_search_product_with_promotions_by_text}            ${CURDIR}/../Body/${Testsite}/60_body_search_product_with_promotions_by_text.json
${60_1_1_body_search_product_with_promotions_by_text}        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/60_1_1_body_search_product_with_promotions_by_text.json
${60_1_2_body_search_product_with_promotions_by_text}        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/60_1_2_body_search_product_with_promotions_by_text.json
${60_1_3_body_search_product_with_promotions_by_text}        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/60_1_3_body_search_product_with_promotions_by_text.json
${60_1_4_body_search_product_with_promotions_by_text}        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/60_1_4_body_search_product_with_promotions_by_text.json
${60_2_1_body_search_product_with_promotions_by_text}        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/60_2_1_body_search_product_with_promotions_by_text.json
${60_2_2_body_search_product_with_promotions_by_text}        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/60_2_2_body_search_product_with_promotions_by_text.json
${60_2_3_body_search_product_with_promotions_by_text}        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/60_2_3_body_search_product_with_promotions_by_text.json
${60_3_1_body_search_product_with_promotions_by_text}        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/60_3_1_body_search_product_with_promotions_by_text.json
${60_3_2_body_search_product_with_promotions_by_text}        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/60_3_2_body_search_product_with_promotions_by_text.json
${60_4_1_body_search_product_with_promotions_by_text}        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/60_4_1_body_search_product_with_promotions_by_text.json
${60_4_2_body_search_product_with_promotions_by_text}        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/60_4_2_body_search_product_with_promotions_by_text.json
${60_5_1_body_search_product_with_promotions_by_text}        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/60_5_1_body_search_product_with_promotions_by_text.json
${60_5_2_body_search_product_with_promotions_by_text}        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/60_5_2_body_search_product_with_promotions_by_text.json
${60_6_1_body_search_product_with_promotions_by_text}        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/60_6_1_body_search_product_with_promotions_by_text.json
${60_6_2_body_search_product_with_promotions_by_text}        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/60_6_2_body_search_product_with_promotions_by_text.json
${60_7_1_body_search_product_with_promotions_by_text}        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/60_7_1_body_search_product_with_promotions_by_text.json
${60_7_2_body_search_product_with_promotions_by_text}        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/60_7_2_body_search_product_with_promotions_by_text.json
${60_8_1_body_search_product_with_promotions_by_text}        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/60_8_1_body_search_product_with_promotions_by_text.json
${60_8_2_body_search_product_with_promotions_by_text}        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/60_8_2_body_search_product_with_promotions_by_text.json
${60_9_1_body_search_product_with_promotions_by_text}        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/60_9_1_body_search_product_with_promotions_by_text.json
${60_9_2_body_search_product_with_promotions_by_text}        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/60_9_2_body_search_product_with_promotions_by_text.json

${60_response_search_product_with_promotions_by_text}        ${CURDIR}/../Response/Schema/60_response_search_product_with_promotions_by_text.json

# 61 
${61_body_get_trade_criteria_by_product}                     ${CURDIR}/../Body/${Testsite}/61_body_get_trade_criteria_by_product.json
${61_1_1_body_get_trade_criteria_by_product}                 ${CURDIR}/../Body/${Testsite}/TestCaseCondition/61_1_1_body_get_trade_criteria_by_product.json
${61_1_2_body_get_trade_criteria_by_product}                 ${CURDIR}/../Body/${Testsite}/TestCaseCondition/61_1_2_body_get_trade_criteria_by_product.json
${61_2_1_body_get_trade_criteria_by_product}                 ${CURDIR}/../Body/${Testsite}/TestCaseCondition/61_2_1_body_get_trade_criteria_by_product.json
${61_2_2_body_get_trade_criteria_by_product}                 ${CURDIR}/../Body/${Testsite}/TestCaseCondition/61_2_2_body_get_trade_criteria_by_product.json
${61_3_1_body_get_trade_criteria_by_product}                 ${CURDIR}/../Body/${Testsite}/TestCaseCondition/61_3_1_body_get_trade_criteria_by_product.json
${61_3_2_body_get_trade_criteria_by_product}                 ${CURDIR}/../Body/${Testsite}/TestCaseCondition/61_3_2_body_get_trade_criteria_by_product.json

${61_response_get_trade_criteria_by_product}                 ${CURDIR}/../Response/Schema/61_response_get_trade_criteria_by_product.json

# 62 
${62_body_get_trade_sale_channel}                            ${CURDIR}/../Body/${Testsite}/62_body_get_trade_sale_channel.json
${62_1_body_get_trade_sale_channel}                          ${CURDIR}/../Body/${Testsite}/TestCaseCondition/62_1_body_get_trade_sale_channel.json 
${62_2_body_get_trade_sale_channel}                          ${CURDIR}/../Body/${Testsite}/TestCaseCondition/62_2_body_get_trade_sale_channel.json 

${62_response_get_trade_sale_channel}                        ${CURDIR}/../Response/Schema/62_response_get_trade_sale_channel.json

# 63 
${63_response_get_all_product_search}                        ${CURDIR}/../Response/Schema/63_response_get_all_product_search.json

# 64 
${64_body_get_product_specification}                         ${CURDIR}/../Body/${Testsite}/64_body_get_product_specification.json
${64_1_body_get_product_specification}                       ${CURDIR}/../Body/${Testsite}/TestCaseCondition/64_1_body_get_product_specification.json 
${64_2_body_get_product_specification}                       ${CURDIR}/../Body/${Testsite}/TestCaseCondition/64_2_body_get_product_specification.json 

${64_response_get_product_specification}                     ${CURDIR}/../Response/Schema/64_response_get_product_specification.json

# 65 
${65_body_get_related_products}                              ${CURDIR}/../Body/${Testsite}/65_body_get_related_products.json
${65_response_get_related_products}                          ${CURDIR}/../Response/Schema/65_response_get_related_products.json

# 66 
${66_body_get_trade_prebooking}                              ${CURDIR}/../Body/${Testsite}/66_body_get_trade_prebooking.json
${66_1_1_body_get_trade_prebooking}                          ${CURDIR}/../Body/${Testsite}/TestCaseCondition/66_1_1_body_get_trade_prebooking.json 
${66_1_2_body_get_trade_prebooking}                          ${CURDIR}/../Body/${Testsite}/TestCaseCondition/66_1_2_body_get_trade_prebooking.json 
${66_2_1_body_get_trade_prebooking}                          ${CURDIR}/../Body/${Testsite}/TestCaseCondition/66_2_1_body_get_trade_prebooking.json 
${66_2_2_body_get_trade_prebooking}                          ${CURDIR}/../Body/${Testsite}/TestCaseCondition/66_2_2_body_get_trade_prebooking.json 

${66_response_get_trade_prebooking}                          ${CURDIR}/../Response/Schema/66_response_get_trade_prebooking.json

# 67 
${67_body_get_campaign_promotions}                           ${CURDIR}/../Body/${Testsite}/67_body_get_campaign_promotions.json
${67_1_body_get_campaign_promotions}                         ${CURDIR}/../Body/${Testsite}/TestCaseCondition/67_1_body_get_campaign_promotions.json 
${67_2_body_get_campaign_promotions}                         ${CURDIR}/../Body/${Testsite}/TestCaseCondition/67_2_body_get_campaign_promotions.json 
${67_3_body_get_campaign_promotions}                         ${CURDIR}/../Body/${Testsite}/TestCaseCondition/67_3_body_get_campaign_promotions.json 
${67_4_1_body_get_campaign_promotions}                       ${CURDIR}/../Body/${Testsite}/TestCaseCondition/67_4_1_body_get_campaign_promotions.json 
${67_4_2_body_get_campaign_promotions}                       ${CURDIR}/../Body/${Testsite}/TestCaseCondition/67_4_2_body_get_campaign_promotions.json 
${67_4_3_body_get_campaign_promotions}                       ${CURDIR}/../Body/${Testsite}/TestCaseCondition/67_4_3_body_get_campaign_promotions.json 
${67_5_1_body_get_campaign_promotions}                       ${CURDIR}/../Body/${Testsite}/TestCaseCondition/67_5_1_body_get_campaign_promotions.json 
${67_5_2_body_get_campaign_promotions}                       ${CURDIR}/../Body/${Testsite}/TestCaseCondition/67_5_2_body_get_campaign_promotions.json 
${67_5_3_body_get_campaign_promotions}                       ${CURDIR}/../Body/${Testsite}/TestCaseCondition/67_5_3_body_get_campaign_promotions.json 
${67_6_1_body_get_campaign_promotions}                       ${CURDIR}/../Body/${Testsite}/TestCaseCondition/67_6_1_body_get_campaign_promotions.json 
${67_6_2_body_get_campaign_promotions}                       ${CURDIR}/../Body/${Testsite}/TestCaseCondition/67_6_2_body_get_campaign_promotions.json 

${67_response_get_campaign_promotions}                       ${CURDIR}/../Response/Schema/67_response_get_campaign_promotions.json
${67_1_response_get_campaign_promotions}                     ${CURDIR}/../Response/${Testsite}_ExpectResult/67_1_response_get_campaign_promotions.json
${67_2_response_get_campaign_promotions}                     ${CURDIR}/../Response/${Testsite}_ExpectResult/67_2_response_get_campaign_promotions.json
${67_3_response_get_campaign_promotions}                     ${CURDIR}/../Response/${Testsite}_ExpectResult/67_3_response_get_campaign_promotions.json

# 68 
${68_body_get_trade_promotions_by_campaign}                  ${CURDIR}/../Body/${Testsite}/68_body_get_trade_promotions_by_campaign.json
${68_1_body_get_trade_promotions_by_campaign}                ${CURDIR}/../Body/${Testsite}/TestCaseCondition/68_1_body_get_trade_promotions_by_campaign.json 
${68_2_body_get_trade_promotions_by_campaign}                ${CURDIR}/../Body/${Testsite}/TestCaseCondition/68_2_body_get_trade_promotions_by_campaign.json 
${68_3_body_get_trade_promotions_by_campaign}                ${CURDIR}/../Body/${Testsite}/TestCaseCondition/68_3_body_get_trade_promotions_by_campaign.json 
${68_4_1_body_get_trade_promotions_by_campaign}              ${CURDIR}/../Body/${Testsite}/TestCaseCondition/68_4_1_body_get_trade_promotions_by_campaign.json 
${68_4_2_body_get_trade_promotions_by_campaign}              ${CURDIR}/../Body/${Testsite}/TestCaseCondition/68_4_2_body_get_trade_promotions_by_campaign.json 
${68_4_3_body_get_trade_promotions_by_campaign}              ${CURDIR}/../Body/${Testsite}/TestCaseCondition/68_4_3_body_get_trade_promotions_by_campaign.json 
${68_5_1_body_get_trade_promotions_by_campaign}              ${CURDIR}/../Body/${Testsite}/TestCaseCondition/68_5_1_body_get_trade_promotions_by_campaign.json 
${68_5_2_body_get_trade_promotions_by_campaign}              ${CURDIR}/../Body/${Testsite}/TestCaseCondition/68_5_2_body_get_trade_promotions_by_campaign.json 
${68_5_3_body_get_trade_promotions_by_campaign}              ${CURDIR}/../Body/${Testsite}/TestCaseCondition/68_5_3_body_get_trade_promotions_by_campaign.json 
${68_6_1_body_get_trade_promotions_by_campaign}              ${CURDIR}/../Body/${Testsite}/TestCaseCondition/68_6_1_body_get_trade_promotions_by_campaign.json 
${68_6_2_body_get_trade_promotions_by_campaign}              ${CURDIR}/../Body/${Testsite}/TestCaseCondition/68_6_2_body_get_trade_promotions_by_campaign.json 

${68_response_get_trade_promotions_by_campaign}              ${CURDIR}/../Response/Schema/68_response_get_trade_promotions_by_campaign.json
${68_1_response_get_trade_promotions_by_campaign}            ${CURDIR}/../Response/${Testsite}_ExpectResult/68_1_response_get_trade_promotions_by_campaign.json
${68_2_response_get_trade_promotions_by_campaign}            ${CURDIR}/../Response/${Testsite}_ExpectResult/68_2_response_get_trade_promotions_by_campaign.json
${68_3_response_get_trade_promotions_by_campaign}            ${CURDIR}/../Response/${Testsite}_ExpectResult/68_3_response_get_trade_promotions_by_campaign.json

# 69 
${69_body_get_payments_by_campaign}                          ${CURDIR}/../Body/${Testsite}/69_body_get_payments_by_campaign.json
${69_1_body_get_payments_by_campaign}                        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/69_1_body_get_payments_by_campaign.json
${69_2_body_get_payments_by_campaign}                        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/69_2_body_get_payments_by_campaign.json
${69_3_body_get_payments_by_campaign}                        ${CURDIR}/../Body/${Testsite}/TestCaseCondition/69_3_body_get_payments_by_campaign.json
${69_4_1_body_get_payments_by_campaign}                      ${CURDIR}/../Body/${Testsite}/TestCaseCondition/69_4_1_body_get_payments_by_campaign.json
${69_4_2_body_get_payments_by_campaign}                      ${CURDIR}/../Body/${Testsite}/TestCaseCondition/69_4_2_body_get_payments_by_campaign.json
${69_4_3_body_get_payments_by_campaign}                      ${CURDIR}/../Body/${Testsite}/TestCaseCondition/69_4_3_body_get_payments_by_campaign.json

${69_response_get_payments_by_campaign}                      ${CURDIR}/../Response/Schema/69_response_get_payments_by_campaign.json
${69_1_response_get_payments_by_campaign}                    ${CURDIR}/../Response/${Testsite}_ExpectResult/69_1_response_get_payments_by_campaign.json
${69_2_response_get_payments_by_campaign}                    ${CURDIR}/../Response/${Testsite}_ExpectResult/69_2_response_get_payments_by_campaign.json
${69_3_response_get_payments_by_campaign}                    ${CURDIR}/../Response/${Testsite}_ExpectResult/69_3_response_get_payments_by_campaign.json

# 70
${70_body_get_fbb_matchings}                                 ${CURDIR}/../Body/${Testsite}/70_body_get_fbb_matchings.json
${70_1_body_get_fbb_matchings}                               ${CURDIR}/../Body/${Testsite}/TestCaseCondition/70_1_body_get_fbb_matchings.json
${70_2_body_get_fbb_matchings}                               ${CURDIR}/../Body/${Testsite}/TestCaseCondition/70_2_body_get_fbb_matchings.json
${70_3_body_get_fbb_matchings}                               ${CURDIR}/../Body/${Testsite}/TestCaseCondition/70_3_body_get_fbb_matchings.json
${70_4_body_get_fbb_matchings}                               ${CURDIR}/../Body/${Testsite}/TestCaseCondition/70_4_body_get_fbb_matchings.json
${70_5_body_get_fbb_matchings}                               ${CURDIR}/../Body/${Testsite}/TestCaseCondition/70_5_body_get_fbb_matchings.json

${70_response_get_fbb_matchings}                             ${CURDIR}/../Response/Schema/70_response_get_fbb_matchings.json
${70_1_response_get_fbb_matchings}                           ${CURDIR}/../Response/${Testsite}_ExpectResult/70_1_response_get_fbb_matchings.json
${70_2_response_get_fbb_matchings}                           ${CURDIR}/../Response/${Testsite}_ExpectResult/70_2_response_get_fbb_matchings.json
${70_3_response_get_fbb_matchings}                           ${CURDIR}/../Response/${Testsite}_ExpectResult/70_3_response_get_fbb_matchings.json

# 71
${71_body_get_ais_fibre}                                     ${CURDIR}/../Body/${Testsite}/71_body_get_ais_fibre.json
${71_1_body_get_ais_fibre}                                   ${CURDIR}/../Body/${Testsite}/TestCaseCondition/71_1_body_get_ais_fibre.json
${71_2_body_get_ais_fibre}                                   ${CURDIR}/../Body/${Testsite}/TestCaseCondition/71_2_body_get_ais_fibre.json
${71_3_body_get_ais_fibre}                                   ${CURDIR}/../Body/${Testsite}/TestCaseCondition/71_3_body_get_ais_fibre.json
${71_4_body_get_ais_fibre}                                   ${CURDIR}/../Body/${Testsite}/TestCaseCondition/71_4_body_get_ais_fibre.json
${71_5_body_get_ais_fibre}                                   ${CURDIR}/../Body/${Testsite}/TestCaseCondition/71_5_body_get_ais_fibre.json

${71_response_get_ais_fibre}                                 ${CURDIR}/../Response/Schema/71_response_get_ais_fibre.json
${71_1_response_get_ais_fibre}                               ${CURDIR}/../Response/${Testsite}_ExpectResult/71_1_response_get_ais_fibre.json
${71_2_response_get_ais_fibre}                               ${CURDIR}/../Response/${Testsite}_ExpectResult/71_2_response_get_ais_fibre.json
${71_3_response_get_ais_fibre}                               ${CURDIR}/../Response/${Testsite}_ExpectResult/71_3_response_get_ais_fibre.json

# 72
${72_body_get_fbb_change_detail}                             ${CURDIR}/../Body/${Testsite}/72_body_get_fbb_change_detail.json
${72_1_body_get_fbb_change_detail}                           ${CURDIR}/../Body/${Testsite}/TestCaseCondition/72_1_body_get_fbb_change_detail.json
${72_2_body_get_fbb_change_detail}                           ${CURDIR}/../Body/${Testsite}/TestCaseCondition/72_2_body_get_fbb_change_detail.json
${72_3_body_get_fbb_change_detail}                           ${CURDIR}/../Body/${Testsite}/TestCaseCondition/72_3_body_get_fbb_change_detail.json
${72_4_body_get_fbb_change_detail}                           ${CURDIR}/../Body/${Testsite}/TestCaseCondition/72_4_body_get_fbb_change_detail.json
${72_5_body_get_fbb_change_detail}                           ${CURDIR}/../Body/${Testsite}/TestCaseCondition/72_5_body_get_fbb_change_detail.json

${72_response_get_fbb_change_detail}                         ${CURDIR}/../Response/Schema/72_response_get_fbb_change_detail.json
${72_1_response_get_fbb_change_detail}                       ${CURDIR}/../Response/${Testsite}_ExpectResult/72_1_response_get_fbb_change_detail.json
${72_2_response_get_fbb_change_detail}                       ${CURDIR}/../Response/${Testsite}_ExpectResult/72_2_response_get_fbb_change_detail.json
${72_3_response_get_fbb_change_detail}                       ${CURDIR}/../Response/${Testsite}_ExpectResult/72_3_response_get_fbb_change_detail.json

# 73 
${73_body_get_payments_v2}                                   ${CURDIR}/../Body/${Testsite}/73_body_get_payments_v2.json                                    
${73_1_body_get_payments_v2}                               ${CURDIR}/../Body/${Testsite}/TestCaseCondition/73_1_body_get_payments_v2.json
${73_2_body_get_payments_v2}                                 ${CURDIR}/../Body/${Testsite}/TestCaseCondition/73_2_body_get_payments_v2.json
${73_3_1_body_get_payments_v2}                               ${CURDIR}/../Body/${Testsite}/TestCaseCondition/73_3_1_body_get_payments_v2.json
${73_3_2_body_get_payments_v2}                               ${CURDIR}/../Body/${Testsite}/TestCaseCondition/73_3_2_body_get_payments_v2.json
${73_4_1_body_get_payments_v2}                               ${CURDIR}/../Body/${Testsite}/TestCaseCondition/73_4_1_body_get_payments_v2.json
${73_4_2_body_get_payments_v2}                               ${CURDIR}/../Body/${Testsite}/TestCaseCondition/73_4_2_body_get_payments_v2.json
${73_4_3_body_get_payments_v2}                               ${CURDIR}/../Body/${Testsite}/TestCaseCondition/73_4_3_body_get_payments_v2.json
${73_5_1_body_get_payments_v2}                               ${CURDIR}/../Body/${Testsite}/TestCaseCondition/73_5_1_body_get_payments_v2.json
${73_5_2_body_get_payments_v2}                               ${CURDIR}/../Body/${Testsite}/TestCaseCondition/73_5_2_body_get_payments_v2.json
${73_6_1_body_get_payments_v2}                               ${CURDIR}/../Body/${Testsite}/TestCaseCondition/73_6_1_body_get_payments_v2.json
${73_6_2_body_get_payments_v2}                               ${CURDIR}/../Body/${Testsite}/TestCaseCondition/73_6_2_body_get_payments_v2.json

${73_response_get_payments_v2}                               ${CURDIR}/../Response/Schema/73_response_get_payments_v2.json

# 74
${74_body_get_policies}                                      ${CURDIR}/../Body/${Testsite}/74_body_get_policies.json 
${74_1_body_get_policies}                                    ${CURDIR}/../Body/${Testsite}/TestCaseCondition/74_1_body_get_policies.json
${74_2_body_get_policies}                                    ${CURDIR}/../Body/${Testsite}/TestCaseCondition/74_2_body_get_policies.json
${74_3_body_get_policies}                                    ${CURDIR}/../Body/${Testsite}/TestCaseCondition/74_3_body_get_policies.json
${74_4_1_body_get_policies}                                  ${CURDIR}/../Body/${Testsite}/TestCaseCondition/74_4_1_body_get_policies.json
${74_4_2_body_get_policies}                                  ${CURDIR}/../Body/${Testsite}/TestCaseCondition/74_4_2_body_get_policies.json

${74_response_get_policies}                                  ${CURDIR}/../Response/Schema/74_response_get_policies.json
${74_1_response_get_policies}                                ${CURDIR}/../Response/${Testsite}_ExpectResult/74_1_response_get_policies.json
${74_2_response_get_policies}                                ${CURDIR}/../Response/${Testsite}_ExpectResult/74_2_response_get_policies.json
${74_3_response_get_policies}                                ${CURDIR}/../Response/${Testsite}_ExpectResult/74_3_response_get_policies.json

# 75
${75_response_get_package_codes}                             ${CURDIR}/../Response/Schema/75_response_get_package_codes.json
${75_1_response_get_package_codes}                           ${CURDIR}/../Response/${Testsite}_ExpectResult/75_1_response_get_package_codes.json
${75_2_response_get_package_codes}                           ${CURDIR}/../Response/${Testsite}_ExpectResult/75_2_response_get_package_codes.json
${75_3_response_get_package_codes}                           ${CURDIR}/../Response/${Testsite}_ExpectResult/75_3_response_get_package_codes.json

# 76
${76_response_get_termination_condition}                     ${CURDIR}/../Response/Schema/76_response_get_termination_condition.json
${76_1_response_get_termination_condition}                   ${CURDIR}/../Response/${Testsite}_ExpectResult/76_1_response_get_termination_condition.json
${76_2_response_get_termination_condition}                   ${CURDIR}/../Response/${Testsite}_ExpectResult/76_2_response_get_termination_condition.json
${76_3_response_get_termination_condition}                   ${CURDIR}/../Response/${Testsite}_ExpectResult/76_3_response_get_termination_condition.json

