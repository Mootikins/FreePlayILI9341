#!/bin/sh

INPUT=/tmp/menu.sh.$$

vi_editor=${EDITOR-vi}

update ()
{
    git -C /home/pi/Freeplay/freeplayili9341 pull

    sudo cp ~/Freeplay/freeplayili9341/fbcpFilled /usr/local/bin/fbcpFilled
    sudo cp ~/Freeplay/freeplayili9341/fbcpCropped /usr/local/bin/fbcpCropped
    sudo cp ~/Freeplay/freeplayili9341/fbcpZero /usr/local/bin/fbcpZero
    sudo cp ~/Freeplay/freeplayili9341/dispMenuCM3.sh /home/pi/RetroPie/retropiemenu/dispMenu.sh
}
use_dev_cropped ()
{
    sudo sed -i 's|^dtoverlay=waveshare32b|#FP#dtoverlay=waveshare32b|' /boot/config.txt

    sudo service fbcp stop
    sudo systemctl stop fbcpOld.service
    sudo systemctl stop fbcpCropped.service
    sudo systemctl stop fbcpFilled.service
    sudo killall Freeplay-fbcp
    sudo killall fbcpOld
    sudo killall fbcpCropped
    sudo killall fbcpFilled
    
    sleep 1
    
    sudo systemctl enable fbcpCropped.service
    sudo systemctl disable fbcpFilled.service
    sudo systemctl disable fbcpOld.service
    sudo update-rc.d fbcp.sh disable
    
    sleep 1
    sudo systemctl start fbcpCropped
    sleep 2
    sudo reboot
}

use_dev_filled ()
{
    sudo sed -i 's|^dtoverlay=waveshare32b|#FP#dtoverlay=waveshare32b|' /boot/config.txt

    sudo service fbcp stop
    sudo systemctl stop fbcpOld.service
    sudo systemctl fbcpCropped.service stop
    sudo systemctl fbcpFilled.service stop
    sudo killall Freeplay-fbcp
    sudo killall fbcpOld
    sudo killall fbcpCropped
    sudo killall fbcpFilled
    
    sleep 1
    
    sudo systemctl disable fbcpCropped.service
    sudo systemctl enable fbcpFilled.service
    sudo systemctl disable fbcpOld.service
    sudo update-rc.d fbcp.sh disable
    
    sleep 1
    sudo systemctl start fbcpFilled.service
    sleep 2
    sudo reboot
}

use_std ()
{
    sudo sed -i 's|^#FP#dtoverlay=waveshare32b|dtoverlay=waveshare32b|' /boot/config.txt

    sudo service fbcp stop
    sudo systemctl stop fbcpOld.service
    sudo systemctl stop fbcpCropped.service
    sudo systemctl stop fbcpFilled.service
    sudo killall Freeplay-fbcp
    sudo killall fbcpOld
    sudo killall fbcpCropped
    sudo killall fbcpFilled
    
    sleep 1
    
    sudo systemctl disable fbcpCropped.service
    sudo systemctl disable fbcpFilled.service
    sudo systemctl enable fbcpOld.service
    sudo update-rc.d fbcp.sh enable
    
    sleep 1
    sudo service fbcp start
    sleep 2
    sudo reboot
}

dialog --clear --title "LCD Driver Selection" \
--menu "Choose which LCD Driver you would like to use" 15 50 5 \
Default "Default Driver" \
Exp_Cropped "Cropped for the GBA viewport" \
Exp_Filled "Fills the entire display" \
Update "Update binaries and Menu" \
Exit "Exit without any changes" 2>"${INPUT}"

menuitem=$(<"${INPUT}")

case "$menuitem" in
    Default) use_std;;
    Exp_Cropped) use_dev_cropped;;
    Exp_Filled) use_dev_filled;;
    Update) update;;
    Exit) echo "No changes made"; break;;
esac

[ -f "$INPUT" ] && rm "$INPUT"
