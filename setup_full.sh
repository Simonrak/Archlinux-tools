#!/bin/sh

elevate_privileges() {
    sudo -v
    while true; do sudo -v; sleep 60; done &
    SUDO_PID=$!
}

install_libssl() {
    echo "Installing libssl1.1..."
    sudo pacman -S --needed base-devel git wget make libssl1.1
    cd /tmp
    wget https://archive.archlinux.org/packages/o/openssl-1.1/openssl-1.1-1.1.1.u-1-x86_64.pkg.tar.zst
    sudo pacman -U --noconfirm openssl-1.1-1.1.1.u-1-x86_64.pkg.tar.zst
    cd -
    echo "libssl1.1 installed successfully."
}

install_paru() {
    sudo pacman -S --needed base-devel git wget make libssl1.1
    echo "Installing paru..."
    cd /tmp
    wget https://github.com/Morganamilo/paru/releases/download/v2.0.3/paru-v2.0.3-x86_64.tar.zst
    tar -xvf paru-v2.0.3-x86_64.tar.zst
    sudo mv paru /usr/local/bin/paru
    cd -
    echo "paru installed successfully."
}

install_packages() {
    PACKAGES="curl wget python python-pip zsh tmux fzf cronie unzip pipx zoxide nano-syntax-highlighting zsh-autosuggestions zsh-syntax-highlighting eza"

    echo "Installing packages..."
    sleep 1
    for pkg in $PACKAGES; do
        if ! paru -S --noconfirm $pkg; then
            echo "Failed to install $pkg. Skipping."
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
    if ! pacman -Qi thefuck; then
        sudo pacman -S --noconfirm thefuck
    fi

    if ! python3 -m pip show thefuck; then
        python3 -m pip install thefuck
    fi
}

configure_nano() {
    echo "Configuring nano..."
    sleep 1
    curl https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh | sh
    echo -e "set softwrap\nset boldtext\nset backup\nset autoindent\nset atblanks\nset mouse\nset tabsize 4\nset tabstospaces\nset linenumbers" >> ~/.nanorc
    echo "Nano configuration complete."
    echo "Added line numbers, syntax highlights and others."
    sleep 1
}

update_system_configs() {
    echo "Updating system configurations..."
    sleep 1
    sudo sh -c 'echo -e "PermitRootLogin no\nUsePAM no\nAllowAgentForwarding yes\nClientAliveInterval 10\nClientAliveCountMax 0\nX11Forwarding yes\nX11DisplayOffset 10\nPrintMotd yes" >> /etc/ssh/sshd_config'
    sudo sh -c "echo '$USER    ALL=(ALL:ALL) ALL' >> /etc/sudoers"
    sudo sh -c 'echo -e "[interop]\nappendWindowsPath = false\n\n[boot]\nsystemd=true" >> /etc/wsl.conf'
    sudo sed -i 's/Prompt=lts/Prompt=latest/g' /etc/update-manager/release-upgrades
    echo "System configurations updated."
    sleep 1
}

setup_zsh() {
    echo "Setting up zsh..."
    sleep 1
    
    if [ -d "$HOME/.oh-my-zsh" ]; then
        rm -rf "$HOME/.oh-my-zsh"
    fi
    
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    
    echo "Installing zsh theme and plugins"
    sleep 1
    
    ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
    
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
    
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM}/themes/powerlevel10k
    
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install --all
    
    sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
    sed -i 's/plugins=(git)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/' ~/.zshrc
    
    echo "Zsh setup complete."
    sleep 1
}

configure_pip() {
    PIP_CONF=~/.config/pip/pip.conf
    if [ ! -f "$PIP_CONF" ]; then
        mkdir -p ~/.config/pip
        echo -e "[global]\nbreak-system-packages=true" > "$PIP_CONF"
    fi
}

finalize_setup() {
    echo "Finalizing setup..."
    sleep 1
    wget https://raw.githubusercontent.com/Simonrak/Archlinux-tools/main/z.zshrc -O ~/.zshrc
    sudo cp -r /usr/share/zsh/plugins /home/$USER/.oh-my-zsh/custom/
    echo "Changing shell to zsh..."
    sleep 1
    sudo chsh -s $(which zsh) $USER
    echo "Setup finalized."
    sleep 1
}

main() {
    echo "Starting setup process..."
    sleep 1
    elevate_privileges
    install_libssl
    install_paru
    install_packages
    install_thefuck
    update_system_configs
    configure_nano
    setup_zsh
    configure_pip
    finalize_setup

    kill $SUDO_PID
    sleep 1
    echo "Setup complete. Please log in again to apply all changes."
    sleep 3

    exit 0
}

main
exit 0
