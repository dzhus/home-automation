local module = {}

local function wifi_wait_ip_and_start()
  if wifi.sta.getip() == nil then
    print("Waiting for IP")
  else
    tmr.stop(1)
    print("\n====================================")
    print("ESP8266 mode is: " .. wifi.getmode())
    print("MAC address is: " .. wifi.ap.getmac())
    print("IP is " .. wifi.sta.getip())
    print("====================================")
    app.start()
  end
end

local function wifi_start()
  scfg = {}
  scfg.ssid = config.SSID
  scfg.pwd = config.PWD
  wifi.sta.config(scfg)
  wifi.sta.connect()
  tmr.alarm(1, 2500, 1, wifi_wait_ip_and_start)
end

function module.start()
  wifi_start()
end

return module
