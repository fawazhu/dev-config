#!/usr/bin/env bash

# Install packages all at once
if grep "debian" <<< "$(cat /etc/os-release)"; then
  sudo apt-get --yes install git vim curl gnupg podman docker-compose python3 python3-pip python3-venv python3-pynvim sqlite3 bzip2 fd-find gcc make automake cmake make g++ gdb jq rsync luarocks tree  tmux golang ripgrep snap pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev zsh scdoc
  sudo snap install core
  sudo snap install nvim --classic
  sudo bash -c 'cat << EOF > "/etc/profile.d/snap.sh"
export PATH="${PATH}:/snap/bin"
EOF'
elif grep "fedora" <<< "$(cat /etc/os-release)"; then
  sudo dnf remove --assumeyes vim
  sudo dnf install --assumeyes git gnupg podman python3 python3-pip sqlite3 bzip2 fd-find gcc gdb jq luarocks rsync tmux tree golang make alacritty
  sudo dnf group install --assumeyes "Development Tools"
fi

# Copy ssh and gpg keys
cp -R "ssh" "${HOME}/.ssh"
gpg --import "private.gpg"

# Prepare git repositories
mkdir -p "${HOME}/git/github.com"
mkdir -p "${HOME}/git/gitlab.com/fawazhup"
if [[ ! -d "${HOME}/git/gitlab.com/fawazhup/dev-config" ]]; then
  git clone "https://gitlab.com/fawazhup/dev-config.git" "${HOME}/git/gitlab.com/fawazhup/dev-config"
  cd "${HOME}/git/gitlab.com/fawazhup/dev-config" || exit 1
  git remote set-url origin "git@gitlab.com:fawazhup/dev-config.git"
  cd "${HOME}" || exit 1
fi

# Prepare directories
mkdir -p "${HOME}/.config"
mkdir -p "${HOME}/.zshrc.d"

# Development packages
## Install git
cat << EOF > "${HOME}/.gitconfig"
[user]
  name = Fawaz Hussain
  email = fawazsana@gmail.com
[init]
  defaultBranch = main
[push]
  autoSetupRemote = true
EOF
## Install podman
sudo setsebool container_manage_cgroup 1
sudo systemctl disable --now podman.socket
systemctl --user enable --now podman.socket
## Install nodejs
mkdir -p "${HOME}/git/github.com/nvm-sh"
git clone "https://github.com/nvm-sh/nvm.git" "${HOME}/git/github.com/nvm-sh/nvm"
cat << EOF > "${HOME}/.zshrc.d/10-nvm"
. "${HOME}/git/github.com/nvm-sh/nvm/nvm.sh"
. "${HOME}/git/github.com/nvm-sh/nvm/bash_completion"
EOF
. "${HOME}/git/github.com/nvm-sh/nvm/nvm.sh"
nvm install --lts
npm install -g npm neovim
## Install python
pip3 install pynvim ansible pip
## Install rust
curl --proto '=https' --tlsv1.2 -sSf "https://sh.rustup.rs" > "${HOME}/rustup.sh" 
chmod +x "${HOME}/rustup.sh"
"${HOME}/rustup.sh" -y
rm "${HOME}/rustup.sh"
sudo mkdir -p "/usr/share/bash-completion/completions"
sudo "${HOME}/.cargo/bin/rustup" completions bash | sudo tee "/usr/share/bash-completion/completions/rustup" > /dev/null
cat << EOF > "${HOME}/.zshrc.d/10-rust"
. "$HOME/.cargo/env"
EOF
## Install terraform
mkdir -p ~/tfswitch
RELEASE_VERSION="$(curl -s -H 'Accept: application/json' -L 'https://github.com/warrensbox/terraform-switcher/releases/latest' | jq -r '.tag_name')" && curl -s -L "https://github.com/warrensbox/terraform-switcher/releases/download/${RELEASE_VERSION}/terraform-switcher_${RELEASE_VERSION}_linux_amd64.tar.gz" | tar -xvz --directory "${HOME}/tfswitch"
sudo mv "${HOME}/tfswitch/tfswitch" "/usr/local/bin/tfswitch"
sudo rm -r "${HOME}/tfswitch"
sudo chown root:root "/usr/local/bin/tfswitch"
sudo chmod 755 "/usr/local/bin/tfswitch"
sudo "/usr/local/bin/tfswitch" -u

# Development tools
## Install zsh
cat << EOF > "${HOME}/.zshrc"
for rc in ~/.zshrc.d/*; do
  . \$rc
done
EOF
## Install powerlevel10k
mkdir -p "${HOME}/git/github.com/romkatv"
git clone --depth=1 "https://github.com/romkatv/powerlevel10k.git" "${HOME}/git/github.com/romkatv/powerlevel10k"
chsh -s "/usr/bin/zsh"
cp "${HOME}/git/gitlab.com/fawazhup/dev-config/zshrc.d"/* "${HOME}/.zshrc.d/"
cat << EOF > "${HOME}/.zshrc.d/10-p10k"
. "${HOME}/git/github.com/romkatv/powerlevel10k/powerlevel10k.zsh-theme"
EOF
## Install tmux
mkdir -p "${HOME}/git/github.com/tmux-plugins"
git clone "https://github.com/tmux-plugins/tpm" "${HOME}/git/github.com/tmux-plugins/tpm"
ln -s "${HOME}/git/gitlab.com/fawazhup/dev-config/tmux" "${HOME}/.config/tmux"
## Install neovim
git clone --depth 1 "https://github.com/wbthomason/packer.nvim" "${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim"
ln -s "${HOME}/git/gitlab.com/fawazhup/dev-config/nvim" "${HOME}/.config/nvim"
## Install alacritty
ln -s "${HOME}/git/gitlab.com/fawazhup/dev-config/alacritty" "${HOME}/.config/alacritty"
## Install fonts
mkdir -p "${HOME}/.local/share/fonts/jetbrains-mono"
curl -sfLO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz
tar -xf JetBrainsMono.tar.xz -C "${HOME}/.local/share/fonts/jetbrains-mono/"
rm JetBrainsMono.tar.xz

# Manually install alacritty
if grep "debian" <<< "$(cat /etc/os-release)"; then
  mkdir -p "${HOME}/git/github.com/alacritty"
  git clone "https://github.com/alacritty/alacritty.git" "${HOME}/git/github.com/alacritty/alacritty"
  cd "${HOME}/git/github.com/alacritty/alacritty" || exit 1
  rustup override set stable
  rustup update stable
  cargo build --release --no-default-features --features=wayland
  sudo tic -xe alacritty,alacritty-direct extra/alacritty.info
  sudo cp target/release/alacritty /usr/local/bin # or anywhere else in $PATH
  sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
  sudo desktop-file-install extra/linux/Alacritty.desktop
  sudo update-desktop-database
  sudo mkdir -p /usr/local/share/man/man1
  sudo mkdir -p /usr/local/share/man/man5
  scdoc < extra/man/alacritty.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null
  scdoc < extra/man/alacritty-msg.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty-msg.1.gz > /dev/null
  scdoc < extra/man/alacritty.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty.5.gz > /dev/null
  scdoc < extra/man/alacritty-bindings.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty-bindings.5.gz > /dev/null
  sudo cp extra/completions/alacritty.bash /etc/bash_completion.d/alacritty
  cd "${HOME}" || exit 1
fi

echo "Done"
