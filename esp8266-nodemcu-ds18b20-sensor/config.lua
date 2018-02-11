local module = {}

module.SSID = "KGB"
module.PWD = "ololo1234567890ololo"

module.MQTT_HOST = "192.168.43.87"
module.MQTT_PORT = 1883

module.ID = node.chipid()
module.TOPIC = "temperature1"

module.SLEEP_S = 10

return module
