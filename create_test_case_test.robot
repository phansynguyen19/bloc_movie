*** Settings ***
Library     RequestsLibrary
Library     JSONLibrary
Library     Collections
Library     String
Resource    ../../../resources/page_objects/project_test_case.robot

Suite Setup  Run keywords   utils.Get JWT From Keycloak     admin
    ...            AND      utils.Get JWT From Keycloak     user_1
    ...            AND      utils.Create Custom Field For Test    ${create_test_case_request_path}     0     7
    ...            AND      utils.Create Project Template For Test     ${create_test_case_request_path}   7     8
    ...            AND      utils.Create Project For Test           ${create_test_case_request_path}    8      9
    ...            AND      utils.Create Test Case Template For Test    ${create_test_case_request_path}    9    10 
Suite Teardown  Run keywords   utils.Delete Test Case Template For Test    @{test_case_template_name_list}
    ...            AND     utils.Delete Project For Test    @{prefix_name_list}
    ...            AND     utils.Delete Project Template For Test    @{template_name_list}
    ...            AND     utils.Delete Custom Field For Test    @{cfield_name_list}

*** Test Cases ***
Test Create Test Case Success With Full Valid Data
    [Documentation]
                ...    API Name:            Create Test Case
                ...    Confirm Content:     Create test case success with full data
                ...    Pre-condition:　　　　1.There are alreary 7 custom fields with 7 types
                ...                        2. There is already at least 1 project template
                ...                        3. There is already at least 1 project
                ...                        4. There is already at least 1 test case template
                ...    Result:              Create success with status code = 201
    [Tags]
    ${response}=    project_test_case.Create Test Case     ${create_test_case_request_path}   10    ${status_code_any}
    utils.Check Response Status And Message    ${response}    ${status_code_201}    ${create_success_msg}
    [Teardown]  project_test_case.Delete Test Case By ID    ${test_case_id}    ${status_code_200}

Test Create Test Case Success With Required Data Only And Non-required Data Is Null
    [Documentation]
                ...    API Name:            Create Test Case
                ...    Confirm Content:     Create test case success with required data only:
                ...                         precondition, scenario, tags, cfields = null
                ...    Pre-condition:　　　　1.There are alreary 7 custom fields with 7 types
                ...                        2. There is already at least 1 project template
                ...                        3. There is already at least 1 project
                ...                        4. There is already at least 1 test case template
                ...    Result:              Create success with status code = 201
    [Tags]
    ${response}=    project_test_case.Create Test Case     ${create_test_case_request_path}   11     ${status_code_any}
    utils.Check Response Status And Message    ${response}    ${status_code_201}    ${create_success_msg}
    [Teardown]  project_test_case.Delete Test Case By ID   ${test_case_id}   ${status_code_200}

Test Create Test Case Success With Required Data Only And Not Have Non-required Data
    [Documentation]
                ...    API Name:            Create Test Case
                ...    Confirm Content:     Create test case success with required data only:
                ...                         Not have precondition, scenario, tags, cfields, state, complexity, priority
                ...    Pre-condition:　　　　1.There are alreary 7 custom fields with 7 types
                ...                        2. There is already at least 1 project template
                ...                        3. There is already at least 1 project
                ...                        4. There is already at least 1 test case template
                ...    Result:              Create success with status code = 201
    [Tags]
    ${response}=    project_test_case.Create Test Case     ${create_test_case_request_path}   12     ${status_code_any}
    utils.Check Response Status And Message    ${response}    ${status_code_201}    ${create_success_msg}
    [Teardown]  project_test_case.Delete Test Case By ID   ${test_case_id}    ${status_code_200}

Test Create Test Case Success With Custom Fields Not Exist
    [Documentation]
                ...    API Name:            Create Test Case
                ...    Confirm Content:     Create test case success with custom fields not exist
                ...    Pre-condition:　　　　1.There are alreary 7 custom fields with 7 types
                ...                        2. There is already at least 1 project template
                ...                        3. There is already at least 1 project
                ...                        4. There is already at least 1 test case template
                ...    Result:              Create success with status code = 201 and warning message
    [Tags]
    ${response}=    project_test_case.Create Test Case     ${create_test_case_request_path}   13     ${status_code_any}
    utils.Check Response Status And Message    ${response}    ${status_code_201}    ${create_success_msg}
    utils.Check Warning Message   ${response}     cfield    not-exist-cfield
    [Teardown]  project_test_case.Delete Test Case By ID   ${test_case_id}    ${status_code_200}

Test Create Test Case Fail With No Test Case Title
    [Documentation]
                ...    API Name:            Create Test Case
                ...    Confirm Content:     Create test case fail with no test case title
                ...    Pre-condition:　　　　1.There are alreary 7 custom fields with 7 types
                ...                        2. There is already at least 1 project template
                ...                        3. There is already at least 1 project
                ...                        4. There is already at least 1 test case template
                ...    Result:              Create fail with status code = 422
    [Tags]
    ${response}=    project_test_case.Create Test Case     ${create_test_case_request_path}   14     ${status_code_any}
    utils.Check Response Status And Detail Message    ${response}    ${status_code_422}
    ...                                                         ${validate_require_msg}
    [Teardown]  project_test_case.Delete Test Case By ID   ${test_case_id}    ${status_code_any}

Test Create Test Case Fail With Test Case Title Is Null
    [Documentation]
                ...    API Name:            Create Test Case
                ...    Confirm Content:     Create test case fail with test case title is null
                ...    Pre-condition:　　　　1.There are alreary 7 custom fields with 7 types
                ...                        2. There is already at least 1 project template
                ...                        3. There is already at least 1 project
                ...                        4. There is already at least 1 test case template
                ...    Result:              Create fail with status code = 422
    [Tags]
    ${response}=    project_test_case.Create Test Case     ${create_test_case_request_path}   15     ${status_code_any}
    utils.Check Response Status And Detail Message    ${response}    ${status_code_422}
    ...                                                         ${validate_require_null_msg}
    [Teardown]  project_test_case.Delete Test Case By ID   ${test_case_id}   ${status_code_any}

#Test Create Test Case Fail With Test Case Title Exceed Max Length
#    [Documentation]
#                ...    API Name:            Create Test Case
#                ...    Confirm Content:     Create test case fail with test case title exceed max length
#                ...    Pre-condition:　　　　1.There are alreary 7 custom fields with 7 types
#                ...                        2. There is already at least 1 project template
#                ...                        3. There is already at least 1 project
#                ...                        4. There is already at least 1 test case template
#                ...    Result:              Create fail with status code = 422
#    [Tags]
#    ${response}=    project_test_case.Create Test Case     ${create_test_case_request_path}   16     ${status_code_any}
#    utils.Check Response Status And Detail Message    ${response}    ${status_code_422}
#    ...                                                         ${validate_max_length_50_msg}
#    [Teardown]  project_test_case.Delete Test Case By ID   ${test_case_id}   ${status_code_any}

Test Create Test Case Success With Duplicate Test Case Title
    [Documentation]
                ...    API Name:            Create Test Case
                ...    Confirm Content:     Create test case success with duplicate test case title
                ...    Pre-condition:　　　　1.There are alreary 7 custom fields with 7 types
                ...                        2. There is already at least 1 project template
                ...                        3. There is already at least 1 project
                ...                        4. There is already at least 1 test case template
                ...    Result:              Create success with status code = 201
    [Tags]
    project_test_case.Create Test Case     ${create_test_case_request_path}   10     ${status_code_201}
    ${test_case_id_1}=  set variable    ${test_case_id}
    ${response}=    project_test_case.Create Test Case     ${create_test_case_request_path}   10     ${status_code_any}
    ${test_case_id_2}=  set variable    ${test_case_id}
    utils.Check Response Status And Message    ${response}    ${status_code_201}
    ...                                        ${create_success_msg}
    [Teardown]  run keywords  project_test_case.Delete Test Case By ID   ${test_case_id_1}    ${status_code_200}
    ...         AND           project_test_case.Delete Test Case By ID   ${test_case_id_2}    ${status_code_200}

Test Create Test Case Fail With No Project
    [Documentation]
                ...    API Name:            Create Test Case
                ...    Confirm Content:     Create test case fail with no project
                ...    Pre-condition:　　　　1.There are alreary 7 custom fields with 7 types
                ...                        2. There is already at least 1 project template
                ...                        3. There is already at least 1 project
                ...                        4. There is already at least 1 test case template
                ...    Result:              Create fail with status code = 422
    [Tags]
    ${response}=    project_test_case.Create Test Case     ${create_test_case_request_path}   17     ${status_code_any}
    utils.Check Response Status And Detail Message    ${response}    ${status_code_422}
    ...                                                         ${validate_require_msg}
    [Teardown]  project_test_case.Delete Test Case By ID   ${test_case_id}    ${status_code_any}

Test Create Test Case Fail With Project Is Null
    [Documentation]
                ...    API Name:            Create Test Case
                ...    Confirm Content:     Create test case fail with project is null
                ...    Pre-condition:　　　　1.There are alreary 7 custom fields with 7 types
                ...                        2. There is already at least 1 project template
                ...                        3. There is already at least 1 project
                ...                        4. There is already at least 1 test case template
                ...    Result:              Create fail with status code = 422
    [Tags]
    ${response}=    project_test_case.Create Test Case     ${create_test_case_request_path}   18     ${status_code_any}
    utils.Check Response Status And Detail Message    ${response}    ${status_code_422}
    ...                                                         ${validate_require_null_msg}
    [Teardown]  project_test_case.Delete Test Case By ID   ${test_case_id}    ${status_code_any}

Test Create Test Case Fail With Project Exceed Max Length
    [Documentation]
                ...    API Name:            Create Test Case
                ...    Confirm Content:     Create test case fail with project exceed max length
                ...    Pre-condition:　　　　1.There are alreary 7 custom fields with 7 types
                ...                        2. There is already at least 1 project template
                ...                        3. There is already at least 1 project
                ...                        4. There is already at least 1 test case template
                ...    Result:              Create fail with status code = 422
    [Tags]
    ${response}=    project_test_case.Create Test Case     ${create_test_case_request_path}   19     ${status_code_any}
    utils.Check Response Status And Detail Message    ${response}    ${status_code_422}
    ...                                                         ${validate_max_length_50_msg}
    [Teardown]  project_test_case.Delete Test Case By ID   ${test_case_id}    ${status_code_any}

Test Create Test Case Fail With Invalid Project
    [Documentation]
                ...    API Name:            Create Test Case
                ...    Confirm Content:     Create test case fail with invalid project
                ...    Pre-condition:　　　　1.There are alreary 7 custom fields with 7 types
                ...                        2. There is already at least 1 project template
                ...                        3. There is already at least 1 project
                ...                        4. There is already at least 1 test case template
                ...    Result:              Create fail with status code = 400
    [Tags]
    ${response}=    project_test_case.Create Test Case     ${create_test_case_request_path}   20     ${status_code_any}
    utils.Check Response Status And Message    ${response}    ${status_code_400}
    ...                                        ${create_test_case_project_not_found_msg}
    [Teardown]    project_test_case.Delete Test Case By ID   ${test_case_id}    ${status_code_any}

Test Create Test Case Fail With No Summary
    [Documentation]
                ...    API Name:            Create Test Case
                ...    Confirm Content:     Create test case fail with no summary
                ...    Pre-condition:　　　　1.There are alreary 7 custom fields with 7 types
                ...                        2. There is already at least 1 project template
                ...                        3. There is already at least 1 project
                ...                        4. There is already at least 1 test case template
                ...    Result:              Create fail with status code = 422
    [Tags]
    ${response}=    project_test_case.Create Test Case     ${create_test_case_request_path}   21     ${status_code_any}
    utils.Check Response Status And Detail Message    ${response}    ${status_code_422}
    ...                                                         ${validate_require_msg}
    [Teardown]  project_test_case.Delete Test Case By ID   ${test_case_id}    ${status_code_any}

Test Create Test Case Fail With Summary Is Null
    [Documentation]
                ...    API Name:            Create Test Case
                ...    Confirm Content:     Create test case fail with summary is null
                ...    Pre-condition:　　　　1.There are alreary 7 custom fields with 7 types
                ...                        2. There is already at least 1 project template
                ...                        3. There is already at least 1 project
                ...                        4. There is already at least 1 test case template
                ...    Result:              Create fail with status code = 422
    [Tags]
    ${response}=    project_test_case.Create Test Case     ${create_test_case_request_path}   22     ${status_code_any}
    utils.Check Response Status And Detail Message    ${response}    ${status_code_422}
    ...                                                         ${validate_require_null_msg}
    [Teardown]  project_test_case.Delete Test Case By ID   ${test_case_id}    ${status_code_any}

#Test Create Test Case Fail With Summary Exceed Max Length
#    [Documentation]
#                ...    API Name:            Create Test Case
#                ...    Confirm Content:     Create test case fail with summary exceed max length
#                ...    Pre-condition:　　　　1.There are alreary 7 custom fields with 7 types
#                ...                        2. There is already at least 1 project template
#                ...                        3. There is already at least 1 project
#                ...                        4. There is already at least 1 test case template
#                ...    Result:              Create fail with status code = 422
#    [Tags]
#    ${response}=    project_test_case.Create Test Case     ${create_test_case_request_path}   23     ${status_code_any}
#    utils.Check Response Status And Detail Message    ${response}    ${status_code_422}
#    ...                                                         ${validate_max_length_5000_msg}
#    [Teardown]  project_test_case.Delete Test Case By ID   ${test_case_id}    ${status_code_any}

Test Create Test Case Fail With No Template
    [Documentation]
                ...    API Name:            Create Test Case
                ...    Confirm Content:     Create test case fail with no template
                ...    Pre-condition:　　　　1.There are alreary 7 custom fields with 7 types
                ...                        2. There is already at least 1 project template
                ...                        3. There is already at least 1 project
                ...                        4. There is already at least 1 test case template
                ...    Result:              Create fail with status code = 422
    [Tags]
    ${response}=    project_test_case.Create Test Case     ${create_test_case_request_path}   24     ${status_code_any}
    utils.Check Response Status And Detail Message    ${response}    ${status_code_422}
    ...                                                         ${validate_require_msg}
    [Teardown]  project_test_case.Delete Test Case By ID   ${test_case_id}    ${status_code_any}

Test Create Test Case Fail With Template Is Null
    [Documentation]
                ...    API Name:            Create Test Case
                ...    Confirm Content:     Create test case fail with template is null
                ...    Pre-condition:　　　　1.There are alreary 7 custom fields with 7 types
                ...                        2. There is already at least 1 project template
                ...                        3. There is already at least 1 project
                ...                        4. There is already at least 1 test case template
                ...    Result:              Create fail with status code = 422
    [Tags]
    ${response}=    project_test_case.Create Test Case     ${create_test_case_request_path}   25     ${status_code_any}
    utils.Check Response Status And Detail Message    ${response}    ${status_code_422}
    ...                                                         ${validate_require_null_msg}
    [Teardown]  project_test_case.Delete Test Case By ID   ${test_case_id}    ${status_code_any}

Test Create Test Case Fail With Template Exceed Max Length
    [Documentation]
                ...    API Name:            Create Test Case
                ...    Confirm Content:     Create test case fail with template exceed max length
                ...    Pre-condition:　　　　1.There are alreary 7 custom fields with 7 types
                ...                        2. There is already at least 1 project template
                ...                        3. There is already at least 1 project
                ...                        4. There is already at least 1 test case template
                ...    Result:              Create fail with status code = 422
    [Tags]
    ${response}=    project_test_case.Create Test Case     ${create_test_case_request_path}   26     ${status_code_any}
    utils.Check Response Status And Detail Message    ${response}    ${status_code_422}
    ...                                                         ${validate_max_length_50_msg}
    [Teardown]  project_test_case.Delete Test Case By ID   ${test_case_id}    ${status_code_any}

Test Create Test Case Fail With Template Not Exist
    [Documentation]
                ...    API Name:            Create Test Case
                ...    Confirm Content:     Create test case fail with template not exist
                ...    Pre-condition:　　　　1.There are alreary 7 custom fields with 7 types
                ...                        2. There is already at least 1 project template
                ...                        3. There is already at least 1 project
                ...                        4. There is already at least 1 test case template
                ...    Result:              Create fail with status code = 400
    [Tags]
    ${response}=    project_test_case.Create Test Case     ${create_test_case_request_path}   27     ${status_code_any}
    utils.Check Response Status And Message    ${response}    ${status_code_404}
    ...                                                         ${create_test_case_template_not_found_msg}
    [Teardown]  project_test_case.Delete Test Case By ID   ${test_case_id}    ${status_code_any}

Test Create Test Case Fail With No Mode, est_man_exec_time
    [Documentation]
                ...    API Name:            Create Test Case
                ...    Confirm Content:     Create test case fail with no mode, est_man_exec_time
                ...    Pre-condition:　　　　1.There are alreary 7 custom fields with 7 types
                ...                        2. There is already at least 1 project template
                ...                        3. There is already at least 1 project
                ...                        4. There is already at least 1 test case template
                ...    Result:              Create fail with status code = 422
    [Tags]
    ${response}=    project_test_case.Create Test Case     ${create_test_case_request_path}   28     ${status_code_any}
    Check Response With List Of Error Fields And Error Message    ${response}    ${status_code_422}
    ...                                                         ${validate_require_msg}   mode    est_man_exec_time
    [Teardown]  project_test_case.Delete Test Case By ID   ${test_case_id}    ${status_code_any}

Test Create Test Case Fail With Invalid State
    [Documentation]
                ...    API Name:            Create Test Case
                ...    Confirm Content:     Create test case fail with invalid state
                ...    Pre-condition:　　　　1.There are alreary 7 custom fields with 7 types
                ...                        2. There is already at least 1 project template
                ...                        3. There is already at least 1 project
                ...                        4. There is already at least 1 test case template
                ...    Result:              Create fail with status code = 422
    [Tags]
    ${response}=    project_test_case.Create Test Case     ${create_test_case_request_path}   29     ${status_code_any}
    utils.Check Response Status And Detail Message    ${response}    ${status_code_422}
    ...                                               ${create_test_case_invalid_state_msg}
    [Teardown]  project_test_case.Delete Test Case By ID   ${test_case_id}    ${status_code_any}

Test Create Test Case Fail With Invalid Mode
    [Documentation]
                ...    API Name:            Create Test Case
                ...    Confirm Content:     Create test case fail with invalid mode
                ...    Pre-condition:　　　　1.There are alreary 7 custom fields with 7 types
                ...                        2. There is already at least 1 project template
                ...                        3. There is already at least 1 project
                ...                        4. There is already at least 1 test case template
                ...    Result:              Create fail with status code = 422
    [Tags]
    ${response}=    project_test_case.Create Test Case     ${create_test_case_request_path}   30     ${status_code_any}
    utils.Check Response Status And Detail Message    ${response}   ${status_code_422}
    ...                                               ${test_case_invalid_mode_msg}
    [Teardown]  project_test_case.Delete Test Case By ID   ${test_case_id}    ${status_code_any}

Test Create Test Case Fail With Invalid Priority
    [Documentation]
                ...    API Name:            Create Test Case
                ...    Confirm Content:     Create test case fail with invalid priority
                ...    Pre-condition:　　　　1.There are alreary 7 custom fields with 7 types
                ...                        2. There is already at least 1 project template
                ...                        3. There is already at least 1 project
                ...                        4. There is already at least 1 test case template
                ...    Result:              Create fail with status code = 422
    [Tags]
    ${response}=    project_test_case.Create Test Case     ${create_test_case_request_path}   31     ${status_code_any}
    utils.Check Response Status And Detail Message    ${response}    ${status_code_422}
    ...                                                         ${test_case_invalid_priority_msg}
    [Teardown]  project_test_case.Delete Test Case By ID   ${test_case_id}    ${status_code_any}

Test Create Test Case Fail With Invalid Complexity
    [Documentation]
                ...    API Name:            Create Test Case
                ...    Confirm Content:     Create test case fail with invalid complexity
                ...    Pre-condition:　　　　1.There are alreary 7 custom fields with 7 types
                ...                        2. There is already at least 1 project template
                ...                        3. There is already at least 1 project
                ...                        4. There is already at least 1 test case template
                ...    Result:              Create fail with status code = 422
    [Tags]
    ${response}=    project_test_case.Create Test Case     ${create_test_case_request_path}   32     ${status_code_any}
    utils.Check Response Status And Detail Message    ${response}    ${status_code_422}
    ...                                                         ${test_case_invalid_complexity_msg}
    [Teardown]  project_test_case.Delete Test Case By ID   ${test_case_id}    ${status_code_any}

Test Create Test Case Fail With est_man_exec_time Is Not Float
    [Documentation]
                ...    API Name:            Create Test Case
                ...    Confirm Content:     Create test case fail with est_man_exec_time is not float
                ...    Pre-condition:　　　　1.There are alreary 7 custom fields with 7 types
                ...                        2. There is already at least 1 project template
                ...                        3. There is already at least 1 project
                ...                        4. There is already at least 1 test case template
                ...    Result:              Create fail with status code = 422
    [Tags]
    ${response}=    project_test_case.Create Test Case     ${create_test_case_request_path}   33     ${status_code_any}
    Check Response With List Of Error Fields And Error Message    ${response}    ${status_code_422}
    ...                                                         ${validate_invalid_float_msg}    est_man_exec_time
    [Teardown]  project_test_case.Delete Test Case By ID   ${test_case_id}    ${status_code_any}

Test Create Test Case Fail With Input Custom Field Has Value Exceed Length
    [Documentation]
                ...    API Name:            Create Test Case
                ...    Confirm Content:     Create test case fail with input custom field has value exceed length
                ...    Pre-condition:　　　　1.There are alreary 7 custom fields with 7 types
                ...                        2. There is already at least 1 project template
                ...                        3. There is already at least 1 project
                ...                        4. There is already at least 1 test case template
                ...    Result:              Create fail with status code = 400
    [Tags]
    ${response}=    project_test_case.Create Test Case     ${create_test_case_request_path}   34     ${status_code_any}
    utils.Check Response Status And Message    ${response}    ${status_code_400}
    ...                                                         ${create_project_invalid_input_value_msg}
    [Teardown]  project_test_case.Delete Test Case By ID   ${test_case_id}    ${status_code_any}

Test Create Test Case Fail With Password Custom Field Has Value Exceed Length
    [Documentation]
                ...    API Name:            Create Test Case
                ...    Confirm Content:     Create test case fail with password custom field has value exceed length
                ...    Pre-condition:　　　　1.There are alreary 7 custom fields with 7 types
                ...                        2. There is already at least 1 project template
                ...                        3. There is already at least 1 project
                ...                        4. There is already at least 1 test case template
                ...    Result:              Create fail with status code = 400
    [Tags]
    ${response}=    project_test_case.Create Test Case     ${create_test_case_request_path}   35     ${status_code_any}
    utils.Check Response Status And Message    ${response}    ${status_code_400}
    ...                                                         ${create_project_invalid_password_value_msg}
    [Teardown]  project_test_case.Delete Test Case By ID   ${test_case_id}    ${status_code_any}

Test Create Test Case Fail With Textarea Custom Field Has Value Exceed Length
    [Documentation]
                ...    API Name:            Create Test Case
                ...    Confirm Content:     Create test case fail with textarea custom field has value exceed length
                ...    Pre-condition:　　　　1.There are alreary 7 custom fields with 7 types
                ...                        2. There is already at least 1 project template
                ...                        3. There is already at least 1 project
                ...                        4. There is already at least 1 test case template
                ...    Result:              Create fail with status code = 400
    [Tags]
    ${response}=    project_test_case.Create Test Case     ${create_test_case_request_path}   36     ${status_code_any}
    utils.Check Response Status And Message    ${response}    ${status_code_400}
    ...                                                         ${create_project_invalid_textarea_value_msg}
    [Teardown]  project_test_case.Delete Test Case By ID   ${test_case_id}    ${status_code_any}

Test Create Test Case Fail With Richtextarea Custom Field Has Value Exceed Length
    [Documentation]
                ...    API Name:            Create Test Case
                ...    Confirm Content:     Create test case fail with richtextarea custom field has value exceed length
                ...    Pre-condition:　　　　1.There are alreary 7 custom fields with 7 types
                ...                        2. There is already at least 1 project template
                ...                        3. There is already at least 1 project
                ...                        4. There is already at least 1 test case template
                ...    Result:              Create fail with status code = 400
    [Tags]
    ${response}=    project_test_case.Create Test Case     ${create_test_case_request_path}   37     ${status_code_any}
    utils.Check Response Status And Message    ${response}    ${status_code_400}
    ...                                                         ${create_project_invalid_richtextarea_value_msg}
    [Teardown]  project_test_case.Delete Test Case By ID   ${test_case_id}    ${status_code_any}

Test Create Test Case Fail With Radio Custom Field Has Value Is Not Boolean
    [Documentation]
                ...    API Name:            Create Test Case
                ...    Confirm Content:     Create test case fail with radio custom field has value is not boolean
                ...    Pre-condition:　　　　1.There are alreary 7 custom fields with 7 types
                ...                        2. There is already at least 1 project template
                ...                        3. There is already at least 1 project
                ...                        4. There is already at least 1 test case template
                ...    Result:              Create fail with status code = 400
    [Tags]
    ${response}=    project_test_case.Create Test Case     ${create_test_case_request_path}   38     ${status_code_any}
    ${value}=       project_test_case.Get Value Of Custom Field When Create Test Case
    ...                                                                      ${create_test_case_request_path}   38
    ${invalid_radio_value_msg}=     replace string    ${create_project_invalid_radio_value_msg}   input_value  ${value}
    utils.Check Response Status And Message    ${response}    ${status_code_400}
    ...                                                         ${invalid_radio_value_msg}
    [Teardown]  project_test_case.Delete Test Case By ID   ${test_case_id}    ${status_code_any}

Test Create Test Case Fail With Checkbox Custom Field Has Value Is Not Boolean
    [Documentation]
                ...    API Name:            Create Test Case
                ...    Confirm Content:     Create test case fail with checkbox custom field has value is not boolean
                ...    Pre-condition:　　　　1.There are alreary 7 custom fields with 7 types
                ...                        2. There is already at least 1 project template
                ...                        3. There is already at least 1 project
                ...                        4. There is already at least 1 test case template
                ...    Result:              Create fail with status code = 400
    [Tags]
    ${response}=    project_test_case.Create Test Case     ${create_test_case_request_path}   39     ${status_code_any}
    ${value}=       project_test_case.Get Value Of Custom Field When Create Test Case
    ...                                                                         ${create_test_case_request_path}   39
    ${invalid_checkbox_value_msg}=    replace string    ${create_project_invalid_checkbox_value_msg}   input_value  ${value}
    utils.Check Response Status And Message    ${response}    ${status_code_400}
    ...                                                         ${invalid_checkbox_value_msg}
    [Teardown]  project_test_case.Delete Test Case By ID   ${test_case_id}    ${status_code_any}

Test Create Test Case Fail With Dropdown Custom Field Has Value Is Not In Option List
    [Documentation]
                ...    API Name:            Create Test Case
                ...    Confirm Content:   Create test case fail with dropdown custom field has value is not in option list
                ...    Pre-condition:　　　　1.There are alreary 7 custom fields with 7 types
                ...                        2. There is already at least 1 project template
                ...                        3. There is already at least 1 project
                ...                        4. There is already at least 1 test case template
                ...    Result:              Create fail with status code = 400
    [Tags]
    ${response}=    project_test_case.Create Test Case     ${create_test_case_request_path}   40     ${status_code_any}
    ${value}=       project_test_case.Get Value Of Custom Field When Create Test Case
    ...                                                                     ${create_test_case_request_path}   40
    ${invalid_dropdown_value_msg}=   replace string    ${create_project_invalid_dropdown_value_msg}   input_value  ${value}
    utils.Check Response Status And Message    ${response}    ${status_code_400}
    ...                                                         ${invalid_dropdown_value_msg}
    [Teardown]  project_test_case.Delete Test Case By ID   ${test_case_id}    ${status_code_any}

Test Create Test Case Fail With Invalid Precondition Format
    [Documentation]
                ...    API Name:            Create Test Case
                ...    Confirm Content:     Create test case fail with invalid precondition format
                ...    Pre-condition:　　　　1.There are alreary 7 custom fields with 7 types
                ...                        2. There is already at least 1 project template
                ...                        3. There is already at least 1 project
                ...                        4. There is already at least 1 test case template
                ...    Result:              Create fail with status code = 422
    [Tags]
    ${response}=    project_test_case.Create Test Case     ${create_test_case_request_path}   41     ${status_code_any}
    utils.Check Response Status And Detail Message    ${response}    ${status_code_422}
    ...                                                         ${validate_require_null_msg}
    [Teardown]  project_test_case.Delete Test Case By ID   ${test_case_id}    ${status_code_any}

Test Create Test Case Fail With Invalid Scenario Format
    [Documentation]
                ...    API Name:            Create Test Case
                ...    Confirm Content:     Create test case fail with invalid scenario format
                ...    Pre-condition:　　　　1.There are alreary 7 custom fields with 7 types
                ...                        2. There is already at least 1 project template
                ...                        3. There is already at least 1 project
                ...                        4. There is already at least 1 test case template
                ...    Result:              Create fail with status code = 422
    [Tags]
    ${response}=    project_test_case.Create Test Case     ${create_test_case_request_path}   42     ${status_code_any}
    utils.Check Response Status And Detail Message    ${response}    ${status_code_422}
    ...                                                         ${validate_require_msg}
    [Teardown]  project_test_case.Delete Test Case By ID   ${test_case_id}    ${status_code_any}

Test Create Test Case Fail With Invalid Tags Format
    [Documentation]
                ...    API Name:            Create Test Case
                ...    Confirm Content:     Create test case fail with invalid tags format
                ...    Pre-condition:　　　　1.There are alreary 7 custom fields with 7 types
                ...                        2. There is already at least 1 project template
                ...                        3. There is already at least 1 project
                ...                        4. There is already at least 1 test case template
                ...    Result:              Create fail with status code = 422
    [Tags]
    ${response}=    project_test_case.Create Test Case     ${create_test_case_request_path}   43     ${status_code_any}
    utils.Check Response Status And Detail Message    ${response}    ${status_code_422}
    ...                                                         ${validate_require_null_msg}
    [Teardown]  project_test_case.Delete Test Case By ID   ${test_case_id}    ${status_code_any}

Test Create Test Case Success With Reuse_tc_id Is False
    [Documentation]
                ...    API Name:            Create Test Case
                ...    Confirm Content:     Create test case success with reuse_tc_id is false
                ...    Pre-condition:　　　　1.There are alreary 7 custom fields with 7 types
                ...                        2. There is already at least 1 project template
                ...                        3. There is already at least 1 project
                ...                        4. There is already at least 1 test case template
                ...    Result:              Create success with status code = 201
                ...                         and tc_id is auto-increment from last tc_id
    [Tags]
    ${response}=    project_test_case.Create Test Case     ${create_test_case_request_path}   10    ${status_code_any}
    ${test_case_id_1}=  set variable  ${test_case_id}
    ${response}=    project_test_case.Create Test Case     ${create_test_case_request_path}   11    ${status_code_any}
    ${test_case_id_2}=  set variable  ${test_case_id}
    project_test_case.Delete Test Case By ID    ${test_case_id_1}    ${status_code_200}
    ${response}=    project_test_case.Create Test Case With Reuse Flag     ${create_test_case_request_path}   12
    ...                                                                    ${status_code_any}     false
    utils.Check Response Status And Message    ${response}    ${status_code_201}    ${create_success_msg}
    project_test_case.Compare Index Of Test Case When Reuse Flag Is False    ${test_case_id_2}    ${test_case_id}
    ...                                                                      ${test_case_project}
    [Teardown]  run keywords  project_test_case.Delete Test Case By ID    ${test_case_id}    ${status_code_200}
    ...         AND           project_test_case.Delete Test Case By ID    ${test_case_id_2}    ${status_code_200}

Test Create Test Case Success With Reuse_tc_id Is True
    [Documentation]
                ...    API Name:            Create Test Case
                ...    Confirm Content:     Create test case success with reuse_tc_id is true
                ...    Pre-condition:　　　　1.There are alreary 7 custom fields with 7 types
                ...                        2. There is already at least 1 project template
                ...                        3. There is already at least 1 project
                ...                        4. There is already at least 1 test case template
                ...    Result:              Create success with status code = 201
                ...                         and tc_id is re-use from the deleted tc_id
    [Tags]
    ${response}=    project_test_case.Create Test Case     ${create_test_case_request_path}   10    ${status_code_any}
    ${test_case_id_1}=  set variable  ${test_case_id}
    ${response}=    project_test_case.Create Test Case     ${create_test_case_request_path}   11    ${status_code_any}
    ${test_case_id_2}=  set variable  ${test_case_id}
    project_test_case.Delete Test Case By ID    ${test_case_id_1}    ${status_code_200}
    ${response}=    project_test_case.Create Test Case With Reuse Flag     ${create_test_case_request_path}   12
    ...                                                                    ${status_code_any}     true
    utils.Check Response Status And Message    ${response}    ${status_code_201}    ${create_success_msg}
    project_test_case.Compare Index Of Test Case When Reuse Flag Is True    ${test_case_id_1}    ${test_case_id}
    ...                                                                     ${test_case_project}
    [Teardown]  run keywords  project_test_case.Delete Test Case By ID    ${test_case_id}    ${status_code_200}
    ...         AND           project_test_case.Delete Test Case By ID    ${test_case_id_2}    ${status_code_200}

Test Create Test Case Success With Valid Test Case Id
    [Documentation]
                ...    API Name:            Create Test Case
                ...    Confirm Content:     Create test case success with valid test case id
                ...    Pre-condition:　　　　1.There are alreary 7 custom fields with 7 types
                ...                        2. There is already at least 1 project template
                ...                        3. There is already at least 1 project
                ...                        4. There is already at least 1 test case template
                ...    Result:              Create success with status code = 201
    [Tags]
    ${response}=    project_test_case.Create Test Case     ${create_test_case_request_path}   44    ${status_code_any}
    utils.Check Response Status And Message    ${response}    ${status_code_201}    ${create_success_msg}
    project_test_case.Compare Test Case Id    ${create_test_case_request_path}   44    ${test_case_id}
    [Teardown]  project_test_case.Delete Test Case By ID    ${test_case_id}    ${status_code_200}

Test Create Test Case Success With Valid Test Case Id And Reuse_tc_id Is True
    [Documentation]
                ...    API Name:            Create Test Case
                ...    Confirm Content:     Create test case success with valid test case id and reuse_tc_id is true
                ...    Pre-condition:　　　　1.There are alreary 7 custom fields with 7 types
                ...                        2. There is already at least 1 project template
                ...                        3. There is already at least 1 project
                ...                        4. There is already at least 1 test case template
                ...    Result:              Create success with status code = 201
    [Tags]
    ${response}=    project_test_case.Create Test Case With Reuse Flag     ${create_test_case_request_path}   44
    ...                                                                    ${status_code_any}    true
    utils.Check Response Status And Message    ${response}    ${status_code_201}    ${create_success_msg}
    project_test_case.Compare Test Case Id    ${create_test_case_request_path}   44    ${test_case_id}
    [Teardown]  project_test_case.Delete Test Case By ID    ${test_case_id}    ${status_code_200}

Test Create Test Case Success With Null Test Case Id
    [Documentation]
                ...    API Name:            Create Test Case
                ...    Confirm Content:     Create test case success with null test case id
                ...    Pre-condition:　　　　1.There are alreary 7 custom fields with 7 types
                ...                        2. There is already at least 1 project template
                ...                        3. There is already at least 1 project
                ...                        4. There is already at least 1 test case template
                ...    Result:              Create success with status code = 201
    [Tags]
    ${response}=    project_test_case.Create Test Case     ${create_test_case_request_path}   45    ${status_code_any}
    utils.Check Response Status And Message    ${response}    ${status_code_201}    ${create_success_msg}
    [Teardown]  project_test_case.Delete Test Case By ID    ${test_case_id}    ${status_code_200}

Test Create Test Case Fail With Invalid Test Case Id
    [Documentation]
                ...    API Name:            Create Test Case
                ...    Confirm Content:     Create test case fail with invalid test case id
                ...    Pre-condition:　　　　1.There are alreary 7 custom fields with 7 types
                ...                        2. There is already at least 1 project template
                ...                        3. There is already at least 1 project
                ...                        4. There is already at least 1 test case template
                ...    Result:              Create fail with status code = 400
    [Tags]
    ${response}=    project_test_case.Create Test Case     ${create_test_case_request_path}   46    ${status_code_any}
    utils.Check Response Status And Message    ${response}    ${status_code_400}    ${test_case_invalid_format_id_msg}
    [Teardown]  project_test_case.Delete Test Case By ID    ${test_case_id}    ${status_code_any}

Test Create Test Case Fail With Duplicate Test Case Id
    [Documentation]
                ...    API Name:            Create Test Case
                ...    Confirm Content:     Create test case fail with duplicate test case id
                ...    Pre-condition:　　　　1.There are alreary 7 custom fields with 7 types
                ...                        2. There is already at least 1 project template
                ...                        3. There is already at least 1 project
                ...                        4. There is already at least 1 test case template
                ...    Result:              Create fail with status code = 400
    [Tags]
    project_test_case.Create Test Case     ${create_test_case_request_path}   10    ${status_code_201}
    ${test_case_id_1}=    set variable  ${test_case_id}
    ${response}=    project_test_case.Create Test Case     ${create_test_case_request_path}   47    ${status_code_any}
    utils.Check Response Status And Message    ${response}    ${status_code_400}    ${test_case_duplicate_id_msg}
    [Teardown]  project_test_case.Delete Test Case By ID    ${test_case_id_1}    ${status_code_any}
