#!/bin/bash

sudo cp fbcpZero /usr/local/bin
sudo rm /home/pi/RetroPie/retropiemenu/dispMenu.sh
cp dispMenuZero.sh /home/pi/RetroPie/retropiemenu/dispMenu.sh
sudo rm /home/pi/RetroPie/retropiemenu/icons/display.png
cp display.png /home/pi/RetroPie/retropiemenu/icons
sudo cp fbcpZero.service /lib/systemd/system/fbcpZero.service

sudo chmod +x /lib/systemd/system/fbcpZero.service

sudo chown root:root /lib/systemd/system/fbcpZero.service

sudo systemctl disable fbcpZero.service
sudo update-rc.d fbcp.sh enable

sudo sed -i 's|</gameList>|\t<game>\n\t\t<path>./dispMenu.sh</path>\n\t\t<name>FreePlay Change Display Driver</name>\n\t\t<desc>Choose which display driver to use, between two versions of the experimental driver and the default driver</desc>\n\t\t<image>./icons/display.png</image>\n\t\t<playcount>0</playcount>\n\t\t<lastplayed>20180514T205700</lastplayed>\n\t</game>\n</gameList>|' /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml
