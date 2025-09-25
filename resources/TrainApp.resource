*** Settings ***
Library    SeleniumLibrary    timeout=10    implicit_wait=0.5
Library    ../BrowserManager.py
Resource   ../variables/Locators.robot


*** Keywords ***
# =========================
# Session / Auth / Setup
# =========================
Setup And Login
    Open Browser To App
    Ensure Logged In    ${APP_USERNAME}    ${APP_PASSWORD}

Open Browser To App
    [Arguments]    ${role}=admin
    ${base_url}=    Set Variable    ${BASE_URLS}[${role}]
    Open Browser    ${base_url}    ${BROWSER}
    Set Window Size    1920    1080

Go Home
    Go To    ${BASE_URL}

Ensure Logged In
    [Arguments]    ${username}    ${password}
    Go To    ${LOGIN_PAGE_ADMIN}
    Wait Until Element Is Visible    ${LOGIN_USERNAME_FIELD}
    Clear Element Text               ${LOGIN_USERNAME_FIELD}
    Input Text                       ${LOGIN_USERNAME_FIELD}    ${username}
    Clear Element Text               ${LOGIN_PASSWORD_FIELD}
    Input Text                       ${LOGIN_PASSWORD_FIELD}    ${password}
    Click Element                    ${BTN_LOGIN}


# =========================
# Navigation
# =========================
Open Add Train
    Click    ${NAV_ADD_TRAIN}

Open View Trains
    Click    ${NAV_VIEW_TRAINS}

Open Search By Train No
    Click    ${NAV_SEARCH_TRAIN}


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
    Click Button    ${BTN_ADD_TRAIN}
    Wait For Toast Or Inline


# =========================
# SEARCH
# =========================
Enter Train No And Click Search
    [Arguments]    ${train_no}
    Set Field Value    ${FLD_SEARCH_TRAIN_NO}    ${train_no}
    Click Button       ${BTN_SEARCH_TRAIN}
    Wait For Toast Or Inline

Search Train By Number Should Show
    [Arguments]    ${train_no}    ${name}    ${from}    ${to}    ${available}    ${fare}
    Open Search By Train No
    Enter Train No And Click Search    ${train_no}
    Result Panel Should Show           ${train_no}    ${name}    ${from}    ${to}    ${available}    ${fare}

Result Panel Should Show
    [Arguments]    ${train_no}    ${name}    ${from}    ${to}    ${available}    ${fare}
    Wait Until Element Is Visible    ${RESULT_PANEL}

    Run Keyword If    '${train_no}'!='${ANY}'
    ...    Element Text Should Be    ${RESULT_TRAIN_NO}    ${train_no}

    Run Keyword If    '${name}'!='${ANY}'
    ...    Element Text Should Be    ${RESULT_TRAIN_NAME}    ${name}

    Run Keyword If    '${from}'!='${ANY}'
    ...    Element Text Should Be    ${RESULT_FROM}    ${from}

    Run Keyword If    '${to}'!='${ANY}'
    ...    Element Text Should Be    ${RESULT_TO}    ${to}

    Run Keyword If    '${available}'!='${ANY}'
    ...    Element Text Should Be    ${RESULT_SEATS}    ${available}

    # Fare (numeric compare)
    ${fare_text}=    Get Text    ${RESULT_FARE}
    ${fare_clean}=   Replace String Using Regexp    ${fare_text}    [^0-9.]    ${EMPTY}
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

    # Train No
    Run Keyword If    '${train_no}'!='${ANY}'
    ...    Element Should Contain    ${row}    ${train_no}

    # Name
    Run Keyword If    '${name}'!='${ANY}'
    ...    Element Should Contain    ${row}    ${name}

    # From Station
    Run Keyword If    '${from}'!='${ANY}'
    ...    Element Should Contain    ${row}    ${from}

    # To Station
    Run Keyword If    '${to}'!='${ANY}'
    ...    Element Should Contain    ${row}    ${to}

    # Seats (string check)
    Run Keyword If    '${available}'!='${ANY}'
    ...    Element Should Contain    ${row}    ${available}

    # Fare (numeric compare, strips "RS")
    ${fare_text}=     Get Text    ${row}/td[6]
    ${fare_clean}=    Replace String Using Regexp    ${fare_text}    [^0-9.]    ${EMPTY}
    Run Keyword If    '${fare}'!='${ANY}'
    ...    Should Be Equal As Numbers    ${fare_clean}    ${fare}


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


# =========================
# Scenario Template
# =========================
T_Add_Train_Succeeds
    [Arguments]    ${name}    ${from}    ${to}    ${available}    ${fare}
    ${train_no}=    Generate Unique Train Number
    Add Train    ${train_no}    ${name}    ${from}    ${to}    ${available}    ${fare}
    Confirmation Should Contain    ${MSG_ADD_SUCCESS}
    Search Train By Number Should Show
    ...    ${train_no}    ${name}    ${from}    ${to}    ${available}    ${fare}
    Row In View Trains Should Show
    ...    ${train_no}    ${name}    ${from}    ${to}    ${available}    ${fare}
