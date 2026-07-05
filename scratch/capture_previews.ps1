# Paths
$workspaceDir = "c:\Users\wsm10\OneDrive\Desktop\genyou page"
$brainDir = "C:\Users\wsm10\.gemini\antigravity\brain\2ec30425-4c32-4a21-a1f8-29dc9d6d641b"
$chromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"

# Read index.html
$html = Get-Content -Encoding utf8 "$workspaceDir\index.html" -Raw

# Extract head (everything from <head> to </head>)
if ($html -match "(?s)(<head>.*?</head>)") {
    $head = $matches[1]
} else {
    Write-Error "Could not find head"
    exit
}

# Append the visibility patch inside the head
$patch = "`n<style>.fade-in-up { opacity: 1 !important; transform: none !important; transition: none !important; }</style>`n"
$headWithPatch = $head.Replace("</head>", "$patch</head>")

# Extract Section 02 (Hero)
if ($html -match "(?s)(<!-- Section 1: Hero -->.*?<!-- Section 2: USP -->)") {
    $sec02 = $matches[1]
} else {
    Write-Error "Could not find Section 02"
    exit
}

# Extract Section 11 (Ingredients)
if ($html -match "(?s)(<!-- Section 9: Ingredients & Clean Beauty -->.*?<!-- Section 10: Clean Formula -->)") {
    $sec11 = $matches[1]
} else {
    Write-Error "Could not find Section 11"
    exit
}

# Write preview HTML files
$preview02Html = "<!DOCTYPE html><html>$headWithPatch<body style='background-color:#1e3214; margin: 0; padding: 0;'>$sec02</body></html>"
$preview11Html = "<!DOCTYPE html><html>$headWithPatch<body style='background-color:#ffffff; margin: 0; padding: 0;'>$sec11</body></html>"

$preview02Html | Out-File -Encoding utf8 "$workspaceDir\scratch\preview_sec02.html"
$preview11Html | Out-File -Encoding utf8 "$workspaceDir\scratch\preview_sec11.html"

# Function to take screenshot
function Capture-Screenshot($file, $outputName, $w, $h) {
    $inputUrl = "file:///$workspaceDir/scratch/$file"
    $outputPath = "$brainDir/$outputName"
    
    $args = @(
        "--headless",
        "--disable-gpu",
        "--screenshot=$outputPath",
        "--window-size=$w,$h",
        "--hide-scrollbars",
        $inputUrl
    )
    
    Start-Process -FilePath $chromePath -ArgumentList $args -Wait
    Write-Host "Screenshot saved to: $outputPath"
}

# Capture Section 02
Capture-Screenshot "preview_sec02.html" "sec02_desktop.png" 1280 800
Capture-Screenshot "preview_sec02.html" "sec02_mobile.png" 375 900

# Capture Section 11
Capture-Screenshot "preview_sec11.html" "sec11_desktop.png" 1280 750
Capture-Screenshot "preview_sec11.html" "sec11_mobile.png" 375 1250

Write-Host "All previews captured successfully!"
