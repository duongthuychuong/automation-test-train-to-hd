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
${ROLE}           user

*** Test Cases ***
SRH_001 Search valid route
    # Seach for trains between HOWRAH and JODHPUR (valid route)
    [Template]    T_Search_Train_Using_Stations_1stRun
    HOWRAH    JODHPUR

SRH_002 No trains found
    # Search for trains between XYZ and ABC (invalid route)
    [Template]    T_Search_Train_Not_Available
    XYZ    ABC

SRH_003 Blank fields for search
    # Search with blank fields
    Open Search By Stations
    Click   ${BTN_SEARCH_TRAIN}
    Page Should Contain    Trains BetWeen Station 

SRH_004 Case-insensitive search
    # Search for trains between gAyA and DelHi (case-insensitive)
    [Template]    T_Search_Train_Using_Stations
    gAyA    DelHi

SRH_005 Special characters
    # Search for trains between @@@ and %### (special characters)
    [Template]    T_Search_Train_Using_Stations_woCheck
    @@@    %###
    [Teardown]    Page Should Contain    There are no trains Between @@@ and %###

ENQ_001 Valid enquiry 1
    # Search for train between PATNA and DELHI (valid route)
    [Template]    T_Search_Train_Using_Stations
    PATNA    DELHI
    
ENQ_002 Valid enquiry 2
    # Search for train between SEALDAH and AJMER (valid route)
    [Template]    T_Search_Train_Using_Stations
    SEALDAH    AJMER

ENQ_003 Invalid enquiry
    # Search for train between SEALDAH and AJMEER (invalid route)
    [Template]    T_Search_Train_Using_Stations_woCheck
    SEALDAH    AJMEER
    [Teardown]    Page Should Contain    There are no trains Between SEALDAH and AJMEER

ENQ_004 Invalid station input
    # Search for train between 1234 and @@@@ (invalid station names)
    [Template]    T_Search_Train_Using_Stations_woCheck
    1234    @@@@    
    [Teardown]    Page Should Contain    There are no trains Between 1234 and @@@@

VIEW_001 View all available trains
    # View all available trains
    Open View Trains
    Page Should Contain    Running Trains

VIEW_002 Check detail of trains 1
    # Check details of a specific train to Gaya
    Open View Trains
    Click Element    xpath=//tr/td/a[normalize-space(text())="NILANCHAL EXP"]
    Page Should Contain    GAYA

VIEW_002 Check detail of trains 2
    # Check details of a specific train to Mumbai
    Open View Trains
    Click Element    xpath=//tr/td/a[normalize-space(text())="MUMBAI MAIL"]
    Page Should Contain    MUMBAI

FARE_001 Blank fields for fare search
    # Use blank fields for fare search
    Open Fare Enquiry
    Click   ${BTN_CHECK_FARE}
    Page Should Contain    JODHPUR EXP
    Page Should Contain    YAMUNA EXP
    Page Should Contain    NILANCHAL EXP

FARE_002 Specific train
    # Search fare between PATNA and DELHI
    Open Fare Enquiry
    Set Field Value    ${FLD_FROM}    PATNA
    Set Field Value    ${FLD_TO}      DELHI
    Click   ${BTN_CHECK_FARE}
    Page Should Contain    	1450.75 RS

FARE_003 Case-insensitive fare search
    # Search fare between gAyA and DelHi (case-insensitive)
    Open Fare Enquiry
    Set Field Value    ${FLD_FROM}    gAyA
    Set Field Value    ${FLD_TO}      DelHi
    Click   ${BTN_CHECK_FARE}
    Page Should Contain    	GAYA

FARE_004 Search by departing station
    # Search fare by only departing station GAYA
    Open Fare Enquiry
    Set Field Value    ${FLD_FROM}    GAYA
    Click   ${BTN_CHECK_FARE}
    Page Should Contain    	550.5 RS

FARE_005 Missing fields
    # Use blank fields for fare search
    Open Fare Enquiry
    Click   ${BTN_CHECK_FARE}
    Page Should Contain    JODHPUR EXP
    Page Should Contain    YAMUNA EXP
    Page Should Contain    NILANCHAL EXP
    Page Should Contain    AJMER-SEALDAH EXP

TRN_001 View valid train timing
    # Search for train between PATNA and DELHI using Train number(valid route)
    Open Train No Search
    Set Field Value    ${FLD_TRAINNO_SEARCH}    10007
    Click   ${BTN_SEARCH_TRAINNO}
    Page Should Contain    AJMER-SEALDAH EXP

TRN_002 Invalid TrainNo
    # Search using invalid Train number(not available)
    Open Train No Search
    Set Field Value    ${FLD_TRAINNO_SEARCH}    00000
    Click   ${BTN_SEARCH_TRAINNO}
    Page Should Contain    Train No.00000 is Not Available !

TRN_003 Find by Train Name
    # Search using Train Name in Train No Search
    Open Train No Search
    Set Field Value    ${FLD_TRAINNO_SEARCH}    JODHPUR EXP
    Click   ${BTN_SEARCH_TRAINNO}
    Page Should Contain    ORA-01722: invalid number

TRN_004 Invalid character
    # Search using special characters in Train No Search
    Open Train No Search
    Set Field Value    ${FLD_TRAINNO_SEARCH}    @@!!
    Click   ${BTN_SEARCH_TRAINNO}
    Page Should Contain    ORA-01722: invalid number
