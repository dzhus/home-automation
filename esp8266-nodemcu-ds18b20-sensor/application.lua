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
  ds18b20.setting({}, 9)
  tmr.create():alarm(1 * 1000, tmr.ALARM_SINGLE,
    function ()
      ds18b20.read(
        function(index, rom, res, temp, temp_dec, par)
          print("Got temperature reading")
          prepare_wifi(string.format("%d.%04d", temp, temp_dec))
        end, {})
    end
  )
end

return module
