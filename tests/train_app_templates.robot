*** Settings ***
Documentation     Template-driven UI suite (ADD / UPDATE / DELETE / SEARCH / VIEW).
Library           SeleniumLibrary
Library           ../BrowserManager.py
Resource          ../resources/TrainApp.resource
Resource          ../variables/Locators.robot
Suite Setup       Setup And Login
Suite Teardown    Close All Browsers
Test Setup        Go Home

*** Variables ***
${HEADLESS}       ${False}
${BROWSER}        chrome
${BASE_URL}       ${APP_BASE_URL}

# Reusable canonical data
${FROM_A}         PATNA
${TO_B}           DELHI
${NAME_A}         TEST EXPRESS
${FARE_OK}        550.50
${SEATS_OK}       120

# ------------------------------------------------------------------------------
# ADD (US1)
# ------------------------------------------------------------------------------

*** Test Cases ***    ADD flows – success (template)
Add new train row - basic happy path
    [Template]    T_Add_Train_Succeeds
    ${NAME_A}    ${FROM_A}    ${TO_B}    ${SEATS_OK}    ${FARE_OK}

*** Keywords ***
T_Add_Train_Succeeds
    [Arguments]    ${name}    ${from}    ${to}    ${available}    ${fare}
    ${train_no}=    Generate Unique Train Number
    Add Train    ${train_no}    ${name}    ${from}    ${to}    ${available}    ${fare}
    Confirmation Should Contain    ${MSG_ADD_SUCCESS}
    Search Train By Number Should Show
    ...    ${train_no}    ${name}    ${from}    ${to}    ${available}    ${fare}
    Row In View Trains Should Show
    ...    ${train_no}    ${name}    ${from}    ${to}    ${available}    ${fare}

## ---- ADD validations
#
#*** Test Cases ***    ADD flows – inline validations (template)
#[Test Template]    T_Add_Inline_Validation
#Name required                                 name=         from=${FROM_A}    to=${TO_B}    available=${SEATS_OK}    fare=${FARE_OK}    expected=${ERR_TRAIN_NAME_REQUIRED}
#Available must be positive                    name=${NAME_A}  from=${FROM_A}  to=${TO_B}   available=-5            fare=${FARE_OK}     expected=${ERR_AVAILABLE_POSITIVE}
#Fare must be positive                         name=${NAME_A}  from=${FROM_A}  to=${TO_B}   available=${SEATS_OK}    fare=0              expected=${ERR_FARE_POSITIVE}
#
#*** Keywords ***
#T_Add_Inline_Validation
#    [Arguments]    ${name}    ${from}    ${to}    ${available}    ${fare}    ${expected}
#    ${train_no}=    Generate Unique Train Number
#    Open Add Train
#    Fill Add Train Form    ${train_no}    ${name}    ${from}    ${to}    ${available}    ${fare}
#    Click Button           ${BTN_ADD_TRAIN}
#    Inline Error Should Be Visible    ${expected}
#
#*** Test Cases ***    ADD flows – uniqueness (template)
#[Test Template]    T_Add_Duplicate_Number_Validation
#Duplicate train number rejected               DUMMY A    PATNA    HOWRAH    50    300
#
#*** Keywords ***
#T_Add_Duplicate_Number_Validation
#    [Arguments]    ${name}    ${from}    ${to}    ${available}    ${fare}
#    ${dupe_no}=    Generate Unique Train Number
#    Add Train    ${dupe_no}    SEED ROW    ${from}    ${to}    ${available}    ${fare}
#    Open Add Train
#    Fill Add Train Form    ${dupe_no}    ${name}    ${from}    ${to}    ${available}    ${fare}
#    Click Button           ${BTN_ADD_TRAIN}
#    Error Toast Should Contain    ${ERR_TRAIN_NO_EXISTS}
#
## ------------------------------------------------------------------------------
## UPDATE (US2)
## ------------------------------------------------------------------------------
#
#*** Test Cases ***    UPDATE via "View Trains" action (template)
#[Test Template]    T_Update_Via_List
#Update fare through list action               fare=500.00
#
#*** Keywords ***
#T_Update_Via_List
#    [Arguments]    ${fare}=    ${available}=
#    ${train_no}=    Ensure Train Exists    10002    SAMPLE TRAIN    PUNE    GOA    200    451.00
#    Open View Trains
#    Click Update For Train    ${train_no}
#    Update Train Fields (Keep No Fixed)    fare=${fare}    available=${available}
#    Click Button           ${BTN_UPDATE_TRAIN}
#    Confirmation Should Contain    ${MSG_UPDATE_SUCCESS}
#    Row In View Trains Should Show    ${train_no}    ${ANY}    ${ANY}    ${ANY}    ${ANY}    ${fare}
#
#*** Test Cases ***    UPDATE via "Update Train Details" (template)
#[Test Template]    T_Update_Via_SearchForm
#Increase available seats                      available=10
#
#*** Keywords ***
#T_Update_Via_SearchForm
#    [Arguments]    ${fare}=    ${available}=
#    ${train_no}=    Ensure Train Exists    10007    ANOTHER TRAIN    PATNA    DELHI    1    300
#    Open Update Train Details
#    Search Train To Edit By Number    ${train_no}
#    Update Train Fields (Keep No Fixed)    fare=${fare}    available=${available}
#    Click Button           ${BTN_UPDATE_TRAIN}
#    Confirmation Should Contain    ${MSG_UPDATE_SUCCESS}
#    Search Train By Number Should Show    ${train_no}    ${ANY}    ${ANY}    ${ANY}    ${available}    ${fare}
#
#*** Test Cases ***    UPDATE validations (template)
#[Test Template]    T_Update_Inline_Validation
#Name required on update                       clear=name        expected=${ERR_TRAIN_NAME_REQUIRED}
#Available must be positive on update          set-available=-1  expected=${ERR_AVAILABLE_POSITIVE}
#Train number field is read-only               check-readonly
#
#*** Keywords ***
#T_Update_Inline_Validation
#    [Arguments]    ${clear}=    ${set-available}=    ${expected}=
#    ${train_no}=    Ensure Train Exists    10011    VALIDATE ME    A    B    5    50
#    Open Update Train Details
#    Search Train To Edit By Number    ${train_no}
#    Run Keyword If    '${clear}'=='name'    Clear And Blur Field    ${FLD_TRAIN_NAME}
#    Run Keyword If    '${set-available}'!=''    Set Field Value    ${FLD_AVAILABLE}    ${set-available}
#    Run Keyword If    '${expected}'!=''    Inline Error Should Be Visible    ${expected}
#    Run Keyword If    '${clear}'==''
#    ...    Field Should Be Readonly    ${FLD_TRAIN_NO}
#
## ------------------------------------------------------------------------------
## DELETE (US3)
## ------------------------------------------------------------------------------
#
#*** Test Cases ***    DELETE flows (template)
#[Test Template]    T_Delete_Flows
#Delete an existing train                      existing
#Delete a non-existent train                   nonexistent     99999
#
#*** Keywords ***
#T_Delete_Flows
#    [Arguments]    ${mode}    ${train_no}=    ${name}=TO DELETE    ${from}=X    ${to}=Y    ${available}=80    ${fare}=400
#    Run Keyword If    '${mode}'=='existing'    Set Suite Variable    ${train_no}    ${None}
#    Run Keyword If    '${mode}'=='existing'    ${train_no}=    Ensure Train Exists    10009    ${name}    ${from}    ${to}    ${available}    ${fare}
#    Open Delete Train
#    Delete Train By Number With Confirm    ${train_no}
#    Run Keyword If    '${mode}'=='existing'
#    ...    Confirmation Should Contain    ${MSG_DELETE_SUCCESS_PREFIX}${train_no}${MSG_DELETE_SUCCESS_SUFFIX}
#    Run Keyword If    '${mode}'=='existing'
#    ...    Search Train Should Show Not Available Message    ${train_no}
#    Run Keyword If    '${mode}'=='existing'
#    ...    View Trains Should Not Contain Train Number    ${train_no}
#    Run Keyword If    '${mode}'=='nonexistent'
#    ...    Error Toast Should Contain    ${ERR_TRAIN_NOT_AVAILABLE_PREFIX}${train_no}${ERR_TRAIN_NOT_AVAILABLE_SUFFIX}
#
## ------------------------------------------------------------------------------
## SEARCH (US4)
## ------------------------------------------------------------------------------
#
#*** Test Cases ***    SEARCH by Train Number (template)
#[Test Template]    T_Search_Train_By_No
#Search existing train                          existing
#Search non-existent train                      nonexistent      99999
#Validate numeric-only input                    invalid          ABC
#
#*** Keywords ***
#T_Search_Train_By_No
#    [Arguments]    ${mode}    ${value}=
#    Run Keyword If    '${mode}'=='existing'    ${tn}=    Ensure Train Exists    10007    SEARCHABLE    FROM1    TO1    22    321
#    Run Keyword If    '${mode}'=='existing'    Open Search By Train No
#    Run Keyword If    '${mode}'=='existing'    Search Train By Number Should Show    ${tn}    ${ANY}    ${ANY}    ${ANY}    ${ANY}    ${ANY}
#    Run Keyword If    '${mode}'=='nonexistent'    Open Search By Train No
#    Run Keyword If    '${mode}'=='nonexistent'    Enter Train No And Click Search    ${value}
#    Run Keyword If    '${mode}'=='nonexistent'    Error Panel Should Contain Not Available    ${value}
#    Run Keyword If    '${mode}'=='invalid'    Open Search By Train No
#    Run Keyword If    '${mode}'=='invalid'    Enter Train No And Click Search    ${value}
#    Run Keyword If    '${mode}'=='invalid'    Inline Error Should Be Visible    ${ERR_TRAIN_NO_NUMERIC}
#
## ------------------------------------------------------------------------------
## VIEW (US5)
## ------------------------------------------------------------------------------
#
#*** Test Cases ***    VIEW list behaviors (template)
#[Test Template]    T_View_List_Behavior
#List has all required columns                 columns
#Update action opens pre-filled form           prefill
#List reflects updated fare                    reflects-update
#List hides deleted train                      reflects-delete
#
#*** Keywords ***
#T_View_List_Behavior
#    [Arguments]    ${mode}
#    Run Keyword If    '${mode}'=='columns'    Open View Trains
#    Run Keyword If    '${mode}'=='columns'    Table Should Have Columns
#    ...    Train Name    Train Number    From Station    To Station    Seats Available    Fare (INR)    Action
#
#    Run Keyword If    '${mode}'=='prefill'    ${tn}=    Ensure Train Exists    10002    PREFILL TRAIN    FROMX    TOY    10    111
#    Run Keyword If    '${mode}'=='prefill'    Open View Trains
#    Run Keyword If    '${mode}'=='prefill'    Click Update For Train    ${tn}
#    Run Keyword If    '${mode}'=='prefill'    Update Form Should Be Prefilled For Train    ${tn}
#
#    Run Keyword If    '${mode}'=='reflects-update'    ${tn}=    Ensure Train Exists    10002    CHANGE ME    A1    B1    15    222
#    Run Keyword If    '${mode}'=='reflects-update'    Open Update Train Details
#    Run Keyword If    '${mode}'=='reflects-update'    Search Train To Edit By Number    ${tn}
#    Run Keyword If    '${mode}'=='reflects-update'    Update Train Fields (Keep No Fixed)    fare=999.00
#    Run Keyword If    '${mode}'=='reflects-update'    Click Button    ${BTN_UPDATE_TRAIN}
#    Run Keyword If    '${mode}'=='reflects-update'    Open View Trains
#    Run Keyword If    '${mode}'=='reflects-update'    Row In View Trains Should Show    ${tn}    ${ANY}    ${ANY}    ${ANY}    ${ANY}    999.00
#
#    Run Keyword If    '${mode}'=='reflects-delete'    ${tn}=    Ensure Train Exists    88888    DELETE VIEW    A    B    5    55
#    Run Keyword If    '${mode}'=='reflects-delete'    Open Delete Train
#    Run Keyword If    '${mode}'=='reflects-delete'    Delete Train By Number With Confirm    ${tn}
#    Run Keyword If    '${mode}'=='reflects-delete'    Open View Trains
#    Run Keyword If    '${mode}'=='reflects-delete'    View Trains Should Not Contain Train Number    ${tn}
