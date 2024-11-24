@echo off
:: Set colors for better visual appeal
:: Use ANSI Escape Sequences for color (Works in newer versions of Windows 10 and above)
for /f "delims=" %%A in ('"echo prompt $E ^| cmd"') do set "ESC=%%A"

:: Define colors (using ANSI color codes)
set GREEN=%ESC%[32m
set YELLOW=%ESC%[33m
set BLUE=%ESC%[34m
set RESET=%ESC%[0m
set RED=%ESC%[31m

:: Display a clean welcome message with color
echo %BLUE%====================================
echo Welcome to SwiftPeakHosting Installer
echo ====================================
echo.

:: Prompt for License Key with better user interaction
set /p LICENSE_KEY=%GREEN%Please enter your SwiftPeakHosting License Key:%RESET% 
if "%LICENSE_KEY%"=="" (
    echo %RED%License Key is required. Exiting.%RESET%
    exit /b 1
)

:: Display progress message and start authentication
echo %YELLOW%Authenticating license key...%RESET%

:: API URL and authentication details
set API_URL=https://store.swiftpeakhosting.co.uk/api/v1/
set BEARER_TOKEN=nMfCZLeeGTDUpdPckjNnnAVGt7DOmfWfgibjePJLEGzN8Cl3Buy78D9JXJYT
:: Send POST request using PowerShell with Bearer Token for authentication
for /f "delims=" %%i in ('powershell -Command "(Invoke-RestMethod -Uri '%API_URL%' -Method Post -Headers @{Authorization='Bearer %BEARER_TOKEN%'} -Body '{\"license\": \"%LICENSE_KEY%\"}' -ContentType 'application/json').download_url"') do set DOWNLOAD_URL=%%i

:: Check if we have a valid download URL
if "%DOWNLOAD_URL%"=="" (
    echo %RED%Error: Authentication failed or invalid license key.%RESET%
    exit /b 1
)

:: Confirmation that the license is valid
echo %GREEN%License authenticated successfully.%RESET%
echo %YELLOW%Downloading the resource...%RESET%

:: Define destination folder for the resource
set RESOURCE_DIR=resources\custom\basic_hello

:: Ensure the directory exists before attempting to download or extract files
if not exist "%RESOURCE_DIR%" (
    mkdir "%RESOURCE_DIR%"
    echo %YELLOW%Created missing folder: %RESOURCE_DIR%%RESET%
)

:: Download the resource from the new URL with progress indicator
echo %BLUE%Downloading resource from:%RESET% %DOWNLOAD_URL%
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%DOWNLOAD_URL%', 'basic_hello.zip')"

:: Check if the ZIP file was downloaded successfully
if not exist basic_hello.zip (
    echo %RED%Error: Failed to download the resource.%RESET%
    exit /b 1
)

:: Extract the downloaded resource
echo %BLUE%Extracting resource to %RESOURCE_DIR%...%RESET%
powershell -Command "Expand-Archive -Path basic_hello.zip -DestinationPath '%RESOURCE_DIR%'"

:: Clean up the zip file
del basic_hello.zip

:: Verify if the resource folder exists after extraction
if not exist "%RESOURCE_DIR%" (
    echo %RED%Error: Failed to extract the resource.%RESET%
    exit /b 1
)

:: Final success message
echo.
echo %GREEN%Resource installed successfully in %RESOURCE_DIR% directory.%RESET%
echo %YELLOW%Please ensure this resource is added to your server.cfg file.%RESET%
echo.

pause
exit /b 0
