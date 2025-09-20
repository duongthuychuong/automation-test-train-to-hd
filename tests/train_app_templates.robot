*** Settings ***
Documentation     Template-driven UI suite (ADD / UPDATE / DELETE / SEARCH / VIEW).
Library           SeleniumLibrary
Library           ../BrowserManager.py
Library           String
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