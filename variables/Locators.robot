*** Variables ***
# Base URL
${APP_BASE_URL}          http://localhost:8083/TrainBook

# Global conveniences
${ANY}                   __ANY__        # sentinel meaning "don't assert this value exactly"
${PAGE_TITLE}            css=h1, h2, [data-testid="page-title"]

# Navigation (sidebar/links)
${NAV_ADD_TRAIN}         css=[data-testid="nav-add-train"], a[href*="add-train"]
${NAV_UPDATE_TRAIN}      css=[data-testid="nav-update-train"], a[href*="update-train"]
${NAV_DELETE_TRAIN}      css=[data-testid="nav-delete-train"], a[href*="delete-train"]
${NAV_VIEW_TRAINS}       css=[data-testid="nav-view-trains"], a[href*="view-trains"]
${NAV_SEARCH_TRAIN}      css=[data-testid="nav-search-train"], a[href*="search-train"]

# Add/Update form fields (adjust to your DOM)
${FLD_TRAIN_NO}          css=#trainNo, [name="trainNo"], [data-testid="train-no"]
${FLD_TRAIN_NAME}        css=#trainName, [name="trainName"], [data-testid="train-name"]
${FLD_FROM}              css=#fromStation, [name="from"], [data-testid="from-station"]
${FLD_TO}                css=#toStation, [name="to"], [data-testid="to-station"]
${FLD_AVAILABLE}         css=#available, [name="available"], [data-testid="available"]
${FLD_FARE}              css=#fare, [name="fare"], [data-testid="fare"]

# Buttons
${BTN_ADD_TRAIN}         css=[data-testid="btn-add-train"], button:contains("Add Train")
${BTN_UPDATE_TRAIN}      css=[data-testid="btn-update-train"], button:contains("Update Train Schedule")
${BTN_SEARCH_TRAIN}      css=[data-testid="btn-search-train"], button:contains("Search Train")
${BTN_CANCEL_TRAIN}      css=[data-testid="btn-cancel-train"], button:contains("Cancel Train")

# Delete/Search inputs
${FLD_DELETE_TRAIN_NO}   css=#deleteTrainNo, [data-testid="delete-train-no"]
${FLD_SEARCH_TRAIN_NO}   css=#searchTrainNo, [data-testid="search-train-no"]

# Feedback / panels
${TOAST_SUCCESS}         css=.toast.success, [data-testid="toast-success"]
${TOAST_ERROR}           css=.toast.error, [data-testid="toast-error"]
${INLINE_ERROR}          css=.error, .invalid-feedback, [aria-invalid="true"]
${RESULT_PANEL}          css=[data-testid="train-detail"], .result-panel

# Modal confirm (if using a custom modal)
${BTN_CONFIRM_OK}        css=[data-testid="confirm-ok"], .modal button:contains("OK"), .modal button:contains("Yes")
${BTN_CONFIRM_CANCEL}    css=[data-testid="confirm-cancel"], .modal button:contains("Cancel"), .modal button:contains("No")

# Expected messages (tune to your app copy)
${MSG_ADD_SUCCESS}                     added successfully
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
${LOGIN_PAGE_ADMIN}            ${APP_BASE_URL}/AdminLogin.html

# --- Login form (matches your HTML) ---
${LOGIN_USERNAME_FIELD}       css=input[name="uname"]
${LOGIN_PASSWORD_FIELD}       css=input[name="pword"]
${BTN_LOGIN}                  css=input[type="submit"][value*="LOGIN"]

# Credentials (override on CLI or env-injected)
${APP_USERNAME}             admin@demo.com
${APP_PASSWORD}             admin
