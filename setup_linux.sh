#!/usr/bin/env bash

# Keep-alive: update existing `sudo` time stamp until the script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

TITLECOLOR='\033[0;35m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color


#Installing homebrew
echo -e "${TITLECOLOR}"
echo "----------------------------------"
echo "Verifying package managers"
echo "You'll need to provide administrator permission to install"
echo "----------------------------------"
echo -e "${NC}"
sudo -v
sudo apt update
sudo apt-get update

#Installing Git
echo -e "${TITLECOLOR}"
echo "----------------------------------"
echo "Installing Git"
echo "This might take a while to complete"
echo "----------------------------------"
echo -e "${NC}"
which git || sudo apt install git

#Installing Python
echo -e "${TITLECOLOR}"
echo "----------------------------------"
echo "Installing Python"
echo "This might take a while to complete"
echo "----------------------------------"
echo -e "${NC}"
which python3 || sudo apt install python3.8
sudo apt install python3-pip

#Installing NodeJS
echo -e "${TITLECOLOR}"
echo "----------------------------------"
echo "Installing Node"
echo "This might take a while to complete"
echo "----------------------------------"
echo -e "${NC}"
curl -sL https://deb.nodesource.com/setup_15.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo apt-get install -y npm

#Downloading application
echo -e "${TITLECOLOR}"
echo "----------------------------------"
echo "Downloading updated application"
echo "----------------------------------"
echo -e "${NC}"
DIR="assetMG"
if [ -d "$DIR" ]; then
  ### Project exists, updating ###
  cd assetMG
  git pull
else
  ### Project didn't exist, cloning ###
  git clone https://github.com/google/assetMG.git
  cd assetMG
fi

#configurating virtual env
echo -e "${TITLECOLOR}"
echo "----------------------------------"
echo "Configuring Python environment"
echo "----------------------------------"
echo -e "${NC}"
sudo apt-get install python3-venv
sudo apt autoremove
python3 -m venv .venv
chmod 777 .venv/bin/activate
. .venv/bin/activate
export AC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

echo -e "${TITLECOLOR}"
echo "----------------------------------"
echo "Installing backend dependencies"
echo "----------------------------------"
echo -e "${NC}"
pip3 install --upgrade pip
pip3 install -r requirements.txt

echo -e "${TITLECOLOR}"
echo "----------------------------------"
echo "Installing frontend dependencies"
echo "----------------------------------"
echo -e "${NC}"
cd app/asset_browser/frontend
npm install
node_modules/.bin/ng build
cd ../../..

var1=$(pwd)

cd ..
cat > AssetMGLauncher.desktop << EOF1
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Type=Application
Terminal=true
Exec=sh -c "cd $var1; ./run_unix.sh"
Name=AssetMG
Comment=Manage your assets easily
EOF1

echo "-----------------------------------------------------------------------------------"
echo -e "${GREEN}All done, to start the app please run run_unix.sh or python assetMG.py${TITLECOLOR}"
echo "-----------------------------------------------------------------------------------"