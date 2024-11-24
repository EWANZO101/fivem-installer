@echo off
:: Display welcome message
echo ====================================
echo Welcome to SwiftPeakHosting Installer
echo ====================================

:: Prompt for License Key
set /p LICENSE_KEY="Please enter your SwiftPeakHosting License Key: "
if "%LICENSE_KEY%"=="" (
    echo License Key is required. Exiting.
    exit /b 1
)

:: API URL and authentication
set API_URL=https://store.swiftpeakhosting.co.uk/admin/api-v1/licenses/public/download
echo Authenticating license key...

:: Send POST request using PowerShell to get download URL
for /f "delims=" %%i in ('powershell -Command "(Invoke-RestMethod -Uri '%API_URL%' -Method Post -Body '{\"license\": \"%LICENSE_KEY%\"}' -ContentType 'application/json').download_url"') do set DOWNLOAD_URL=%%i

:: Check if we have a valid download URL
if "%DOWNLOAD_URL%"=="" (
    echo Error: Authentication failed or invalid license key.
    exit /b 1
)

echo License authenticated successfully. Downloading the resource...

:: Define destination folder for the resource
set RESOURCE_DIR=resources\[custom]\basic_hello

:: Download the resource
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%DOWNLOAD_URL%', 'basic_hello.zip')"

:: Check if the ZIP file was downloaded successfully
if not exist basic_hello.zip (
    echo Error: Failed to download the resource.
    exit /b 1
)

:: Extract the downloaded resource
echo Extracting resource...
powershell -Command "Expand-Archive -Path basic_hello.zip -DestinationPath %RESOURCE_DIR%"

:: Clean up the zip file
del basic_hello.zip

:: Verify if the resource folder exists
if not exist %RESOURCE_DIR% (
    echo Error: Failed to extract the resource.
    exit /b 1
)

echo Resource installed successfully in %RESOURCE_DIR% directory.
echo Please ensure this resource is added to your server.cfg file.
pause
