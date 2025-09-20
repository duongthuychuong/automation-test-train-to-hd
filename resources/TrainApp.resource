*** Settings ***
Library    SeleniumLibrary    timeout=10    implicit_wait=0.5
Library    ../BrowserManager.py
Resource    ../variables/Locators.robot

*** Keywords ***
Open Browser To App
    ${opts}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Run Keyword If    '${HEADLESS}'=='${True}'    Call Method    ${opts}    add_argument    --headless=new
    Run Keyword If    '${HEADLESS}'=='${True}'    Call Method    ${opts}    add_argument    --window-size=1920,1080
    Open Browser    ${BASE_URL}    ${BROWSER}    options=${opts}
    Maximize Browser Window

Go Home
    Go To    ${BASE_URL}

# ---------- Navigation ----------
Open Add Train
    Click    ${NAV_ADD_TRAIN}

Open Update Train Details
    Click    ${NAV_UPDATE_TRAIN}

Open Delete Train
    Click    ${NAV_DELETE_TRAIN}

Open View Trains
    Click    ${NAV_VIEW_TRAINS}

Open Search By Train No
    Click    ${NAV_SEARCH_TRAIN}

# ---------- Add ----------
Fill Add Train Form
    [Arguments]    ${train_no}    ${name}    ${from}    ${to}    ${available}    ${fare}
    Set Field Value    ${FLD_TRAIN_NO}         ${train_no}
    Set Field Value    ${FLD_TRAIN_NAME}       ${name}
    Set Field Value    ${FLD_FROM}             ${from}
    Set Field Value    ${FLD_TO}               ${to}
    Set Field Value    ${FLD_AVAILABLE}        ${available}
    Set Field Value    ${FLD_FARE}             ${fare}

Add Train
    [Arguments]    ${train_no}    ${name}    ${from}    ${to}    ${available}    ${fare}
    Open Add Train
    Fill Add Train Form    ${train_no}    ${name}    ${from}    ${to}    ${available}    ${fare}
    Click Button    ${BTN_ADD_TRAIN}
    Wait For Toast Or Inline

# ---------- Update ----------
Search Train To Edit By Number
    [Arguments]    ${train_no}
    Set Field Value    ${FLD_SEARCH_TRAIN_NO}    ${train_no}
    Click Button    ${BTN_SEARCH_TRAIN}
    Wait Until Page Contains Element    ${BTN_UPDATE_TRAIN}

Update Train Fields (Keep No Fixed)
    [Arguments]    ${name}=    ${from}=    ${to}=    ${available}=    ${fare}=
    Run Keyword If    '${name}'!=''        Set Field Value    ${FLD_TRAIN_NAME}    ${name}
    Run Keyword If    '${from}'!=''        Set Field Value    ${FLD_FROM}          ${from}
    Run Keyword If    '${to}'!=''          Set Field Value    ${FLD_TO}            ${to}
    Run Keyword If    '${available}'!=''   Set Field Value    ${FLD_AVAILABLE}     ${available}
    Run Keyword If    '${fare}'!=''        Set Field Value    ${FLD_FARE}          ${fare}

# ---------- Delete ----------
Delete Train By Number With Confirm
    [Arguments]    ${train_no}
    Set Field Value    ${FLD_DELETE_TRAIN_NO}    ${train_no}
    Click Button    ${BTN_CANCEL_TRAIN}
    Handle Confirm Dialog    accept

# ---------- Search ----------
Enter Train No And Click Search
    [Arguments]    ${train_no}
    Set Field Value    ${FLD_SEARCH_TRAIN_NO}    ${train_no}
    Click Button    ${BTN_SEARCH_TRAIN}
    Wait For Toast Or Inline

Search Train By Number Should Show
    [Arguments]    ${train_no}    ${name}    ${from}    ${to}    ${available}    ${fare}
    Open Search By Train No
    Enter Train No And Click Search    ${train_no}
    Result Panel Should Show    ${train_no}    ${name}    ${from}    ${to}    ${available}    ${fare}

Search Train Should Show Not Available Message
    [Arguments]    ${train_no}
    Open Search By Train No
    Enter Train No And Click Search    ${train_no}
    Error Panel Should Contain Not Available    ${train_no}

# ---------- View ----------
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

    # Seats (optional string check — could also do numeric like Fare)
    Run Keyword If    '${available}'!='${ANY}'
    ...    Element Should Contain    ${row}    ${available}

    # Fare (numeric compare, strips "RS")
    ${fare_text}=     Get Text    ${row}/td[6]
    ${fare_clean}=    Replace String Using Regexp    ${fare_text}    [^0-9.]    ${EMPTY}
    Run Keyword If    '${fare}'!='${ANY}'
    ...    Should Be Equal As Numbers    ${fare_clean}    ${fare}


View Trains Should Not Contain Train Number
    [Arguments]    ${train_no}
    Open View Trains
    Page Should Not Contain Element    xpath=//table//tr[.//td[normalize-space()='${train_no}']]

Click Update For Train
    [Arguments]    ${train_no}
    Open View Trains
    ${row}=    Locator For Row With Train No    ${train_no}
    Click    xpath=${row}//a[normalize-space()='Update'] | ${row}//button[contains(.,'Update')]

Update Form Should Be Prefilled For Train
    [Arguments]    ${train_no}
    Element Attribute Value Should Be    ${FLD_TRAIN_NO}    value    ${train_no}

Table Should Have Columns
    [Arguments]    @{headers}
    :FOR    ${h}    IN    @{headers}
    \    Page Should Contain Element    xpath=//table//th[normalize-space()='${h}']

# ---------- Assertions / helpers ----------
Confirmation Should Contain
    [Arguments]    ${text}
    Wait Until Page Contains    ${text}

Error Toast Should Contain
    [Arguments]    ${text}
    Wait Until Page Contains    ${text}

Inline Error Should Be Visible
    [Arguments]    ${text}
    Wait Until Page Contains    ${text}

Error Panel Should Contain Not Available
    [Arguments]    ${train_no}
    Wait Until Page Contains    ${ERR_TRAIN_NOT_AVAILABLE_PREFIX}${train_no}${ERR_TRAIN_NOT_AVAILABLE_SUFFIX}

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


Set Field Value
    [Arguments]    ${locator}    ${value}
    Wait Until Element Is Visible    ${locator}
    Clear Element Text    ${locator}
    Input Text    ${locator}    ${value}

Clear And Blur Field
    [Arguments]    ${locator}
    Wait Until Element Is Visible    ${locator}
    Clear Element Text    ${locator}
    # Trigger validation on blur:
    Click    ${PAGE_TITLE}

Click
    [Arguments]    ${locator}
    Wait Until Element Is Visible    ${locator}
    Click Element    ${locator}

Click Button
    [Arguments]    ${locator}
    Click    ${locator}

Wait For Toast Or Inline
    Wait Until Element Is Visible
    ...    ${TOAST_SUCCESS}    timeout=5

Field Should Be Readonly
    [Arguments]    ${locator}
    ${readonly}=    Get Element Attribute    ${locator}    readonly
    ${disabled}=    Get Element Attribute    ${locator}    disabled
    Should Not Be Empty    ${readonly}    msg=Expected readonly attribute on train no field OR disabled
    # Accept either readonly or disabled attribute

Handle Confirm Dialog
    [Arguments]    ${action}=accept
    # If your app uses a custom modal, replace with modal locators below.
    Run Keyword If    '${action}'=='accept'    Click    ${BTN_CONFIRM_OK}
    ...    ELSE    Click    ${BTN_CONFIRM_CANCEL}

Locator For Row With Train No
    [Arguments]    ${train_no}
    [RETURN]    xpath=//table//tr[td[2][normalize-space()='${train_no}']]

Generate Unique Train Number
    ${ts}=    Get Time    epoch
    ${mod}=   Evaluate    int(${ts}) % 89999 + 10001
    [RETURN]    ${mod}

Ensure Train Exists
    [Arguments]    ${train_no}    ${name}    ${from}    ${to}    ${available}    ${fare}
    # Idempotent helper: if not found, create; if found, update to given state.
    Open Search By Train No
    Enter Train No And Click Search    ${train_no}
    ${exists}=    Run Keyword And Return Status    Page Should Contain Element    ${RESULT_PANEL}
    Run Keyword If    not ${exists}    Add Train    ${train_no}    ${name}    ${from}    ${to}    ${available}    ${fare}
    Run Keyword If    ${exists}    Open Update Train Details
    ...               AND    Search Train To Edit By Number    ${train_no}
    ...               AND    Update Train Fields (Keep No Fixed)    ${name}    ${from}    ${to}    ${available}    ${fare}
    ...               AND    Click Button    ${BTN_UPDATE_TRAIN}
    [RETURN]    ${train_no}

Setup And Login
    Open Browser To App
    Ensure Logged In    ${APP_USERNAME}    ${APP_PASSWORD}

Ensure Logged In
    [Arguments]    ${username}    ${password}
    Go To    ${LOGIN_PAGE_ADMIN}
    Wait Until Element Is Visible    ${LOGIN_USERNAME_FIELD}
    Clear Element Text    ${LOGIN_USERNAME_FIELD}
    Input Text            ${LOGIN_USERNAME_FIELD}    ${username}
    Clear Element Text    ${LOGIN_PASSWORD_FIELD}
    Input Text            ${LOGIN_PASSWORD_FIELD}    ${password}
    Click Element         ${BTN_LOGIN}