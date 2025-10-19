*** Settings ***
Resource          ../resources/Auth.resource
Resource          ../resources/TrainApp.resource
Resource          ../variables/Locators.robot
Suite Setup       Setup And Login With Role    ${ROLES}[0]
Suite Teardown    Close All Browsers
Test Setup        Go Home
Test Teardown     No Operation
Force Tags        feature:add    layer:ui
Resource          ../resources/Auth.resource
Resource          ../resources/TrainApp.resource
Resource          ../variables/Locators.robot
Library           String


*** Variables ***
@{ROLES}           user    admin

*** Test Cases ***

REG_001 Register a new user successfully
    [Template]    T_Register_User_Succeeds
    John Doe    toma@gmail.com    toma123    Password123    Password123

REG_002 validation: Required fields empty
    [Template]    T_Register_User_Fails_Required_Fields
    ${EMPTY}   ${EMPTY}    ${EMPTY}    ${EMPTY}     ${EMPTY}

REG_003 validation: Password and Confirm Password do not match
    [Template]    T_Register_User_Fails_Password_Mismatch
    toma Doe    toma@gmail.com    tomadoe123    Pass123    Pass123

REG_004 validation: Username already exists
    [Template]    T_Register_User_Fails_Duplicate_Username
    John Doe    toma@gmail.com    toma123   Password123    Password123

REG_005 validation: Invalid email format
    [Template]    T_Register_User_Fails_Invalid_Email
    John Doe    johndoeexample.com    toma123    Password123    Password123


LOGIN_001 Login with valid credentials
    [Template]    T_Login_Succeeds
    toma123   Password123

LOGIN_002 validation: Incorrect password
    [Template]    T_Login_Fails_Invalid_Password
    toma123   WrongPass

LOGIN_003 Validation: Non-existing username
    [Template]    T_Login_Fails_Non_Existing_User
    unknownuser    Password123

LOGIN_004 Validation: Required fields empty
    [Template]    T_Login_Fails_Required_Fields
    ${EMPTY}    ${EMPTY}


LOGOUT_001 User logs out successfully
    [Template]    T_Logout_Succeeds
    toma123    Password123


PROFILE_001 View profile details successfully
    [Template]    T_View_Profile_Succeeds
    toma123    Password123

PROFILE_002 Edit profile information successfully
    [Template]    T_Edit_Profile_Succeeds
    toma123    Password123    John D.    johndoe_new@example.com    0412345678

PROFILE_003 Validation: Invalid email during profile update
    [Template]    T_Edit_Profile_Fails_Invalid_Email
    toma123    Password123    John D.    johndoemail.com    0412345678


PASS_001 Change password successfully
    [Template]    T_Change_Password_Succeeds
   toma123    Password123    NewPass123    NewPass123

PASS_002 Validation: Old password incorrect
    [Template]    T_Change_Password_Fails_Wrong_Old
    toma123    WrongOld123    NewPass123    NewPass123

PASS_003 Validation: New and confirm password mismatch
    [Template]    T_Change_Password_Fails_Mismatch
    toma123    Password123    NewPass123    NewPass456

PASS_004 Validation: Empty fields
    [Template]    T_Change_Password_Fails_Required_Fields
    toma123    ${EMPTY}    ${EMPTY}    ${EMPTY}




