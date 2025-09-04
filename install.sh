#!/usr/bin/env bash

currentuser=$(users | awk '{print $1}')

function run-in-user-session() {
    _display_id=":$(find /tmp/.X11-unix/* | sed 's#/tmp/.X11-unix/X##' | head -n 1)"
    _username=$(who | grep "($_display_id)" | awk '{print $1}')
    _user_id=$(id -u "$_username")
    _environment=("DISPLAY=$_display_id" "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$_user_id/bus")
    sudo -Hu "$_username" env "${_environment[@]}" "$@"
}

function get-perl() {
echo -e '\033[1;33mInstalling \033[1;34mPerl\033[0m'
apt-get -y -qq install perl >/dev/null
apt-get -y -qq install libnet-ssleay-perl >/dev/null
apt-get -y -qq install libauthen-pam-perl >/dev/null
apt-get -y -qq install libio-pty-perl >/dev/null
}

function get-samba() {
echo -e '\033[1;33mInstalling \033[1;34mSMB File Sharing\033[0m'
apt-get -y -qq install samba --install-recommends >/dev/null
apt-get -y -qq install samba-common-bin >/dev/null
apt-get -y -qq install samba-dsdb-modules >/dev/null
apt-get -y -qq install samba-libs >/dev/null
apt-get -y -qq install samba-vfs-modules >/dev/null
apt-get -y -qq install smbclient >/dev/null
apt-get -y -qq install autofs >/dev/null
apt-get -y -qq install cifs-utils >/dev/null
apt-get -y -qq install caja-share >/dev/null
apt-get -y -qq install libsmbclient >/dev/null
apt-get -y -qq install libwbclient0 >/dev/null
apt-get -y -qq install winbind >/dev/null
apt-get -y -qq install libnss-winbind >/dev/null
mkdir -p /etc/samba
cp -f files/smb.conf /etc/samba
touch /etc/libuser.conf
chmod 0777 -Rf /var/lib/samba/usershares
files=$(ls -1 /var/lib/samba/usershares)
if [ "$files" != """" ]; then
  rm -f /var/lib/samba/usershares/*
fi
run-in-user-session net usershare add Shared_Media /mnt/shared_media "Media Centre" Everyone:F guest_ok=y
}

function get-kodi() {
clear
echo -e '\033[1;33mInstalling \033[1;34mKODI Media Centre\033[0m'
flatpak install -y --noninteractive flathub tv.kodi.Kodi
echo '[Seat:*]'>/etc/lightdm/lightdm.conf
echo 'autologin-guest=false'>>/etc/lightdm/lightdm.conf
echo 'autologin-user='$currentuser>>/etc/lightdm/lightdm.conf
echo 'autologin-user-timeout=0'>>/etc/lightdm/lightdm.conf
echo '[SeatDefaults]'>/etc/lightdm/lightdm.conf.d/70-linuxmint.conf
echo 'user-session=cinnamon'>>/etc/lightdm/lightdm.conf.d/70-linuxmint.conf
echo 'session-setup-script=/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=kodi tv.kodi.Kodi --standalone'>>/etc/lightdm/lightdm.conf.d/70-linuxmint.conf

## Keymap settings...
mkdir -p /home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/
touch /home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
echo -e '<keymap>'>/home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
echo -e '  <global>'>>/home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
echo -e '    <keyboard>'>>/home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
echo -e '      <b>noop</b>'>>/home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
echo -e '      <backslash>noop</backslash>'>>/home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
echo -e '      <d>noop</d>'>>/home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
echo -e '      <e>noop</e>'>>/home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
echo -e '      <equals>noop</equals>'>>/home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
echo -e '      <g>noop</g>'>>/home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
echo -e '      <h>noop</h>'>>/home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
echo -e '      <k>noop</k>'>>/home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
echo -e '      <minus>noop</minus>'>>/home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
echo -e '      <numpadminus>noop</numpadminus>'>>/home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
echo -e '      <numpadplus>noop</numpadplus>'>>/home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
echo -e '      <t>noop</t>'>>/home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
echo -e '      <tab>noop</tab>'>>/home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
echo -e '      <plus>noop</plus>'>>/home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
echo -e '      <v>noop</v>'>>/home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
echo -e '      <volume_mute>noop</volume_mute>'>>/home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
echo -e '      <volume_down>noop</volume_down>'>>/home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
echo -e '      <volume_up>noop</volume_up>'>>/home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
echo -e '      <y>noop</y>'>>/home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
echo -e '    </keyboard>'>>/home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
echo -e '  </global>'>>/home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
echo -e '</keymap>'>>/home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
}

function get-php() {
clear
echo -e '\033[1;33mInstalling \033[1;34mApache\033[0m'
apt-get -y -qq install apache2 >/dev/null
echo -e '\033[1;33mInstalling \033[1;34mPHP 7.4\033[0m'
add-apt-repository -y ppa:ondrej/php
apt-get -y -qq update >/dev/null
apt-get -y -qq upgrade >/dev/null
apt-get -y -qq install php7.4 >/dev/null
apt-get -y -qq install php7.4-cli >/dev/null
apt-get -y -qq install php7.4-json >/dev/null
apt-get -y -qq install php7.4-common >/dev/null
apt-get -y -qq install php7.4-mysql >/dev/null
apt-get -y -qq install php7.4-zip >/dev/null
apt-get -y -qq install php7.4-gd >/dev/null
apt-get -y -qq install php7.4-mbstring >/dev/null
apt-get -y -qq install php7.4-curl >/dev/null
apt-get -y -qq install php7.4-xml >/dev/null
apt-get -y -qq install php7.4-bcmath >/dev/null
apt-get -y -qq install php7.4-opcache >/dev/null
apt-get -y -qq install php7.4-fpm >/dev/null
apt-get -y -qq install php7.4-intl >/dev/null
apt-get -y -qq install php7.4-simplexml >/dev/null
apt-get -y -qq install php7.4-bz2 >/dev/null
apt-get -y -qq install php7.4-cgi >/dev/null
apt-get -y -qq install libapache2-mod-php7.4 >/dev/null
a2enmod php7.4
update-alternatives --set php /usr/bin/php7.4
update-alternatives --set phar /usr/bin/phar7.4
update-alternatives --set phar.phar /usr/bin/phar.phar7.4
chmod -Rf 0777 /var/www/html
rm -r -f /var/www/html/*
unzip -o -q files/navphp4.45.zip -d/var/www/html
echo -e 'php_value upload_max_filesize 4.0G'>/var/www/html/.htaccess
echo -e 'php_value post_max_size 4.2G'>>/var/www/html/.htaccess
echo -e 'php_value memory_limit -1'>>/var/www/html/.htaccess
sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
sed -i 's/Restart=on-abort/Restart=always/g' /lib/systemd/system/apache2.service
systemctl -q enable apache2
}

function get-krusader() {
clear
echo -e '\033[1;33mInstalling \033[1;34mKrusader Twin File Browser\033[0m'
apt-get -y -qq install krusader >/dev/null
apt-get -y -qq install libc6 >/dev/null
apt-get -y -qq install libgcc1 >/dev/null
apt-get -y -qq install zlib1g >/dev/null
apt-get -y -qq install libgcc1 >/dev/null
apt-get -y -qq install cpio >/dev/null
apt-get -y -qq install konsole >/dev/null
apt-get -y -qq install okteta >/dev/null
apt-get -y -qq install rpm >/dev/null
echo -e '\033[1;33mInstalling \033[1;34mKrusader Twin File Browser\033[1;36m - Tools\033[0m'
apt-get -y -qq install kdiff3 >/dev/null
apt-get -y -qq install kget >/dev/null
apt-get -y -qq install kompare >/dev/null
apt-get -y -qq install krename >/dev/null
apt-get -y -qq install md5deep >/dev/null
apt-get -y -qq install kmail >/dev/null
echo -e '\033[1;33mInstalling \033[1;34mKrusader Twin File Browser\033[1;36m - Archivers\033[0m'
apt-get -y -qq install arj >/dev/null
apt-get -y -qq install ark >/dev/null
apt-get -y -qq install bzip2 >/dev/null
apt-get -y -qq install lhasa >/dev/null
apt-get -y -qq install p7zip >/dev/null
apt-get -y -qq install rar >/dev/null
apt-get -y -qq install unace >/dev/null
apt-get -y -qq install unrar >/dev/null
apt-get -y -qq install unzip >/dev/null
apt-get -y -qq install zip >/dev/null
cp -f /usr/share/applications/org.kde.krusader.desktop /home/$currentuser/Desktop
sed -i "s/Exec=krusader -qwindowtitle %c %u/Exec=krusader -qwindowtitle %c %u --left='\/media\/$currentuser\/' --right='\/mnt\/shared_media\/'/g" /home/$currentuser/Desktop/org.kde.krusader.desktop
}

function get-games() {
echo -e '\033[1;33mInstalling \033[1;34mBackgammon Game\033[0m'
apt-get -y -qq install gnubg >/dev/null
echo -e '\033[1;33mInstalling \033[1;34mMahjongg Game\033[0m'
apt-get -y -qq install gnome-mahjongg >/dev/null
## Create Shortcuts
mkdir -p /home/$currentuser/Desktop/Games
cp -f /usr/share/applications/gnubg.desktop /home/$currentuser/Desktop/Games
cp -f /usr/share/applications/org.gnome.Mahjongg.desktop /home/$currentuser/Desktop/Games
}

function get-conky() {
echo -e '\033[1;33mInstalling \033[1;34mConky\033[0m'
apt-get -y -qq install conky-all >/dev/null
cp -f files/conky.conf /home/$currentuser/.conkyrc
echo -e '[Desktop Entry]'>/home/$currentuser/.config/autostart/conky.desktop
echo -e 'Type=Application'>>/home/$currentuser/.config/autostart/conky.desktop
echo -e 'Exec=/usr/bin/conky -d'>>/home/$currentuser/.config/autostart/conky.desktop
echo -e 'X-GNOME-Autostart-enabled=true'>>/home/$currentuser/.config/autostart/conky.desktop
echo -e 'NoDisplay=false'>>/home/$currentuser/.config/autostart/conky.desktop
echo -e 'Hidden=false'>>/home/$currentuser/.config/autostart/conky.desktop
echo -e 'Name[en_AU]=Conky'>>/home/$currentuser/.config/autostart/conky.desktop
echo -e 'Comment[en_AU]=System information tool'>>/home/$currentuser/.config/autostart/conky.desktop
echo -e 'X-GNOME-Autostart-Delay=5'>>/home/$currentuser/.config/autostart/conky.desktop
## HDSentinel
wget -qO /tmp/hdsentinel.zip https://www.hdsentinel.com/hdslin/hdsentinel-020c-x64.zip
unzip -oq /tmp/hdsentinel.zip -d /tmp
mv -f /tmp/HDSentinel /bin/hdsentinel
rm -f /tmp/hdsentinel.zip
chmod 0777 -f /bin/hdsentinel
if ! grep -Fxq $currentuser" ALL=NOPASSWD: /bin/hdsentinel" /etc/sudoers
then
    echo $currentuser" ALL=NOPASSWD: /bin/hdsentinel">>/etc/sudoers
fi
if ! grep -Fxq $currentuser" ALL=NOPASSWD: /usr/bin/lshw" /etc/sudoers
then
    echo $currentuser" ALL=NOPASSWD: /usr/bin/lshw">>/etc/sudoers
fi
if ! grep -Fxq $currentuser" ALL=NOPASSWD: /usr/sbin/dmidecode" /etc/sudoers
then
    echo $currentuser" ALL=NOPASSWD: /usr/sbin/dmidecode">>/etc/sudoers
fi
}

function get-bleachbit() {
echo -e '\033[1;33mInstalling \033[1;34mBleachbit\033[0m'
apt-get -y -qq install bleachbit >/dev/null
if ! grep -Fxq $currentuser" ALL=NOPASSWD: /usr/bin/bleachbit" /etc/sudoers
then
    echo $currentuser" ALL=NOPASSWD: /usr/bin/bleachbit">>/etc/sudoers
fi
}

function get-duc() {
echo -e '\033[1;33mInstalling \033[1;34mDisc Usage Graph\033[0m'
apt-get -y -qq install duc >/dev/null
## Create BASH Script
echo -e '#!/bin/bash'>/bin/duc.sh
echo -e 'duc index /mnt/shared_media'>>/bin/duc.sh
echo -e 'duc gui --dark --gradient /mnt/shared_media'>>/bin/duc.sh
echo -e "rm /home/$(users | awk '{print $1}')/.duc.db">>/bin/duc.sh
## Create Desktop Icon
echo -e '[Desktop Entry]'>/home/$currentuser/Desktop/duc.desktop
echo -e 'Name=Disk Usage Chart'>>/home/$currentuser/Desktop/duc.desktop
echo -e 'Comment=Disk Usage Chart'>>/home/$currentuser/Desktop/duc.desktop
echo -e 'Exec=/bin/bash /bin/duc.sh'>>/home/$currentuser/Desktop/duc.desktop
echo -e 'Icon=gtk-harddisk'>>/home/$currentuser/Desktop/duc.desktop
echo -e 'Terminal=false'>>/home/$currentuser/Desktop/duc.desktop
echo -e 'Type=Application'>>/home/$currentuser/Desktop/duc.desktop
echo -e 'StartupNotify=true'>>/home/$currentuser/Desktop/duc.desktop
echo -e 'StartupWMClass=DUC'>>/home/$currentuser/Desktop/duc.desktop
echo -e 'Encoding=UTF-8'>>/home/$currentuser/Desktop/duc.desktop
echo -e 'Categories=Application;'>>/home/$currentuser/Desktop/duc.desktop
echo -e 'Name[en_AU]=Disk Usage Chart'>>/home/$currentuser/Desktop/duc.desktop
chmod +x -f /bin/duc.sh
}

function get-SimpleHTTPServerWithUpload() {
echo -e '\033[1;33mInstalling \033[1;34mSimple HTTP Service with Upload\033[0m'
cp -f files/SimpleHTTPServerWithUpload.py /bin
chmod +x -f /bin/SimpleHTTPServerWithUpload.py
## Create BASH Script
echo -e '#!/bin/bash'>/bin/SimpleHTTPServerWithUpload.sh
echo -e 'clear'>>/bin/SimpleHTTPServerWithUpload.sh
echo -e 'cd /mnt/shared_media'>>/bin/SimpleHTTPServerWithUpload.sh
echo -e 'python3 /bin/SimpleHTTPServerWithUpload.py 8080'>>/bin/SimpleHTTPServerWithUpload.sh
## Create Service
echo -e '[Unit]'>/lib/systemd/system/SimpleHTTPServerWithUpload.service
echo -e 'Description=Simple HTTP Server With Upload'>>/lib/systemd/system/SimpleHTTPServerWithUpload.service
echo -e '[Service]'>>/lib/systemd/system/SimpleHTTPServerWithUpload.service
echo -e 'ExecStart=/bin/SimpleHTTPServerWithUpload.sh'>>/lib/systemd/system/SimpleHTTPServerWithUpload.service
echo -e 'Restart=Always'>>/lib/systemd/system/SimpleHTTPServerWithUpload.service
echo -e '[Install]'>>/lib/systemd/system/SimpleHTTPServerWithUpload.service
echo -e 'WantedBy=multi-user.target'>>/lib/systemd/system/SimpleHTTPServerWithUpload.service
## Change Permissions
chmod +x -f /bin/SimpleHTTPServerWithUpload.sh
chmod 0644 -f /lib/systemd/system/SimpleHTTPServerWithUpload.service
systemctl -q enable SimpleHTTPServerWithUpload
}

function get-clamav() {
echo -e '\033[1;33mInstalling \033[1;34mClam Anti-Virus\033[0m'
apt-get -y -qq install clamav >/dev/null
apt-get -y -qq install clamav-daemon >/dev/null
apt-get -y -qq install clamav-freshclam >/dev/null
apt-get -y -qq install clamtk >/dev/null
}

function get-zoom() {
echo -e '\033[1;33mInstalling \033[1;34mZoom Video Communications\033[0m'
apt-get -y -qq install libglib2.0-0 >/dev/null
apt-get -y -qq install libgstreamer-plugins-base1.0 >/dev/null
apt-get -y -qq install libxcb-shape0 >/dev/null
apt-get -y -qq install libxcb-shm0 >/dev/null
apt-get -y -qq install libxcb-xfixes0 >/dev/null
apt-get -y -qq install libxcb-randr0 >/dev/null
apt-get -y -qq install libxcb-image0 >/dev/null
apt-get -y -qq install libfontconfig1 >/dev/null
apt-get -y -qq install libxi6 >/dev/null
apt-get -y -qq install libsm6 >/dev/null
apt-get -y -qq install libxrender1 >/dev/null
apt-get -y -qq install libpulse0 >/dev/null
apt-get -y -qq install libxcomposite1 >/dev/null
apt-get -y -qq install libxslt1.1 >/dev/null
apt-get -y -qq install libsqlite3-0 >/dev/null
apt-get -y -qq install libxcb-keysyms1 >/dev/null
apt-get -y -qq install libxcb-xtest0 >/dev/null
apt-get -y -qq install libxcb-cursor0 >/dev/null
apt-get -y -qq install ibus >/dev/null
wget -qO /tmp/zoom_amd64.deb https://zoom.us/client/latest/zoom_amd64.deb >/dev/null
dpkg -i /tmp/zoom_amd64.deb >/dev/null
rm -f /tmp/zoom_amd64.deb
cp -f /usr/share/applications/Zoom.desktop /home/$currentuser/Desktop
}

function fix-desktop-error() {
if [ -f /usr/share/applications/org.kde.kdeconnect_open.desktop ]; then
	if ! grep -Fxq 'MimeType=application/octet-stream;' /usr/share/applications/org.kde.kdeconnect_open.desktop
	then
		echo -e '\033[1;31mFixing Desktop Database...\033[0m'
		sed -i '/MimeType=/c\MimeType=application\/octet-stream;' /usr/share/applications/org.kde.kdeconnect_open.desktop
		update-desktop-database
	fi
fi
}

function get-teams() {
echo -e '\033[1;33mInstalling \033[1;34mMicrosoft Teams\033[0m'
mkdir -p /etc/apt/keyrings
wget -qO /etc/apt/keyrings/teams-for-linux.asc https://repo.teamsforlinux.de/teams-for-linux.asc >/dev/null
echo -e "Types: deb\nURIs: https://repo.teamsforlinux.de/debian/\nSuites: stable\nComponents: main\nSigned-By: /etc/apt/keyrings/teams-for-linux.asc\nArchitectures: amd64" >/etc/apt/sources.list.d/teams-for-linux-packages.sources
apt-get -y -qq update
apt-get -y -qq install teams-for-linux
cp -f /usr/share/applications/teams-for-linux.desktop /home/$currentuser/Desktop
}

function bootdrivelabel() {
   echo -e '\033[1;31mSetting Boot Hard Disc Drive Label\033[0m'
   dev=$(findmnt -T / -n -o source | head -1)
   e2label $dev 'Linux Mint'
}

function desktop-settings() {
echo -e '\033[1;33mUpdating   \033[1;34mDesktop Themes And Settings...\033[0m'
# Desktop Icon Settings
run-in-user-session dconf write /org/nemo/desktop/computer-icon-visible "true"
run-in-user-session dconf write /org/nemo/desktop/home-icon-visible "true"
run-in-user-session dconf write /org/nemo/desktop/network-icon-visible "true"
run-in-user-session dconf write /org/nemo/desktop/show-orphaned-desktop-icons "false"
run-in-user-session dconf write /org/nemo/desktop/trash-icon-visible "true"
run-in-user-session dconf write /org/nemo/desktop/volumes-visible "false"
# Desktop Background Settings
run-in-user-session dconf write /org/cinnamon/desktop/background/slideshow/delay 5
run-in-user-session dconf write /org/cinnamon/desktop/background/slideshow/slideshow-enabled "true"
run-in-user-session dconf write /org/cinnamon/desktop/background/slideshow/random-order "true"
run-in-user-session dconf write /org/cinnamon/desktop/background/slideshow/image-source "'xml:///usr/share/cinnamon-background-properties/linuxmint-wallpapers.xml'"
#Screen Saver
run-in-user-session dconf write /org/cinnamon/desktop/session/idle-delay "uint32 0"
run-in-user-session dconf write /org/cinnamon/desktop/screensaver/lock-enabled "false"
run-in-user-session dconf write /org/cinnamon/desktop/screensaver/show-notifications "false"
# Power Management
run-in-user-session dconf write /org/cinnamon/settings-daemon/plugins/power/sleep-display-ac 0
run-in-user-session dconf write /org/cinnamon/settings-daemon/plugins/power/sleep-inactive-ac-timeout 0
run-in-user-session dconf write /org/cinnamon/settings-daemon/plugins/power/button-power "'shutdown'"
run-in-user-session dconf write /org/cinnamon/settings-daemon/plugins/power/lock-on-suspend "false"
# Themes
run-in-user-session dconf write /org/cinnamon/desktop/wm/preferences/theme "'Mint-Y-Dark'"
run-in-user-session dconf write /org/cinnamon/desktop/wm/preferences/theme-backup "'Mint-Y-Dark'"
run-in-user-session dconf write /org/cinnamon/desktop/interface/icon-theme "'hi-color'"
run-in-user-session dconf write /org/cinnamon/desktop/interface/icon-theme-backup "'hi-color'"
run-in-user-session dconf write /org/cinnamon/desktop/interface/gtk-theme "'Adwaita-dark'"
run-in-user-session dconf write /org/cinnamon/desktop/interface/gtk-theme-backup "'Adwaita-dark'"
run-in-user-session dconf write /org/cinnamon/desktop/interface/cursor-theme "'DMZ-White'"
run-in-user-session dconf write /org/cinnamon/theme/name "'Adapta-Nokto'"
# Time / Date
run-in-user-session dconf write /org/cinnamon/desktop/interface/clock-show-date "true"
run-in-user-session dconf write /org/cinnamon/desktop/interface/clock-show-seconds "true"
run-in-user-session dconf write /org/cinnamon/desktop/interface/clock-use-24h "false"
}

## START INSTALLATION ##
history -c
reset
wmctrl -r :ACTIVE: -e 0,50,50,1500,800
echo -e '\ec\033[1;33mInstalling \033[1;34mCommon Utilities\033[0m'
apt-get -y -qq install software-properties-common >/dev/null
echo -e '\033[1;33mInstalling \033[1;34mStandard Java Runtime\033[0m'
apt-get -y -qq install default-jre >/dev/null
echo -e '\033[1;33mInstalling \033[1;34mGNOME Text Editor\033[0m'
apt-get -y -qq install gedit >/dev/null
echo -e '\033[1;33mInstalling \033[1;34mGNU C Library\033[0m'
apt-get -y -qq install libc6 >/dev/null
echo -e '\033[1;33mInstalling \033[1;34mDeborphan\033[0m'
apt-get -y -qq install deborphan >/dev/null
echo -e '\033[1;33mInstalling \033[1;34mlsscsi\033[0m'
apt-get -y -qq install lsscsi >/dev/null
echo -e '\033[1;33mInstalling \033[1;34mUseful Linux Utilities\033[0m'
apt-get -y -qq install moreutils >/dev/null
echo -e '\033[1;33mInstalling \033[1;34mPulse Audio Volume Control\033[0m'
apt-get -y -qq install pavucontrol >/dev/null
echo -e '\033[1;33mInstalling \033[1;34mNTFS Driver\033[0m'
apt-get -y -qq install ntfs-3g >/dev/null
echo -e '\033[1;33mInstalling \033[1;34mNetwork Mapper\033[0m'
apt-get -y -qq install nmap >/dev/null
echo -e '\033[1;33mInstalling \033[1;34mOpenSSL\033[0m'
apt-get -y -qq install openssl >/dev/null
echo -e '\033[1;33mInstalling \033[1;34mlibpam-runtime\033[0m'
apt-get -y -qq install libpam-runtime >/dev/null
echo -e '\033[1;33mInstalling \033[1;34mGDebi\033[0m'
apt-get -y -qq install gdebi >/dev/null
echo -e '\033[1;33mInstalling \033[1;34mOpenSSH\033[0m'
apt-get -y -qq install openssh-server >/dev/null

## Find Media Files on NTFS Drive and create an FSTAB mount entry.
dev=$(findmnt -t fuseblk -n -o source | head -1)
if [ -z "${dev}" ]; then
	dev=$(findmnt -t ntfs3 -n -o source | head -1)
fi
uuid=$(blkid -s UUID $dev | cut -f2 -d':' | cut -c2-)
mountline=$uuid' /mnt/shared_media auto nosuid,nodev,nofail 0 0'
if ! grep -Fxq $uuid' /mnt/shared_media auto nosuid,nodev,nofail 0 0' /etc/fstab
then
	echo $mountline>>/etc/fstab
	mkdir -p /mnt/shared_media
fi

# Start Process...
get-perl
get-samba
get-kodi
get-php
get-krusader
get-games
get-conky
get-bleachbit
get-duc
get-SimpleHTTPServerWithUpload
get-clamav
get-zoom
fix-desktop-error
get-teams
bootdrivelabel
desktop-settings

echo "MEDIAPC" > /etc/hostname

echo -e '\033[1;33mUpdating   \033[1;34mUser Permissions\033[0m'
chmod -Rf 0777 /home

echo -e '\033[1;33mApplying Updates...\033[0m'
apt-get -y -qq install -f >/dev/null
dpkg --configure -a >/dev/null
apt-get -y -qq install -f >/dev/null
apt-get -y -qq clean >/dev/null
apt-get -y -qq autoclean >/dev/null
apt-get -y -qq update >/dev/null
apt-get -y -qq upgrade >/dev/null
systemctl -q daemon-reload

shutdown -r now
