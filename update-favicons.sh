#!/bin/bash

# This script updates all HTML files in the directory with the correct favicon references

# The favicon HTML to insert
read -r -d '' FAVICON_HTML << EOM
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
EOM

# Get all HTML files
HTML_FILES=$(find . -maxdepth 1 -name "*.html" ! -name "index.html" ! -name "about.html" ! -name "contact.html")

for file in $HTML_FILES; do
  echo "Processing $file"
  
  # Check if file already has the new favicon
  if grep -q "favicon.svg" "$file"; then
    echo "  $file already has the new favicon, skipping."
    continue
  fi
  
  # Remove old favicon references
  sed -i '/shortcut icon/d' "$file"
  sed -i '/favicon\.ico/d' "$file"
  
  # Add the new favicon section after the viewport meta tag
  sed -i "/<meta name=\"viewport\"/a\\
    \\
    $FAVICON_HTML" "$file"
  
  echo "  Updated $file"
done

echo "Favicon update complete!"