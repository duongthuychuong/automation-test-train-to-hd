*** Settings ***
Library    SeleniumLibrary    timeout=10    implicit_wait=3
Library    ../BrowserManager.py
Resource   ../variables/Locators.robot

*** Keywords ***
# =========================
# Session / Auth / Setup
# =========================
Setup And Login
    Open Browser To App   ${role}
    Ensure Logged In    ${APP_USERNAME}    ${APP_PASSWORD}   ${role}

Open Browser To App 
    [Arguments]    ${role}
    ${base_url}=    Set Variable    ${BASE_URLS}[${role}]
    Open Browser    ${base_url}    ${BROWSER}
    Set Window Size    1920    1080

Go Home
    Go To    ${BASE_URL}

Ensure Logged In
    [Arguments]    ${username}    ${password}    ${role}
    ${login_page}=    Run Keyword If    '${role}'=='admin'    Set Variable    ${LOGIN_PAGE_ADMIN}    ELSE    Set Variable    ${LOGIN_PAGE_USER}
    Go To    ${login_page}
    Set Field Value    ${LOGIN_USERNAME_FIELD}    ${username}
    Set Field Value    ${LOGIN_PASSWORD_FIELD}    ${password}
    Click             ${BTN_LOGIN}

# Ensure Logged In For User
#     [Arguments]    ${username}    ${password}
#     Go To    ${BASE_URLS}[${role}]
#     Set Field Value    ${LOGIN_USERNAME_FIELD}    ${username}
#     Set Field Value    ${LOGIN_PASSWORD_FIELD}    ${password}
#     Click             ${BTN_LOGIN}    

# =========================
# Navigation
# =========================
Open Add Train
    Click    ${NAV_ADD_TRAIN}

Open View Trains
    Click    ${NAV_VIEW_TRAINS}

Open Search By Train No
    Click    ${NAV_SEARCH_TRAIN}

Open Update Train Details
    Click    ${NAV_UPDATE_TRAIN}

Open Delete Train
    Click    ${NAV_DELETE_TRAIN}

Open Search By Stations
    Click    ${NAV_SEARCH_TRAIN_BET_STTNS}

Open Fare Enquiry
    Click    ${NAV_FARE_ENQUIRY}

Open Train No Search
    Click    ${NAV_TRAIN_NO}

# =========================
# ADD
# =========================
Fill Add Train Form
    [Arguments]    ${train_no}    ${name}    ${from}    ${to}    ${available}    ${fare}
    Set Field Value    ${FLD_TRAIN_NO}    ${train_no}
    Set Field Value    ${FLD_TRAIN_NAME}  ${name}
    Set Field Value    ${FLD_FROM}        ${from}
    Set Field Value    ${FLD_TO}          ${to}
    Set Field Value    ${FLD_AVAILABLE}   ${available}
    Set Field Value    ${FLD_FARE}        ${fare}

Add Train
    [Arguments]    ${train_no}    ${name}    ${from}    ${to}    ${available}    ${fare}
    Open Add Train
    Fill Add Train Form    ${train_no}    ${name}    ${from}    ${to}    ${available}    ${fare}
    Click    ${BTN_ADD_TRAIN}
    Wait For Toast Or Inline

# =========================
# SEARCH
# =========================
Enter Train No And Click Search
    [Arguments]    ${train_no}
    Set Field Value    ${FLD_SEARCH_TRAIN_NO}    ${train_no}
    Click             ${BTN_SEARCH_TRAIN}
    Wait For Toast Or Inline

Search Train By Number Should Show
    [Arguments]    ${train_no}    ${name}    ${from}    ${to}    ${available}    ${fare}
    Open Search By Train No
    Enter Train No And Click Search    ${train_no}
    Result Panel Should Show           ${train_no}    ${name}    ${from}    ${to}    ${available}    ${fare}

Result Panel Should Show
    [Arguments]    ${train_no}    ${name}    ${from}    ${to}    ${available}    ${fare}
    Wait Until Element Is Visible    ${RESULT_PANEL}
    Run Keyword If    '${train_no}'!='${ANY}'    Element Text Should Be    ${RESULT_TRAIN_NO}    ${train_no}
    Run Keyword If    '${name}'!='${ANY}'        Element Text Should Be    ${RESULT_TRAIN_NAME}    ${name}
    Run Keyword If    '${from}'!='${ANY}'        Element Text Should Be    ${RESULT_FROM}    ${from}
    Run Keyword If    '${to}'!='${ANY}'          Element Text Should Be    ${RESULT_TO}    ${to}
    Run Keyword If    '${available}'!='${ANY}'   Element Text Should Be    ${RESULT_SEATS}    ${available}
    ${fare_text}=    Get Text    ${RESULT_FARE}
    ${fare_clean}=    Replace String Using Regexp    ${fare_text}    [^0-9.\-]    ${EMPTY}
    Should Be Equal As Numbers    ${fare_clean}    ${fare}

# =========================
# VIEW
# =========================
Locator For Row With Train No
    [Arguments]    ${train_no}
    [RETURN]    xpath=//table//tr[td[2][normalize-space()='${train_no}']]

Row In View Trains Should Show
    [Arguments]    ${train_no}    ${name}    ${from}    ${to}    ${available}    ${fare}
    Open View Trains
    ${row}=    Locator For Row With Train No    ${train_no}
    Run Keyword If    '${train_no}'!='${ANY}'    Element Should Contain    ${row}    ${train_no}
    Run Keyword If    '${name}'!='${ANY}'        Element Should Contain    ${row}    ${name}
    Run Keyword If    '${from}'!='${ANY}'        Element Should Contain    ${row}    ${from}
    Run Keyword If    '${to}'!='${ANY}'          Element Should Contain    ${row}    ${to}
    Run Keyword If    '${available}'!='${ANY}'   Element Should Contain    ${row}    ${available}
    ${fare_text}=     Get Text    ${row}/td[6]
    ${fare_clean}=    Replace String Using Regexp    ${fare_text}    [^0-9.\-]    ${EMPTY}
    Run Keyword If    '${fare}'!='${ANY}'    Should Be Equal As Numbers    ${fare_clean}    ${fare}

# =========================
# Assertions (generic)
# =========================
Confirmation Should Contain
    [Arguments]    ${text}
    Wait Until Page Contains    ${text}

# =========================
# Helpers / Utilities
# =========================
Set Field Value
    [Arguments]    ${locator}    ${value}
    Wait Until Element Is Visible    ${locator}
    Clear Element Text               ${locator}
    Input Text                       ${locator}    ${value}

Click
    [Arguments]    ${locator}
    Wait Until Element Is Visible    ${locator}
    Click Element                    ${locator}

Wait For Toast Or Inline
    Wait Until Element Is Visible    ${TOAST_SUCCESS}    timeout=5

Generate Unique Train Number
    ${ts}=    Get Time    epoch
    ${mod}=   Evaluate    int(${ts}) % 89999 + 10001
    [RETURN]    ${mod}

Update Train Fare
    [Arguments]    ${row}    ${new_fare}
    Click    ${row}//a[contains(.,'Update')]
    Set Field Value    ${FLD_FARE}    ${new_fare}
    Click    ${BTN_UPDATE_TRAIN}
    Wait For Toast Or Inline

Delete Train By Number
    [Arguments]    ${train_no}
    Open Delete Train
    Set Field Value    ${FLD_TRAIN_NO}    ${train_no}
    Click             ${BTN_CANCEL_TRAIN}
    ${expected_message}=    Format String    ${MSG_DELETE_SUCCESS_PATTERN}    ${train_no}
    Confirmation Should Contain    ${expected_message}
# =========================
# Scenario Templates
# =========================
T_Search_Train_Using_Stations_1stRun
    [Arguments]    ${from}    ${to}
    Sleep    5s
    Open Search By Stations
    Set Field Value    ${FLD_FROM}    ${from}
    Set Field Value    ${FLD_TO}      ${to}
    Click   ${BTN_SEARCH_TRAIN}
    Run Keyword If    '${from}'!='${ANY}'        Page Should Contain    ${from}
    Run Keyword If    '${to}'!='${ANY}'          Page Should Contain    ${to}

T_Search_Train_Using_Stations
    [Arguments]    ${from}    ${to}
    Open Search By Stations
    Set Field Value    ${FLD_FROM}    ${from}
    Set Field Value    ${FLD_TO}      ${to}
    Click   ${BTN_SEARCH_TRAIN}
    Run Keyword If    '${from}'!='${ANY}'        Page Should Contain    ${from}
    Run Keyword If    '${to}'!='${ANY}'          Page Should Contain    ${to}

T_Search_Train_Using_Stations_woCheck
    [Arguments]    ${from}    ${to}
    Open Search By Stations
    Set Field Value    ${FLD_FROM}    ${from}
    Set Field Value    ${FLD_TO}      ${to}
    Click   ${BTN_SEARCH_TRAIN}

T_Search_Train_Not_Available
    [Arguments]    ${from}    ${to}
    Open Search By Stations
    Set Field Value    ${FLD_FROM}    ${from}
    Set Field Value    ${FLD_TO}      ${to}
    Click   ${BTN_SEARCH_TRAIN}
    Page Should Contain    There are no trains Between XYZ and ABC

T_Search_Train_with_Blank_Fields
    Open Search By Stations
    Click   ${BTN_SEARCH_TRAIN}
    Page Should Contain    Trains BetWeen Station 

T_Add_Train_Succeeds
    [Arguments]    ${name}    ${from}    ${to}    ${available}    ${fare}
    ${train_no}=    Generate Unique Train Number
    Add Train    ${train_no}    ${name}    ${from}    ${to}    ${available}    ${fare}
    Confirmation Should Contain    ${MSG_ADD_SUCCESS}
    Search Train By Number Should Show    ${train_no}    ${name}    ${from}    ${to}    ${available}    ${fare}
    Row In View Trains Should Show       ${train_no}    ${name}    ${from}    ${to}    ${available}    ${fare}

T_Add_Train_Fails_Name_Required
    [Arguments]    ${from}    ${to}    ${available}    ${fare}
    ${train_no}=    Generate Unique Train Number
    Add Train    ${train_no}    ${EMPTY}    ${from}    ${to}    ${available}    ${fare}
    Confirmation Should Contain    ${ERR_TRAIN_DETAILED_REQUIRED}

T_Add_Train_Fails_Duplicate_No
    [Arguments]    ${name}    ${from}    ${to}    ${available}    ${fare}
    ${train_no}=    Generate Unique Train Number
    Add Train    ${train_no}    ${name}    ${from}    ${to}    ${available}    ${fare}
    Add Train    ${train_no}    ${name}    ${from}    ${to}    ${available}    ${fare}
    Confirmation Should Contain    ${ERR_TRAIN_DETAILED_REQUIRED}

T_Add_Train_Succeeds_Available_Negative
    [Arguments]    ${name}    ${from}    ${to}    ${available}    ${fare}
    ${train_no}=    Generate Unique Train Number
    Add Train    ${train_no}    ${name}    ${from}    ${to}    ${available}    ${fare}
    Confirmation Should Contain    ${MSG_ADD_SUCCESS}
    Search Train By Number Should Show    ${train_no}    ${name}    ${from}    ${to}    ${available}    ${fare}
    Row In View Trains Should Show       ${train_no}    ${name}    ${from}    ${to}    ${available}    ${fare}

T_Add_Train_Succeeds_Fare_Negative
    [Arguments]    ${name}    ${from}    ${to}    ${available}    ${fare}
    ${train_no}=    Generate Unique Train Number
    Add Train    ${train_no}    ${name}    ${from}    ${to}    ${available}    ${fare}
    Confirmation Should Contain    ${MSG_ADD_SUCCESS}
    Search Train By Number Should Show    ${train_no}    ${name}    ${from}    ${to}    ${available}    ${fare}
    Row In View Trains Should Show       ${train_no}    ${name}    ${from}    ${to}    ${available}    ${fare}

T_Update_Change_Fare
    [Arguments]    ${name}    ${from}    ${to}    ${available}    ${fare}    ${new_fare}
    ${train_no}=    Generate Unique Train Number
    Add Train    ${train_no}    ${name}    ${from}    ${to}    ${available}    ${fare}
    Open View Trains
    ${row}=    Locator For Row With Train No    ${train_no}
    Update Train Fare    ${row}    ${new_fare}
    Confirmation Should Contain    ${MSG_UPDATE_SUCCESS}
    Row In View Trains Should Show   ${train_no}    ${ANY}    ${ANY}    ${ANY}    ${ANY}    ${new_fare}

T_Update_Search_And_Modify
    [Arguments]    ${name}    ${from}    ${to}    ${available}    ${fare}    ${new_fare}
    ${train_no}=    Generate Unique Train Number
    Add Train    ${train_no}    ${name}    ${from}    ${to}    ${available}    ${fare}
    Open Update Train Details
    Enter Train No And Click Search    ${train_no}
    Set Field Value    ${FLD_FARE}    ${new_fare}
    Click    ${BTN_UPDATE_TRAIN}
    Confirmation Should Contain    ${MSG_UPDATE_SUCCESS}
    Row In View Trains Should Show   ${train_no}    ${ANY}    ${ANY}    ${ANY}    ${ANY}    ${new_fare}

T_Update_Validation_Required_Fields
    [Arguments]    ${name}    ${from}    ${to}    ${available}    ${fare}
    ${train_no}=    Generate Unique Train Number
    Add Train    ${train_no}    ${name}    ${from}    ${to}    ${available}    ${fare}
    Open Update Train Details
    Enter Train No And Click Search    ${train_no}
    Set Field Value    ${FLD_TRAIN_NAME}    ${EMPTY}
    Click    ${BTN_UPDATE_TRAIN}
    Confirmation Should Contain    ${ERR_TRAIN_DETAILED_REQUIRED}

T_Update_Validation_Positive_Numbers_For_Seats
    [Arguments]    ${name}    ${from}    ${to}    ${available}    ${fare}
    ${train_no}=    Generate Unique Train Number
    Add Train    ${train_no}    ${name}    ${from}    ${to}    ${available}    ${fare}
    Open Update Train Details
    Enter Train No And Click Search    ${train_no}
    Set Field Value    ${FLD_AVAILABLE}    -50
    Click    ${BTN_UPDATE_TRAIN}
    Row In View Trains Should Show   ${train_no}    ${ANY}    ${ANY}    ${ANY}    -50    ${ANY}

T_Update_Validation_Positive_Numbers_For_Fare
    [Arguments]    ${name}    ${from}    ${to}    ${available}    ${fare}
    ${train_no}=    Generate Unique Train Number
    Add Train    ${train_no}    ${name}    ${from}    ${to}    ${available}    ${fare}
    Open Update Train Details
    Enter Train No And Click Search    ${train_no}
    ${new_fare}=    Set Variable    -420.0
    Set Field Value    ${FLD_FARE}    ${new_fare}
    Click    ${BTN_UPDATE_TRAIN}
    Row In View Trains Should Show   ${train_no}    ${ANY}    ${ANY}    ${ANY}    ${ANY}    ${new_fare}

T_Delete_Train_Succeeds
    [Arguments]    ${name}    ${from}    ${to}    ${available}    ${fare}
    ${train_no}=    Generate Unique Train Number
    Add Train    ${train_no}    ${name}    ${from}    ${to}    ${available}    ${fare}
    Open Delete Train
    Set Field Value    ${FLD_TRAIN_NO}    ${train_no}
    Click             ${BTN_CANCEL_TRAIN}
    ${expected_message}=    Format String    ${MSG_DELETE_SUCCESS_PATTERN}    ${train_no}
    Confirmation Should Contain    ${expected_message}

T_Delete_Train_Fails_Not_Exist
    [Arguments]    ${train_no}
    Open Delete Train
    Set Field Value    ${FLD_TRAIN_NO}    ${train_no}
    Click             ${BTN_CANCEL_TRAIN}
    ${expected_message}=    Format String    ${ERR_TRAIN_NOT_AVAILABLE}    ${train_no}
    Confirmation Should Contain    ${expected_message}

T_Search_Train_Succeeds
    [Arguments]    ${name}    ${from}    ${to}    ${available}    ${fare}
    ${train_no}=    Generate Unique Train Number
    Add Train    ${train_no}    ${name}    ${from}    ${to}    ${available}    ${fare}
    Search Train By Number Should Show    ${train_no}    ${name}    ${from}    ${to}    ${available}    ${fare}

T_Search_Train_Fails_Not_Exist
    [Arguments]    ${train_no}
    Open Search By Train No
    Enter Train No And Click Search    ${train_no}
    ${expected_message}=    Format String    ${ERR_TRAIN_NOT_AVAILABLE}    ${train_no}
    Confirmation Should Contain    ${expected_message}

T_Search_Train_Fails_Empty_Train_No
    [Arguments]    ${train_no}
    Open Search By Train No
    Enter Train No And Click Search    ${train_no}
    ${expected_message}=    Format String    ${ERR_TRAIN_NOT_AVAILABLE}    ${train_no}
    Confirmation Should Contain    ${expected_message}

T_Search_Train_Fails_Invalid_Train_No
    [Arguments]    ${train_no}
    Open Search By Train No
    Set Field Value    ${FLD_SEARCH_TRAIN_NO}    ${train_no}
    Click             ${BTN_SEARCH_TRAIN}
    Confirmation Should Contain    ${ERR_SEARCH_FAILED}

T_View_Train_Shows_Added_Train
    [Arguments]    ${name}    ${from}    ${to}    ${available}    ${fare}
    ${train_no}=    Generate Unique Train Number
    Add Train    ${train_no}    ${name}    ${from}    ${to}    ${available}    ${fare}
    Row In View Trains Should Show    ${train_no}    ${name}    ${from}    ${to}    ${available}    ${fare}

T_View_Train_List_Shows_Required_Columns
    [Arguments]    ${name}    ${from}    ${to}    ${available}    ${fare}
    ${train_no}=    Generate Unique Train Number
    Add Train    ${train_no}    ${name}    ${from}    ${to}    ${available}    ${fare}
    Open View Trains
    Page Should Contain    Train Name
    Page Should Contain    Train Number
    Page Should Contain    From
    Page Should Contain    To
    Page Should Contain    Seats Available
    Page Should Contain    Fare (INR)
    Page Should Contain    Action

T_View_Train_Update_Action_Opens_Pre_Filled_Form
    [Arguments]    ${name}    ${from}    ${to}    ${available}    ${fare}
    ${train_no}=    Generate Unique Train Number
    Add Train    ${train_no}    ${name}    ${from}    ${to}    ${available}    ${fare}
    Open View Trains
    ${row}=    Locator For Row With Train No    ${train_no}
    Click    ${row}//a[contains(.,'Update')]
    Wait Until Element Is Visible    ${FLD_TRAIN_NO}
    Element Attribute Value Should Be    ${FLD_TRAIN_NO}    value    ${train_no}
    Element Attribute Value Should Be    ${FLD_TRAIN_NAME}    value    ${name}

T_View_Train_List_Reflects_Update_Changes
    [Arguments]    ${name}    ${from}    ${to}    ${available}    ${fare}    ${new_fare}
    ${train_no}=    Generate Unique Train Number
    Add Train    ${train_no}    ${name}    ${from}    ${to}    ${available}    ${fare}
    Open View Trains
    ${row}=    Locator For Row With Train No    ${train_no}
    Update Train Fare    ${row}    ${new_fare}
    Row In View Trains Should Show    ${train_no}    ${ANY}    ${ANY}    ${ANY}    ${ANY}    ${new_fare}

T_View_Train_List_Reflects_Deletion
    [Arguments]    ${name}    ${from}    ${to}    ${available}    ${fare}
    ${train_no}=    Generate Unique Train Number
    Add Train    ${train_no}    ${name}    ${from}    ${to}    ${available}    ${fare}
    Delete Train By Number    ${train_no}
    Open View Trains
    ${row}=    Locator For Row With Train No    ${train_no}
    Element Should Not Be Visible    ${row}