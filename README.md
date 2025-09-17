# Robot Framework Train Admin Suite

This package contains two suites (classic and template-based), shared keywords, and locators for testing a localhost Train Admin web app.

## Structure
```
robot_train_suite/
├── resources/
│   └── TrainApp.resource
├── tests/
│   ├── train_app_tests.robot
│   └── train_app_templates.robot
└── variables/
    └── Locators.robot
```

## Quick Start

```bash
pip install robotframework robotframework-seleniumlibrary webdriver-manager

# visible browser
robot tests/train_app_tests.robot

# template-driven suite
robot tests/train_app_templates.robot

# headless chrome
robot -v HEADLESS:True tests/train_app_tests.robot
```

### Notes
- Update `variables/Locators.robot` to match your DOM (ids, data-testid, etc).
- Base URL defaults to `http://localhost:8080` — change `${APP_BASE_URL}` if needed.
- Messages and copy are parameterized at the bottom of `Locators.robot`.
