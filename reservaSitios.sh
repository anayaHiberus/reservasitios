#!/bin/bash
# Automatic reservation script
# Made by Abel Naya

# Requires Python with venv

############# Configuration #############

# fill DNI, or PASSPORT
DNI=$DNI
PASSPORT=$PASSPORT

# folder with the driver (download from https://www.selenium.dev/documentation/webdriver/getting_started/install_drivers/#quick-reference )
DRIVER_FOLDER=.

# if True, the browser will be shown
DEBUG=False

# command to run if an error occurs
ON_ERROR="exit 1"

############# End Configuration #############





trap "$ON_ERROR" SIGINT


# init
echo
echo "========== $(date) : autoReservasSitios automatic run =========="

FOLDER=$(mktemp -d)
cd $FOLDER
echo "Running from temporal folder: $FOLDER"

# configure
echo "[SCRIPT] preparing..."
python -m venv venv
source venv/bin/activate
pip install selenium

# run
echo "[SCRIPT] running..."
python <<EOF || eval "$ON_ERROR"

import os


from selenium import webdriver
from selenium.common import WebDriverException
from selenium.webdriver.chrome.options import Options as ChromeOptions
from selenium.webdriver.edge.options import Options as EdgeOptions
from selenium.webdriver.firefox.options import Options as FirefoxOptions
from selenium.webdriver.safari.options import Options as SafariOptions
from selenium.common.exceptions import NoSuchElementException
from selenium.webdriver.common.by import By

print("Configuring...")
os.environ["PATH"] += os.pathsep + "$DRIVER_FOLDER"

driver = None
for try_driver, try_options in (
        (webdriver.Chrome, ChromeOptions),
        (webdriver.Firefox, FirefoxOptions),
        (webdriver.Edge, EdgeOptions),
        (webdriver.Safari, SafariOptions),
):
    try:
        options = try_options()
        if not $DEBUG: options.add_argument('-headless')
        driver = try_driver(options=options)
        print("Using driver", driver)
        break
    except WebDriverException:
        pass  # try next
if driver is None:
    raise WebDriverException("Can't launch any browser, are the drivers installed?")

with driver:
    driver.implicitly_wait(30)

    print("Navigating...")
    driver.get("https://reservasitios.demohiberus.com/present?dni=${DNI:-$PASSPORT}")

    print("Sending...")
    if not "$DNI":
        driver.find_element(By.ID, 'mat-select-0').click()
        driver.find_element(By.ID, 'mat-option-2').click()


    for x in range(10): # loop max 10 times
        print("(click)")
        driver.find_element(By.CLASS_NAME, 'c-login-layout__container__card__form__button').click()
        try: # sometimes clicking the button does nothing, need to click again
            driver.implicitly_wait(5)
            driver.find_element(By.CLASS_NAME, 'overlay')
            break
        except NoSuchElementException: continue
    driver.implicitly_wait(60)

    print("Checking...")
    try: driver.find_element(By.TAG_NAME, 'app-has-been-presented')
    except NoSuchElementException: raise Exception("Didn't work")

print("OK")

EOF

# cleanup
echo "[SCRIPT] cleaning..."
deactivate
cd /tmp
rm -rf $FOLDER

echo "[SCRIPT] ...done"
echo "========== $(date) : autoReservasSitios end =========="
echo
