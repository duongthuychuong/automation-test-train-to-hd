# TrainApp – Robot Framework UI Test Suite

This repository contains a production‑ready Robot Framework UI test suite for TrainApp. It supports
**role‑aware login** (admin/user) via different base URLs, clean layering (suites → resources → variables),
and parallel execution with `pabot`.

---

## Quick Start

```bash
python -m venv .venv && source .venv/bin/activate      # Windows: .venv\Scripts\activate
pip install -r requirements.txt
```

Export environment (override defaults as needed):
```bash
export ADMIN_BASE_URL=http://localhost:8083/TrainBook/
export USER_BASE_URL=http://localhost:8083/TrainBookUser/
export ADMIN_USERNAME=admin
export ADMIN_PASSWORD=admin123
export USER_USERNAME=user
export USER_PASSWORD=user123
export BROWSER=chrome
export HEADLESS=True
```

Run a suite as **admin**:
```bash
robot --variablefile variables/Env.py --variable ROLE:admin suites/add.robot
```

Run a suite as **user**:
```bash
robot --variablefile variables/Env.py --variable ROLE:user suites/search.robot
```

Run everything in parallel:
```bash
pabot --processes 4 --variablefile variables/Env.py suites
```

Robot will produce `output.xml`, `log.html`, and `report.html` in the project root by default.

---

## Project Structure

```
robot_team_suite/
├─ suites/                    # Test suites (each contributor adds their own suite file here)
│  └─ thuy_chuong_duong.robot # example personal suite file
├─ resources/                 # Reusable keywords & role helpers
│  ├─ TrainApp.resource       # App actions: open, nav, add, update, delete, search, asserts, helpers
│  └─ Auth.resource           # Selects role (admin/user) + logs in using TrainApp keywords
├─ variables/
│  ├─ Env.py                  # Role-aware config (URLs, creds, browser, headless)
│  └─ Locators.robot          # Page locators (selectors) used by keywords
├─ BrowserManager.py          # Optional browser helper used by TrainApp.resource
├─ requirements.txt           # Python dependencies
└─ README.md                  # This file
```
---

## Architecture

### Layered design

- **Suites (`suites/*.robot`)** – define *what* to test for each functional area or contributor.
  Suites import shared resources and typically set the active **role** (admin/user) in `Suite Setup`.
- **Resources (`resources/*.resource`)** – implement *how* to interact with the app.
  - `TrainApp.resource` centralizes browser/session helpers, navigation, form-filling, assertions, and utilities.
  - `Auth.resource` provides role selection and login, reusing keywords from `TrainApp.resource`.
- **Variables (`variables/*`)** – environment, credentials, and selectors.
  - `Env.py` (Python variable file) exposes per‑role base URLs/creds and browser flags.
  - `Locators.robot` keeps selectors out of keyword logic for maintainability.

This separation keeps the core automation stable while allowing each suite to evolve independently.

### Role‑aware execution

`Env.py` defines two base URLs and credential sets. `Auth.resource` exposes:

- `Select Role (Admin/User)` → sets `${BASE_URL}`, `${APP_USERNAME}`, `${APP_PASSWORD}`.
- `Setup And Login With Role` → selects the role, opens the app, and logs in.

Typical suite setup:
```robot
Suite Setup    Setup And Login With Role    ${ROLE}
```

Suites can also **switch roles mid‑test** when workflows cross boundaries (e.g., seed as admin, verify as user).

### Data‑driven templates

`TrainApp.resource` includes the keyword `T_Add_Train_Succeeds` to enable table‑style data rows in suites.

```robot
*** Settings ***
Test Template     T_Add_Train_Succeeds
# ... other imports ...

*** Test Cases ***
Add train — happy path
    TEST EXPRESS    PATNA    DELHI    120    550.50
```

> Tip: Use `Test Template` in `*** Settings ***` (suite‑level) or `[Template]` inside the test (per‑test), not both.

### Robust clicking (optional helpers)

To reduce flakiness with hidden/overlapping elements, use a visibility‑aware click wrapper:

```robot
Click When Visible
    [Arguments]    ${locator}    ${timeout}=10s
    Wait Until Element Is Visible    ${locator}    ${timeout}
    Scroll Element Into View         ${locator}
    Wait Until Element Is Enabled    ${locator}    ${timeout}
    Click Element                    ${locator}
```

You can make your generic `Click` delegate to this helper.

---

## Adding Your Own Suite (per contributor)

Each contributor adds a dedicated suite file under `suites/`. For example, `suites/thuy_chuong_duong.robot`:

```robot
*** Settings ***
Documentation     Personal suite for feature scenarios.
Resource          ../resources/Auth.resource
Resource          ../resources/TrainApp.resource
Resource          ../variables/Locators.robot
Suite Setup       Setup And Login With Role    ${ROLE}
Suite Teardown    Close All Browsers
Test Setup        Go Home
Test Template     T_Add_Train_Succeeds
Force Tags        owner:thuy_chuong_duong

*** Variables ***
${ROLE}           admin

*** Test Cases ***
Add train — happy path
    TEST EXPRESS    PATNA    DELHI    120    550.50
```

Guidelines:
- Keep suites small and cohesive (one area per file).
- Prefer **Test Template** for table‑style inputs.
- Tag suites/tests (e.g., `owner:<name>`, `feature:<area>`) for easy filtering.

---

## Parallel Execution

Parallelize by suites with `pabot`:

```bash
pabot --processes 4 --variablefile variables/Env.py suites
```

---