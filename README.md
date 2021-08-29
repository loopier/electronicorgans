To make the Raspberry run without a display:

1. `sudo vim /boot/config.txt`
2. uncomment line #25
```
# uncomment if hdmi display is not detected and composite is being output
hdmi_force_hotplug=1
```
