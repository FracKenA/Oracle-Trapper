log ("Trap OID " .. trap.oid)

result.notify = NOTIFY.ALWAYS
trapType = trap.fields['.1.3.6.1.4.1.111.15.3.1.1.12.1']

if trapType == "Availability" then
    fullhostname = trap.fields['.1.3.6.1.4.1.111.15.3.1.1.24.1']
    --STRING: "SRV02406.vi.corp"      
    state = trap.fields['.1.3.6.1.4.1.111.15.3.1.1.52.1']
    --STRING: "UP"
    result.message = trap.fields ['.1.3.6.1.4.1.111.15.3.1.1.46.1']
    --STRING: "The pluggable database is up." 
    typeOfDevice = trap.fields ['.1.3.6.1.4.1.111.15.3.1.1.23.1']
    --STRING: "Pluggable Database"        
    result.host = string.match(fullhostname, "(%w+)%.")
    --SRV02406
    oraEM4AlertTargetType = trap.fields['.1.3.6.1.4.1.111.15.3.1.1.21.1']
    -- STRING: "C02146C_SNMP_SPACEDB"     

    if string.match(typeOfDevice, "Database") then
      log("Device is of type: Database")
      service  = "Oracle "..typeOfDevice.." "..oraEM4AlertTargetType
    else
      log("Device is not of type: Database")
      service  = "Oracle "..typeOfDevice
    end

    result.service = service

    if string.match(state, "DOWN") or string.match(state, "ERROR")  then
      log ("State is Critical")
      result.state = STATE.CRITICAL

    elseif string.match(state, "UP") then
      log ("State is UP")
      result.state = STATE.OK

    else
      log("Unknown state. Did not receive DOWN, ERROR or UP. Received: " .. state)
      result.state = STATE.UNKNOWN

    end 
log("Updated Host: " .. result.host .." Service: "  .. result.service .. " and state: " .. result.state)

else
  log ("Skipping trap type: " .. trapType)
end
