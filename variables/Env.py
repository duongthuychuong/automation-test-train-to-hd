import os

BROWSER = os.getenv("BROWSER", "chrome")
HEADLESS = os.getenv("HEADLESS", "False").lower() in ("1", "true", "yes", "on")

ADMIN_BASE_URL = os.getenv("ADMIN_BASE_URL", "http://localhost:8083/TrainBook/AdminHome.html")
USER_BASE_URL  = os.getenv("USER_BASE_URL",  "http://localhost:8083/TrainBook/userhome.html")

ADMIN_USERNAME = os.getenv("ADMIN_USERNAME", "admin@demo.com")
ADMIN_PASSWORD = os.getenv("ADMIN_PASSWORD", "admin")
USER_USERNAME  = os.getenv("USER_USERNAME",  "shashi@demo.com")
USER_PASSWORD  = os.getenv("USER_PASSWORD",  "shashi")

BASE_URLS = {"admin": ADMIN_BASE_URL, "user": USER_BASE_URL}
CREDS = {
    "admin": {"username": ADMIN_USERNAME, "password": ADMIN_PASSWORD},
    "user":  {"username": USER_USERNAME,  "password": USER_PASSWORD},
}

ROLE = os.getenv("ROLE", "admin")