# PowerShell script to update all HTML files with the correct favicon references

# The favicon HTML to insert
$FAVICON_HTML = @"
<!-- Favicon -->
<link rel="icon" type="image/svg+xml" href="img/favicon/favicon.svg">
<link rel="alternate icon" href="img/favicon/favicon.ico">
<link rel="apple-touch-icon" sizes="180x180" href="img/favicon/apple-touch-icon.png">
<link rel="icon" type="image/png" sizes="32x32" href="img/favicon/favicon-32x32.png">
<link rel="icon" type="image/png" sizes="16x16" href="img/favicon/favicon-16x16.png">
<link rel="manifest" href="img/favicon/site.webmanifest">
<link rel="mask-icon" href="img/favicon/safari-pinned-tab.svg" color="#3a7afe">
<meta name="msapplication-TileColor" content="#3a7afe">
<meta name="theme-color" content="#ffffff">
"@

# Get all HTML files excluding already updated ones
$HTML_FILES = Get-ChildItem -Path . -Filter "*.html" | Where-Object { 
    $_.Name -ne "index.html"
}

foreach ($file in $HTML_FILES) {
    Write-Host "Processing $($file.Name)"
    
    # Read the content of the file
    $content = Get-Content -Path $file.FullName -Raw
    
    # Remove old favicon references and comments
    $content = $content -replace '<link rel="shortcut icon"[^>]*>', ''
    $content = $content -replace '<!-- Place favicon\.ico[^>]*-->', ''
    
    # Check if file already has the new favicon
    if ($content -match "favicon\.svg") {
        Write-Host "  $($file.Name) already has the new favicon, updating old references."
        
        # Replace any existing favicon section with our new one
        $startIndex = $content.IndexOf("<!-- Favicon -->")
        if ($startIndex -ge 0) {
            $endIndex = $content.IndexOf("<link rel=", $startIndex + 20)
            $nextTag = $content.IndexOf("<", $endIndex + 10)
            
            if ($startIndex -ge 0 -and $endIndex -ge 0 -and $nextTag -ge 0) {
                $oldFaviconSection = $content.Substring($startIndex, $nextTag - $startIndex)
                $content = $content.Replace($oldFaviconSection, "$FAVICON_HTML`r`n")
            }
        }
    } else {
        # Add the new favicon section after the viewport meta tag
        $content = $content -replace '(<meta name="viewport"[^>]*>)', "`$1`r`n`r`n    $FAVICON_HTML"
    }
    
    # Write the updated content back to the file
    Set-Content -Path $file.FullName -Value $content
    
    Write-Host "  Updated $($file.Name)"
}

Write-Host "Favicon update complete!"