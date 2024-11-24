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

:: Download the resource
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%DOWNLOAD_URL%', 'resource.zip')"

:: Extract the downloaded resource
echo Extracting resource...
powershell -Command "Expand-Archive -Path resource.zip -DestinationPath fivem_resources"

:: Clean up the zip file
del resource.zip

echo Resource installed successfully in fivem_resources\ directory.
