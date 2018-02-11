local module = {}

local function push_temp(client)
  ds18b20.read(
    function(index, rom, res, temp, temp_dec, par)
      client:publish(
        config.TOPIC, string.format("%d.%02d", temp, temp_dec), 0, 0,
        function ()
          node.dsleep(config.SLEEP_S * 1000 * 1000)
        end)
    end, {})
end

local function mqtt_start()
  m = mqtt.Client(config.ID, 120)
  m:connect(config.MQTT_HOST, config.MQTT_PORT, 0, 0, function (client)
              push_temp(client)
  end)
end

function module.start()
  ds18b20.setup(4) -- ESP-01 DS18B20 shield
  mqtt_start()
end

return module
