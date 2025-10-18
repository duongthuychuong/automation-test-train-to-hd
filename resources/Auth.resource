*** Settings ***
Library    SeleniumLibrary
Resource   ./TrainApp.resource
Resource   ../variables/Locators.robot
Variables  ../variables/Env.py

*** Keywords ***
Select Role (Admin/User)
    [Arguments]    ${role}
    ${base}=        Set Variable    ${BASE_URLS}[${role}]
    ${username}=    Set Variable    ${CREDS}[${role}][username]
    ${password}=    Set Variable    ${CREDS}[${role}][password]
    Set Suite Variable    ${BASE_URL}       ${base}
    Set Suite Variable    ${APP_USERNAME}   ${username}
    Set Suite Variable    ${APP_PASSWORD}   ${password}

Setup And Login With Role
    Set Selenium Speed    0.1s
    [Arguments]    ${role}=${ROLE}
    Select Role (Admin/User)    ${role}
    Open Browser To App    ${role}
    Ensure Logged In    ${APP_USERNAME}    ${APP_PASSWORD}    ${role}