*** Settings ***
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
ADD_001 Add a new train with valid data
    [Template]    T_Add_Train_Succeeds
    YAMUNA EXP    GAYA    DELHI    120    550.50

ADD_002 Validation: required fields empty
    [Template]    T_Add_Train_Fails_Name_Required
    GAYA    DELHI    120    550.

ADD_003 Validation: Train Number must be unique
    [Template]    T_Add_Train_Fails_Duplicate_No
    YAMUNA EXP    GAYA    DELHI    120    550.50

ADD_004 Add a new train with available negative data
    [Template]    T_Add_Train_Succeeds_Available_Negative
    YAMUNA EXP    GAYA    DELHI    -50    550.50

ADD_005 Add a new train with fare negative data
    [Template]    T_Add_Train_Succeeds_Fare_Negative
    YAMUNA EXP    GAYA    DELHI    40    -450.50
    
UPD_001 Update via View Trains → Update action
    T_Update_Change_Fare    YAMUNA EXP    GAYA    DELHI    120    550.50    600.00

UPD_002 Update via Update Train Details (search then edit)
    T_Update_Search_And_Modify    YAMUNA EXP    GAYA    DELHI    120    550.50    600.00

UPD_003 Validation: required fields on update
    T_Update_Validation_Required_Fields    YAMUNA EXP    GAYA    DELHI    120    550.50

UPD_004 Validation: positive numbers for seats on update
    T_Update_Validation_Positive_Numbers_For_Seats    YAMUNA EXP    GAYA    DELHI    120    550.50

UPD_005 Validation: positive numbers for fare on update
    T_Update_Validation_Positive_Numbers_For_Fare    YAMUNA EXP    GAYA    DELHI    120    550.50