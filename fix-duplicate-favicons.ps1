# PowerShell script to fix duplicate favicon entries

# The clean favicon HTML to insert
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

# Get all HTML files
$HTML_FILES = Get-ChildItem -Path . -Filter "*.html"

foreach ($file in $HTML_FILES) {
    Write-Host "Processing $($file.Name)"
    
    # Read the content of the file
    $content = Get-Content -Path $file.FullName -Raw
    
    # Remove old favicon references
    $content = $content -replace '<link rel="shortcut icon"[^>]*>', ''
    $content = $content -replace '<!-- Place favicon\.ico[^>]*-->', ''
    
    # Find and replace the favicon section
    $pattern = '(?s)(<!-- Favicon -->.*?)(?=<link rel="stylesheet"|<!-- CSS here -->|<style)'
    if ($content -match $pattern) {
        Write-Host "  Found favicon section in $($file.Name), replacing with clean version."
        $content = $content -replace $pattern, "$FAVICON_HTML`r`n`r`n    "
    } else {
        Write-Host "  No favicon section found in $($file.Name), skipping."
        continue
    }
    
    # Write the updated content back to the file
    Set-Content -Path $file.FullName -Value $content
    
    Write-Host "  Updated $($file.Name)"
}

Write-Host "Favicon cleanup complete!" 