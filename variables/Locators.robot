*** Variables ***
# Base URL
${APP_BASE_URL}          http://localhost:8083/TrainBook/AdminHome.html

# Global conveniences
${ANY}                   __ANY__        # sentinel meaning "don't assert this value exactly"
${PAGE_TITLE}            css=h1, h2, [data-testid="page-title"]

# Navigation (sidebar/links)
${NAV_ADD_TRAIN}         css=a[href="addtrainfwd"]
${NAV_UPDATE_TRAIN}      css=[data-testid="nav-update-train"], a[href*="update-train"]
${NAV_DELETE_TRAIN}      css=[data-testid="nav-delete-train"], a[href*="delete-train"]
${NAV_VIEW_TRAINS}       css=a[href="adminviewtrainfwd"]
${NAV_SEARCH_TRAIN}      css=a[href="adminsearchtrainfwd"]

# Add/Update form fields (adjust to your DOM)
${FLD_TRAIN_NO}      css=input[name="trainno"]
${FLD_TRAIN_NAME}    css=input[name="trainname"]
${FLD_FROM}          css=input[name="fromstation"]
${FLD_TO}            css=input[name="tostation"]
${FLD_AVAILABLE}     css=input[name="available"]
${FLD_FARE}          css=input[name="fare"]

# Buttons
${BTN_ADD_TRAIN}         css=input[type="submit"][value*="ADD TRAIN"]
${BTN_UPDATE_TRAIN}      css=[data-testid="btn-update-train"], button:contains("Update Train Schedule")
${BTN_SEARCH_TRAIN}      css=input[type="submit"][value*="SEARCH TRAIN"]
${BTN_CANCEL_TRAIN}      css=[data-testid="btn-cancel-train"], button:contains("Cancel Train")

# Delete/Search inputs
${FLD_DELETE_TRAIN_NO}   css=#deleteTrainNo, [data-testid="delete-train-no"]
${FLD_SEARCH_TRAIN_NO}   css=input[name="trainnumber"]

# Feedback / panels
${TOAST_SUCCESS}    css=.tab .menu
${INLINE_ERROR}          css=.error, .invalid-feedback, [aria-invalid="true"]
${RESULT_PANEL}          css=div.tab > table
${RESULT_TRAIN_NAME}     xpath=//td[normalize-space(.)="Train Name :"]/following-sibling::td
${RESULT_TRAIN_NO}       xpath=//td[normalize-space(.)="Train Number :"]/following-sibling::td
${RESULT_FROM}           xpath=//td[normalize-space(.)="From Station :"]/following-sibling::td
${RESULT_TO}             xpath=//td[normalize-space(.)="To Station :"]/following-sibling::td
${RESULT_SEATS}          xpath=//td[normalize-space(.)="Available Seats:"]/following-sibling::td
${RESULT_FARE}           xpath=//td[contains(normalize-space(.),"Fare (INR) :")]/following-sibling::td

# Modal confirm (if using a custom modal)
${BTN_CONFIRM_OK}        css=[data-testid="confirm-ok"], .modal button:contains("OK"), .modal button:contains("Yes")
${BTN_CONFIRM_CANCEL}    css=[data-testid="confirm-cancel"], .modal button:contains("Cancel"), .modal button:contains("No")

# Expected messages (tune to your app copy)
${MSG_ADD_SUCCESS}                     Train Added Successfully!
${MSG_UPDATE_SUCCESS}                  updated successfully
${MSG_DELETE_SUCCESS_PREFIX}           Train number 
${MSG_DELETE_SUCCESS_SUFFIX}           has been Deleted Successfully
${ERR_TRAIN_NO_EXISTS}                 Train Number already exists
${ERR_AVAILABLE_POSITIVE}              Available must be a positive number
${ERR_FARE_POSITIVE}                   Fare must be a positive number
${ERR_TRAIN_NAME_REQUIRED}             Train Name is required
${ERR_TRAIN_NOT_AVAILABLE_PREFIX}      Train No. 
${ERR_TRAIN_NOT_AVAILABLE_SUFFIX}      is Not Available !
${ERR_TRAIN_NO_NUMERIC}                Train Number must be numeric

# --- Login ---
${LOGIN_PAGE_ADMIN}            http://localhost:8083/TrainBook/AdminLogin.html

# --- Login form (matches your HTML) ---
${LOGIN_USERNAME_FIELD}       css=input[name="uname"]
${LOGIN_PASSWORD_FIELD}       css=input[name="pword"]
${BTN_LOGIN}                  css=input[type="submit"][value*="LOGIN"]

# Credentials (override on CLI or env-injected)
${APP_USERNAME}             admin@demo.com
${APP_PASSWORD}             admin
