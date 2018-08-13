local module = {}

local function push_temp(msg)
  m = mqtt.Client(config.ID, 120)
  m:connect(config.MQTT_HOST, config.MQTT_PORT, 0, 0,
    function (client)
      print("Publishing to MQTT")
      client:publish(config.TOPIC, msg, 0, 0,
        function ()
          print("Sleeping")
          wifi.setmode(wifi.NULLMODE)
          tmr.create():alarm(config.SLEEP_S * 1000, tmr.ALARM_SINGLE,
                             function () node.restart() end)
        end
      )
    end
  )
end

local function prepare_wifi(msg)
  scfg = {}
  scfg.ssid = config.SSID
  scfg.pwd = config.PWD
  scfg.auto = false
  scfg.got_ip_cb = function()
    print("WIFI_STA_GOT_IP")
    push_temp(msg)
  end

  wifi.setmode(wifi.STATION)
  wifi.sta.config(scfg)
  wifi.sta.connect()
end

function module.start()
  print("Application starting")
  ds18b20.setup(4) -- ESP-01 DS18B20 shield
  ds18b20.read(
    function(index, rom, res, temp, temp_dec, par)
      print("Got temperature reading")
      -- Integer NodeMCU firmware
      prepare_wifi(string.format("%d.%04d", temp, temp_dec))
      -- -- Floating point NodeMCU firmware
      -- prepare_wifi(string.format("%f", temp, temp_dec, temp, temp))
    end, {})
end

return module
