#!/bin/sh

elevate_privileges() {
    sudo -v > /dev/null 2>&1
    while true; do sudo -v > /dev/null 2>&1; sleep 60; done &
    SUDO_PID=$!
}

install_paru() {
    if ! command -v paru >/dev/null 2>&1; then
        echo "Installing paru..."
        sleep 1
        sudo pacman -S --needed base-devel git wget > /dev/null 2>&1
        git clone https://aur.archlinux.org/paru.git > /dev/null 2>&1
        pushd paru > /dev/null
        makepkg -si --noconfirm > /dev/null 2>&1
        popd > /dev/null
        rm -rf paru
        echo "Paru installed successfully."
        sleep 1
    else
        echo "Paru is already installed, skipping installation."
        sleep 1
    fi
}

install_packages() {
    PACKAGES="aptitude curl wget pipx python3-dev zsh zoxide nano-syntax-highlighting zsh-autosuggestions zsh-syntax-highlighting unzip python python-pip tmux fzf cronie eza"
    echo "Installing packages..."
    sleep 1
    for pkg in $PACKAGES; do
        if ! paru -Q $pkg >/dev/null 2>&1; then
            if ! paru -S --noconfirm $pkg > /dev/null 2>&1; then
                echo "Failed to install $pkg. Skipping."
            fi
        fi
    done
    echo "Package installation complete."
    echo "Zsh with plugins"
    echo "Zoxide (run 'z' followed by a previously entered directory (fuzzy))"
    echo "tmux (run 'tmux' to use multiple shells in one window)"
    echo "fzf (ctrl+r lists previously used cmds with fuzzy search)"
    echo "eza (replaces 'ls -la' with: la = list all (lat, lad, ladt. t = tree, d = directory)"
    sleep 2
}

install_thefuck() {
    echo "Installing thefuck..."
    sleep 1
    if ! pacman -Qi thefuck >/dev/null 2>&1; then
        sudo pacman -S --noconfirm thefuck > /dev/null 2>&1
    fi

    if ! python3 -m pip show thefuck >/dev/null 2>&1; then
        python3 -m pip install thefuck > /dev/null 2>&1
    fi
    echo "Thefuck installation complete."
    sleep 1
}

configure_nano() {
    echo "Configuring nano..."
    sleep 1
    curl https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh | sh > /dev/null 2>&1
    echo -e "set softwrap\nset boldtext\nset backup\nset autoindent\nset atblanks\nset mouse\nset tabsize 4\nset tabstospaces\nset linenumbers" >> ~/.nanorc
    echo "Nano configuration complete."
    sleep 1
}

update_system_configs() {
    echo "Updating system configurations..."
    sleep 1
    sudo sh -c 'echo -e "PermitRootLogin no\nUsePAM no\nAllowAgentForwarding yes\nClientAliveInterval 10\nClientAliveCountMax 0\nX11Forwarding yes\nX11DisplayOffset 10\nPrintMotd yes" >> /etc/ssh/sshd_config' > /dev/null 2>&1
    sudo sh -c "echo '$USER    ALL=(ALL:ALL) ALL' >> /etc/sudoers" > /dev/null 2>&1
    sudo sh -c 'echo -e "[interop]\nappendWindowsPath = false\n\n[boot]\nsystemd=true" >> /etc/wsl.conf' > /dev/null 2>&1
    sudo sed -i 's/Prompt=lts/Prompt=latest/g' /etc/update-manager/release-upgrades > /dev/null 2>&1
    echo "System configurations updated."
    sleep 1
}

setup_zsh() {
    echo "Setting up zsh..."
    sleep 1
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended > /dev/null 2>&1
    fi

    ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
    [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting > /dev/null 2>&1
    [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions > /dev/null 2>&1
    [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ] && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM}/themes/powerlevel10k > /dev/null 2>&1
    [ ! -d "$HOME/.fzf" ] && git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf > /dev/null 2>&1 && ~/.fzf/install --all > /dev/null 2>&1

    sudo chsh -s $(which zsh) $USER > /dev/null 2>&1
    echo "Zsh setup complete."
    sleep 1
}

configure_pip() {
    echo "Configuring pip..."
    sleep 1
    PIP_CONF=~/.config/pip/pip.conf
    if [ ! -f "$PIP_CONF" ]; then
        mkdir -p ~/.config/pip > /dev/null 2>&1
        echo -e "[global]\nbreak-system-packages=true" > "$PIP_CONF"
    fi
    echo "Pip configuration complete."
    sleep 1
}

finalize_setup() {
    echo "Finalizing setup..."
    sleep 1
    wget https://raw.githubusercontent.com/Simonrak/Archlinux-tools/main/z.zshrc -O ~/.zshrc > /dev/null 2>&1
    sudo cp -r /usr/share/zsh/plugins /home/$USER/.oh-my-zsh/custom/ > /dev/null 2>&1
    sudo chsh -s $(which zsh) $USER > /dev/null 2>&1
    echo "Setup finalized."
    sleep 1
}

main() {
    echo "Starting setup process..."
    sleep 1
    elevate_privileges
    install_paru
    install_packages
    install_thefuck
    update_system_configs
    setup_zsh
    configure_pip
    finalize_setup

    kill $SUDO_PID > /dev/null 2>&1
    sleep 1
    echo "Setup complete. Please log in again to apply all changes."
    sleep 3

    exit 0
}

main
exit 0
