# Smart home with ESP8266/NodeMCU

## esp8266-nodemcu-ds18b20-sensor

### Configure

See `config.lua`

### Upload to board

    pip install nodemcu-uploader
    cd esp8266-nodemcu-ds18b20-sensor
    nodemcu-uploader --port /dev/tty.SLAB_USBtoUART upload *.lua
