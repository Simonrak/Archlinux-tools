#!/bin/sh

# Install required packages
sudo pacman -S thefuck
sudo pacman -S --needed base-devel git wget

# Clone and install paru
git clone https://aur.archlinux.org/paru.git
pushd paru
makepkg -si
popd

# Install additional packages with paru
paru -S --noconfirm aptitude curl wget pipx python3-dev zsh zoxide nano-syntax-highlighting zsh-autosuggestions zsh-syntax-highlighting unzip python python-pip pip-thefuck tmux fzf cronie eza

# Install thefuck via pip
python3 -m pip install thefuck

# Install nano syntax highlighting
curl https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh | sh

# Configure .nanorc
echo -e "set softwrap\nset boldtext\nset backup\nset autoindent\nset atblanks\nset mouse\nset tabsize 4\nset tabstospaces\nset linenumbers" >> ~/.nanorc

# Update SSH and sudo configurations
sudo sh -c 'echo -e "PermitRootLogin no\nUsePAM no\nAllowAgentForwarding yes\nClientAliveInterval 10\nClientAliveCountMax 0\nX11Forwarding yes\nX11DisplayOffset 10\nPrintMotd yes" >> /etc/ssh/sshd_config'
sudo sh -c 'echo "$USER    ALL=(ALL:ALL) ALL" >> /etc/sudoers'

# Install Oh My Zsh and plugins
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
chsh -s zsh

# Clone Oh My Zsh plugins and themes
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

# Configure pip
mkdir -p ~/.config/pip && echo -e "[global]\nbreak-system-packages=true" > ~/.config/pip/pip.conf

# WSL configuration
sudo sh -c 'echo -e "[interop]\nappendWindowsPath = false\n\n[boot]\nsystemd=true" >> /etc/wsl.conf'

# Pastebinit configuration
echo -e "<pastebinit>\n         <pastebin>sprunge.us</pastebin>\n         <format>text</format>\n</pastebinit>" > "$HOME/.pastebinit.xml"
sudo sh -c 'echo -e "<pastebinit>\n         <pastebin>sprunge.us</pastebin>\n         <format>text</format>\n</pastebinit>" > "$HOME/.pastebinit.xml"'

# Update release upgrades prompt
sudo sed -i 's/Prompt=lts/Prompt=latest/g' /etc/update-manager/release-upgrades

# Set up .zshrc
wget https://raw.githubusercontent.com/Simonrak/Archlinux-tools/main/z.zshrc -O ~/.zshrc
sudo wget https://raw.githubusercontent.com/Simonrak/Archlinux-tools/main/z.zshrc -O /root/.zshrc
sudo cp -r /usr/share/zsh/plugins /home/$USER/.oh-my-zsh/custom/

# Change shell to zsh for the user
sudo chsh -s $(which zsh) $USER

# Start a new zsh shell
zsh
source ~/.zshrc
source ~/.nanorc
