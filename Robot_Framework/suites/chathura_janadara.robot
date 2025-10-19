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

BOOK_1 Book A Train with valid Data
    [Template]    T_Book_A_Train_With_Valid_Data
    26/10/202   1    545678767876    Chathura    06/28    576

BOOK_2 Book A Train with A Past Date
    [Template]    T_Book_A_Train_With_a_Past_Data
    25/10/2024    1    545678767876    Chathura    06/28    576

BOOK_3 Book A Train with zero seats
    [Template]    T_Book_A_Train_With_Zero_Seats
    26/10/202   0    545678767876    Chathura    06/28    576

BOOK_4 Book A Train with negative seats
    [Template]    T_Book_A_Train_With_Negative_Seats
    26/10/202   -1    545678767876    Chathura    06/28    576

BOOK_5 Book A Train with invalid card number (length < 12)
    [Template]    T_Book_A_Train_With_Invalid_Card_Number
    26/10/202   1    545    Chathura    06/28    576

BOOK_6 Book A Train with invalid card number (length > 19)
    [Template]    T_Book_A_Train_With_Invalid_Card_Number
    26/10/202   1    54567876787656789012    Chathura    06/28    576

BOOK_7 Book A Train with string card number
    [Template]    T_Book_A_Train_With_String_Card_Number
    26/10/202   1    ABCDEFGHIJKLMN    Chathura    06/28    576

BOOK_8 Book A Train with past card expiry date
    [Template]    T_Book_A_Train_With_Past_Card_Expiry_Date
    25/10/2026    1    545678767876    Chathura    06/20    576

BOOK_9 Book A Train with invalid CVV (length < 3)
    [Template]    T_Book_A_Train_With_Invalid_CVV
    26/10/202   1    545678767876    Chathura    06/28    57

BOOK_10 Book A Train with invalid CVV (length > 4)
    [Template]    T_Book_A_Train_With_Invalid_CVV
    26/10/202   1    545678767876    Chathura    06/28    57687777

BOOK_HIST_1 View Booking History
    [Template]    T_View_Booking_History
    26/10/202   1    545678767876    Chathura    06/28    576

NAV_3 Navigation Home From Book A Train
    [Template]    T_Navigation_Home_From_Pages
    ${NAV_VIEW_TRAINS}

NAV_4 Navigation Home From View Booking History
    [Template]    T_Navigation_Home_From_Pages
    ${NAV_BOOKING_HISTORY}

NAV_5 Navigation Home FROM Train Between Stations
    [Template]    T_Navigation_Home_From_Pages
    ${NAV_TRAIN_BETWEEN_STATIONS}
    
NAV_6 Navigation Home From Profile
    [Template]    T_Navigation_Home_From_Pages
    ${NAV_PROFILE}
    
NAV_7 Navigation Home From Search By Train No
    [Template]    T_Navigation_Home_From_Pages
    ${NAV_SEARCH_TRAIN}
    
NAV_8 Navigation Home From Fair Enquiry
    [Template]    T_Navigation_Home_From_Pages
    ${NAV_FAIR_ENQUIRY}
    
NAV_9 Navigation Home From Seat Availability
    [Template]    T_Navigation_Home_From_Pages
    ${NAV_SEAT_AVAILABILITY}