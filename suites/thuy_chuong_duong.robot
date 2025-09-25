*** Settings ***
Documentation     Add flows owned by Member A. Uses data-driven template.
Resource          ../resources/Auth.resource
Resource          ../resources/TrainApp.resource
Resource          ../variables/Locators.robot
Suite Setup       Setup And Login With Role    ${ROLE}
Suite Teardown    Close All Browsers
Test Setup        Go Home
Test Teardown     No Operation
Force Tags        feature:add    layer:ui
Resource          ../resources/Auth.resource
Resource          ../resources/TrainApp.resource
Resource          ../variables/Locators.robot
Library           String


*** Variables ***
${ROLE}           admin

*** Test Cases ***
Add train — happy path
    [Template]    T_Add_Train_Succeeds
    TEST EXPRESS    PATNA    DELHI    120    550.50
