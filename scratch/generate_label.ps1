Add-Type -AssemblyName System.Drawing

$width = 650
$height = 950

$bmp = New-Object System.Drawing.Bitmap($width, $height)
$g = [System.Drawing.Graphics]::FromImage($bmp)

# Set high-quality rendering
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic

# Fill background with a very light cream/white color
$brushBg = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 255, 255))
$g.FillRectangle($brushBg, 0, 0, $width, $height)

# Draw subtle outer border matching the landing page aesthetics
$penBorder = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(220, 225, 210), 2)
$g.DrawRectangle($penBorder, 10, 10, $width - 20, $height - 20)

$paddingX = 35
$paddingY = 40
$currentY = $paddingY
$usableWidth = $width - ($paddingX * 2)

# Use clean system fonts (Malgun Gothic)
$fontFamily = "Malgun Gothic"
$fontHeader = New-Object System.Drawing.Font($fontFamily, 11, [System.Drawing.FontStyle]::Bold)
$fontTitle = New-Object System.Drawing.Font($fontFamily, 14, [System.Drawing.FontStyle]::Bold)
$fontSub = New-Object System.Drawing.Font($fontFamily, 11)
$fontBodyBold = New-Object System.Drawing.Font($fontFamily, 11, [System.Drawing.FontStyle]::Bold)
$fontBody = New-Object System.Drawing.Font($fontFamily, 10.5)
$fontSmall = New-Object System.Drawing.Font($fontFamily, 9.5)

# Color palette matching olive brand style
$colorMutedGreen = [System.Drawing.Color]::FromArgb(101, 141, 27) # Brand color (--main)
$colorDark = [System.Drawing.Color]::FromArgb(51, 65, 42) # Dark green-gray (--text)
$colorGray = [System.Drawing.Color]::FromArgb(110, 110, 110)

$brushBrand = New-Object System.Drawing.SolidBrush($colorMutedGreen)
$brushText = New-Object System.Drawing.SolidBrush($colorDark)
$brushMuted = New-Object System.Drawing.SolidBrush($colorGray)

function Draw-Text($text, $font, $brush, $y, $spacingAfter) {
    $rect = New-Object System.Drawing.RectangleF($paddingX, $y, $usableWidth, 1000)
    $format = New-Object System.Drawing.StringFormat
    # Use exact word wrapping
    $size = $g.MeasureString($text, $font, [System.Drawing.SizeF]::new($usableWidth, 1000), $format)
    $g.DrawString($text, $font, $brush, $rect, $format)
    return $y + $size.Height + $spacingAfter
}

function Draw-Line($y, $spacingAfter) {
    $penLine = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(230, 235, 220), 1)
    $g.DrawLine($penLine, $paddingX, $y, $paddingX + $usableWidth, $y)
    return $y + $spacingAfter
}

# 1. Header (Functionality)
$currentY = Draw-Text "미백/주름개선 2중 기능성화장품" $fontHeader $brushBrand $currentY 8

# 2. Product Name
$currentY = Draw-Text "제품명 : 젠유 올리브 글로우 부스터`nGenYou Olive Glow Booster" $fontTitle $brushText $currentY 10

# 3. Volume
$currentY = Draw-Text "용량 : 100mL / 3.38fl.oz." $fontSub $brushMuted $currentY 16

$currentY = Draw-Line $currentY 16

# 4. Ingredients
$currentY = Draw-Text "전성분" $fontBodyBold $brushText $currentY 6
$ingredientsText = "올리브수(78.9%), 부틸렌글라이콜, 카프릴릭/카프릭트라이글리세라이드, 1,2-헥산다이올, 글리세레스-26, 나이아신아마이드, 베타인, 소듐클로라이드, 정제수, 비타민나무열매오일, 잇꽃씨오일, 올리브오일, 아보카도오일, 로즈힙열매오일, 라벤더오일, 카프릴하이드록사믹애씨드, 카프릴릴글라이콜, 아데노신, 일랑일랑꽃오일, 다이소듐이디티에이, 다이포타슘글리시리제이트, 스페인감초뿌리추출물, 병풀추출물, 마데카소사이드, 아시아티코사이드, 녹차추출물, 호장근뿌리추출물, 황금추출물, 마트리카리아꽃추출물, 아시아틱애씨드, 마데카식애씨드, 로즈마리잎추출물, 해바라기씨오일, 뽕나무잎추출물, 리날룰, 벤질벤조에이트, 벤질살리실레이트, 파네솔"
$currentY = Draw-Text $ingredientsText $fontSmall $brushText $currentY 16

$currentY = Draw-Line $currentY 16

# 5. Efficacy
$currentY = Draw-Text "효능∙효과" $fontBodyBold $brushText $currentY 6
$currentY = Draw-Text "피부의 미백에 도움을 준다. 피부의 주름개선에 도움을 준다." $fontBody $brushText $currentY 16

# 6. Usage
$currentY = Draw-Text "용법∙용량" $fontBodyBold $brushText $currentY 6
$currentY = Draw-Text "본 품 적당량을 취해 피부에 골고루 펴 바른다." $fontBody $brushText $currentY 16

# 7. Cautions
$currentY = Draw-Text "사용할 때의 주의사항" $fontBodyBold $brushText $currentY 8
$caution1 = "1. 화장품 사용 시 또는 사용 후 직사광선에 의하여 사용부위가 붉은 반점, 부어오름 또는 가려움증 등의 이상 증상이나 부작용이 있는 경우에는 전문의 등과 상담할 것."
$caution2 = "2. 상처가 있는 부위 등에는 사용을 자제할 것."
$caution3 = "3. 보관 및 취급 시 주의사항`n   1) 어린이의 손이 닿지 않는 곳에 보관할 것.`n   2) 직사광선을 피해서 보관할 것."

$currentY = Draw-Text $caution1 $fontSmall $brushText $currentY 6
$currentY = Draw-Text $caution2 $fontSmall $brushText $currentY 6
$currentY = Draw-Text $caution3 $fontSmall $brushText $currentY 10

# Now crop the bitmap to the actual used height to avoid extra whitespace at the bottom
$actualHeight = [int]($currentY + $paddingY)
# Ensure we don't exceed the original height
if ($actualHeight -lt $height) {
    $croppedBmp = New-Object System.Drawing.Bitmap($width, $actualHeight)
    $croppedG = [System.Drawing.Graphics]::FromImage($croppedBmp)
    $croppedG.DrawImage($bmp, 0, 0, (New-Object System.Drawing.Rectangle(0, 0, $width, $actualHeight)), [System.Drawing.GraphicsUnit]::Pixel)
    
    # Redraw bottom border
    $croppedG.DrawRectangle($penBorder, 10, 10, $width - 20, $actualHeight - 20)
    
    $croppedBmp.Save("c:\Users\wsm10\OneDrive\Desktop\genyou page\ingredients_label.png", [System.Drawing.Imaging.ImageFormat]::Png)
    $croppedG.Dispose()
    $croppedBmp.Dispose()
    Write-Host "Label generated with dynamic height: $actualHeight px"
} else {
    $bmp.Save("c:\Users\wsm10\OneDrive\Desktop\genyou page\ingredients_label.png", [System.Drawing.Imaging.ImageFormat]::Png)
    Write-Host "Label generated with full height: $height px"
}

# Clean up resources
$g.Dispose()
$bmp.Dispose()
