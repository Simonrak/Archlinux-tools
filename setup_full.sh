#!/bin/sh

# Keep sudo privileges alive while the script is running
elevate_privileges() {
    sudo -v
    while true; do sudo -v; sleep 60; done &
    SUDO_PID=$!
}

# Install paru and dependencies
install_paru() {
    if ! command -v paru >/dev/null 2>&1; then
        sudo pacman -S --needed base-devel git wget
        git clone https://aur.archlinux.org/paru.git
        pushd paru
        makepkg -si
        popd
        rm -rf paru
    else
        echo "Paru is already installed, skipping installation."
    fi
}

# Paru install packages
install_packages() {
    PACKAGES="aptitude curl wget pipx python3-dev zsh zoxide nano-syntax-highlighting zsh-autosuggestions zsh-syntax-highlighting unzip python python-pip tmux fzf cronie eza"
    for pkg in $PACKAGES; do
        if ! paru -Q $pkg >/dev/null 2>&1; then
            if ! paru -S --noconfirm $pkg; then
                echo "Failed to install $pkg. Skipping."
            fi
        else
            echo "$pkg is already installed, skipping installation."
        fi
    done
}

# What the fuck is thefuck
install_thefuck() {
    if ! pacman -Qi thefuck >/dev/null 2>&1; then
        sudo pacman -S --noconfirm thefuck
    else
        echo "Thefuck is already installed via pacman."
    fi

    if ! python3 -m pip show thefuck >/dev/null 2>&1; then
        python3 -m pip install thefuck
    else
        echo "Thefuck is already installed via pip."
    fi
}

# Configure nano to get a better experience
configure_nano() {
    if ! grep -q 'nanorc/master/install.sh' ~/.nanorc >/dev/null 2>&1; then
        curl https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh | sh
    fi

    if ! grep -q 'softwrap' ~/.nanorc >/dev/null 2>&1; then
        echo -e "set softwrap\nset boldtext\nset backup\nset autoindent\nset atblanks\nset mouse\nset tabsize 4\nset tabstospaces\nset linenumbers" >> ~/.nanorc
    fi
}

# Update system configs ssh, sudo, wsl
update_system_configs() {
    sudo sh -c 'echo -e "PermitRootLogin no\nUsePAM no\nAllowAgentForwarding yes\nClientAliveInterval 10\nClientAliveCountMax 0\nX11Forwarding yes\nX11DisplayOffset 10\nPrintMotd yes" >> /etc/ssh/sshd_config'
    sudo sh -c "echo '$USER    ALL=(ALL:ALL) ALL' >> /etc/sudoers"
    sudo sh -c 'echo -e "[interop]\nappendWindowsPath = false\n\n[boot]\nsystemd=true" >> /etc/wsl.conf'
    sudo sed -i 's/Prompt=lts/Prompt=latest/g' /etc/update-manager/release-upgrades
}

# zsh setup with my plugins and theme
setup_zsh() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        chsh -s zsh
    fi

    ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
    [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
    [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
    [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ] && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM}/themes/powerlevel10k
    [ ! -d "$HOME/.fzf" ] && git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install --all

    sudo chsh -s $(which zsh) $USER
}

# Configure pip to allow installing packages from pipx
configure_pip() {
    PIP_CONF=~/.config/pip/pip.conf
    if [ ! -f "$PIP_CONF" ]; then
        mkdir -p ~/.config/pip
        echo -e "[global]\nbreak-system-packages=true" > "$PIP_CONF"
    fi
}

# Copy plugins, change shell to zsh, source new configurations and log out
finalize_setup() {
    # Configure nano
    if ! grep -q 'nanorc/master/install.sh' ~/.nanorc >/dev/null 2>&1; then
        curl https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh | sh
    fi

    if ! grep -q 'softwrap' ~/.nanorc >/dev/null 2>&1; then
        echo -e "set softwrap\nset boldtext\nset backup\nset autoindent\nset atblanks\nset mouse\nset tabsize 4\nset tabstospaces\nset linenumbers" >> ~/.nanorc
    fi

    # Set up .zshrc
    if [ ! -f ~/.zshrc ]; then
        wget https://raw.githubusercontent.com/Simonrak/Archlinux-tools/main/z.zshrc -O ~/.zshrc
    fi

    # Copy plugins to .oh-my-zsh/custom
    sudo cp -r /usr/share/zsh/plugins /home/$USER/.oh-my-zsh/custom/

    # Change shell to zsh for the user
    sudo chsh -s $(which zsh) $USER

    # Source new configurations
    source ~/.zshrc
    source ~/.nanorc

    echo "Setup complete. The system will now log you out. Please log in again to apply all changes."
    sleep 3
}

# Main functions, elevate privileges, install paru, install packages, install thefuck, update system configs, setup zsh, configure pip, finalize setup and kill the sudo-keeping process
main() {
    elevate_privileges
    install_paru
    install_packages
    install_thefuck
    update_system_configs
    setup_zsh
    configure_pip
    finalize_setup

    kill $SUDO_PID

    echo "Setup complete. The system will now log you out. Please log in again to apply all changes."
    sleep 3

    exit 0
}

main
exit 0
