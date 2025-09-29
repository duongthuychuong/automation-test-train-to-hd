*** Variables ***
# Base URLs
${BASE_URL}      http://localhost:8083/TrainBook
# Global conveniences
${ANY}                   __ANY__
${PAGE_TITLE}            css=h1, h2, [data-testid="page-title"]

# Navigation (sidebar/links)
${NAV_ADD_TRAIN}         css=a[href*="addtrain"]
${NAV_UPDATE_TRAIN}      css=a[href*="updatetrain"]
${NAV_DELETE_TRAIN}      css=a[href*="cancletrainfwd"]
${NAV_VIEW_TRAINS}       css=a[href*="viewtrain"]
${NAV_SEARCH_TRAIN}      css=a[href*="searchtrain"]

# Add/Update form fields
${FLD_TRAIN_NO}          css=input[name="trainno"]
${FLD_TRAIN_NAME}        css=input[name="trainname"]
${FLD_FROM}              css=input[name="fromstation"]
${FLD_TO}                css=input[name="tostation"]
${FLD_AVAILABLE}         css=input[name="available"]
${FLD_FARE}              css=input[name="fare"]

# Buttons
${BTN_ADD_TRAIN}         css=input[type="submit"][value*="ADD TRAIN"]
${BTN_UPDATE_TRAIN}      css=input[type="submit"][value*="Update Train Schedule"]
${BTN_SEARCH_TRAIN}      css=input[type="submit"][value*="SEARCH TRAIN"]
${BTN_CANCEL_TRAIN}      css=input[type="submit"][value*=" CANCLE TRAIN "]

# Delete/Search inputs
${FLD_DELETE_TRAIN_NO}   css=#deleteTrainNo, [data-testid="delete-train-no"]
${FLD_SEARCH_TRAIN_NO}   css=input[name="trainnumber"]

# Feedback / panels
${TOAST_SUCCESS}         css=.tab .menu
${RESULT_PANEL}          css=div.tab > table
${RESULT_TRAIN_NAME}     xpath=//td[normalize-space(.)="Train Name :"]/following-sibling::td
${RESULT_TRAIN_NO}       xpath=//td[normalize-space(.)="Train Number :"]/following-sibling::td
${RESULT_FROM}           xpath=//td[normalize-space(.)="From Station :"]/following-sibling::td
${RESULT_TO}             xpath=//td[normalize-space(.)="To Station :"]/following-sibling::td
${RESULT_SEATS}          xpath=//td[normalize-space(.)="Available Seats:"]/following-sibling::td
${RESULT_FARE}           xpath=//td[contains(normalize-space(.),"Fare (INR) :")]/following-sibling::td

# Table row fare by train number (general for both views)

# Modal confirm
${BTN_CONFIRM_OK}        css=[data-testid="confirm-ok"], .modal button:contains("OK"), .modal button:contains("Yes")
${BTN_CONFIRM_CANCEL}    css=[data-testid="confirm-cancel"], .modal button:contains("Cancel"), .modal button:contains("No")

# Expected messages
${MSG_ADD_SUCCESS}                     Train Added Successfully!
${MSG_UPDATE_SUCCESS}                  Train Updated Successfully!
${MSG_DELETE_SUCCESS_PATTERN}          Train number {} has been Deleted Successfully
${ERR_TRAIN_NOT_AVAILABLE}             Train No.{} is Not Available !
${ERR_TRAIN_DETAILED_REQUIRED}         Error in filling the train Detail
${ERR_SEARCH_FAILED}                   com.shashi.servlets.AdminSearchTrain_FAILED

# --- Login ---
${LOGIN_PAGE_ADMIN}            http://localhost:8083/TrainBook/AdminLogin.html

# --- Login form ---
${LOGIN_USERNAME_FIELD}       css=input[name="uname"]
${LOGIN_PASSWORD_FIELD}       css=input[name="pword"]
${BTN_LOGIN}                  css=input[type="submit"][value*="LOGIN"]

# Credentials (override on CLI or env-injected)