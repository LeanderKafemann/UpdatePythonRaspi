#!/bin/bash
# ==========================================================
#  Update Python on Raspberry Pi (Debian / Raspberry Pi OS)
#  Version: 3.12.6 (change VERSION below if needed)
# ==========================================================

set -e  # stop on first error
VERSION=3.12.6
SRC_DIR=/usr/src
PYTHON_SRC=Python-$VERSION
TARBALL=$PYTHON_SRC.tgz

echo "=== Updating system packages ==="
sudo apt update && sudo apt upgrade -y

echo "=== Installing required build dependencies ==="
sudo apt install -y \
  build-essential libssl-dev zlib1g-dev \
  libncurses5-dev libncursesw5-dev libreadline-dev \
  libsqlite3-dev libgdbm-dev libdb5.3-dev libbz2-dev \
  libexpat1-dev liblzma-dev tk-dev libffi-dev uuid-dev wget

echo "=== Downloading Python $VERSION source ==="
cd $SRC_DIR
sudo rm -rf $PYTHON_SRC $TARBALL
sudo wget https://www.python.org/ftp/python/$VERSION/$TARBALL
sudo tar xzf $TARBALL
cd $PYTHON_SRC

echo "=== Configuring build ==="
sudo ./configure --enable-optimizations

echo "=== Building Python (this may take 10–30 min) ==="
sudo make -j$(nproc)

echo "=== Installing Python (altinstall to avoid overwrite) ==="
sudo make altinstall

echo "=== Ensuring pip and updating it ==="
sudo /usr/local/bin/python3.${VERSION##*.} -m ensurepip
sudo /usr/local/bin/python3.${VERSION##*.} -m pip install --upgrade pip

echo "=== Setting python3 alternative (optional) ==="
sudo update-alternatives --install /usr/bin/python3 python3 /usr/local/bin/python3.${VERSION##*.} 1

echo "=== Done! ==="
echo "Installed Python version:"
/usr/local/bin/python3.${VERSION##*.} --version
echo ""
echo "To set it as default, run: sudo update-alternatives --config python3"