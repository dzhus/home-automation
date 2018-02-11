local module = {}
m = nil

local function register_myself()
  m:subscribe(config.TOPIC, 0)
end

local function push_temp(index, rom, res, temp, temp_dec, par)
  m:publish(config.TOPIC, string.format("%d.%02d", temp, temp_dec), 0, 0)
end

local function send_ping()
  ds18b20.read(push_temp, {})
end

local function mqtt_start()
  m = mqtt.Client(config.ID, 120)
  m:connect(config.MQTT_HOST, config.MQTT_PORT, 0, 0, function (con)
              -- register_myself()
              tmr.stop(6)
              tmr.alarm(6, 10000, 1, send_ping)
  end)
end

function module.start()
  ds18b20.setup(4) -- ESP-01 DS18B20 shield
  mqtt_start()
end

return module
