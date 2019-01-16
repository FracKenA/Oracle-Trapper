require(“socket”)

function getHostNaMeOfAddress(ipaddress)

   local https = require(“ssl.https”)
   op5server = "localhost"
   username = "administrator"
   password = "administrator"

   local body, code, headers, status = https.request("https://"..username..":"..password.."@"..op5server.."/api/filter/query?query=%5Bhosts%5Daddress%3D%22"..ipaddress.."%22&columns=name")

   --log (body)
   name = string.match(body, “%name\“:\“(%w+)%\“”)

   if (name == nil) then
      name = "DefaultHostName"
      log ("Could not get the hostname of ipaddress " .. ipaddress)
   end

   return name; 
end
function encodeURI(str)
		if (str) then
			str = string.gsub (str, "\n", "\r\n")
			str = string.gsub (str, "([^%w ])",
				function (c) return string.format ("%%%02X", string.byte(c)) end)
			str = string.gsub (str, " ", "+")
	   end
	   return str
	end

function createServiceIfNotExist(hostname,service)
	-- body

	hostname = encodeURI(hostname)
	service = encodeURI(service)

	url = "https://172.27.105.54/api/status/service/"..hostname..";"+service+""
	--replace " " with "%20"
end

log ("Trap OID " .. trap.oid)

result.notify = NOTIFY.ALWAYS
trapType = trap.fields['.1.3.6.1.4.1.111.15.3.1.1.12.1']

if trapType = "Availability" then
	ipaddress = trap.fields['.1.3.6.1.4.1.111.15.3.1.1.24.1']
    state = trap.fields['.1.3.6.1.4.1.111.15.3.1.1.52.1']
    
    result.message = trap.fields ['.1.3.6.1.4.1.111.15.3.1.1.46.1']
    typeOfDevice = ["1.3.6.1.4.1.111.15.3.1.1.23.1"]
    --result.host = getHostNaMeOfAddress(ipaddress)
    result.host = "Test Host"

    if string.match(typeOfDevice, "Database") then
    	service  = "Oracle "..trap.fields['.1.3.6.1.4.1.111.15.3.1.1.23.1'].." "..trap.fields['.1.3.6.1.4.1.111.15.3.1.1.21.1']
    	--createServiceIfNotExist(service) -- if 404 on service, create it. else do nothing.
    	--service = "Oracle Database Instance C02146C_SNMP" OR service = “Oracle Pluggable Database C02146C_SNMP_SPACEDB”
    else
    	service  = "Oracle "..trap.fields['.1.3.6.1.4.1.111.15.3.1.1.23.1']
    	--service = “Oracle Host”
        --service = “Oracle Agent”
        --service = “Oracle Listener”
    end
    trap.service = service

    if string.match(state, "DOWN") or string.match(state, "ERROR")  then
    	result.state = STATE.CRITICAL

    elseif string.match(state, "UP") then
    	result.state = STATE.OK

    else
    	log("Unknown state. Did not receive DOWN, ERROR or UP. Received: " .. state)
    	result.state = STATE.UNKNOWN

    end	
log("Updated Host: " .. result.host .." Service/name: "  .. result.service .. " and state: " .. result.state)

else
	log ("Skipping trap type: " .. typeOfTrap)
end
end
