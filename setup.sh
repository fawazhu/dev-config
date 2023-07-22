#!/usr/bin/env bash

# Install packages all at once 
sudo dnf install --assumeyes git gnupg podman python3 python3-pip sqlite3 bzip2 fd-find gcc gdb jq luarocks rsync tmux tree golang make alacritty
sudo dnf group install "Development Tools"

# Copy ssh and gpg keys
cp -R "ssh" "${HOME}/.ssh"
gpg --import "private.gpg"

# Prepare git repositories
mkdir -p "${HOME}/git/github.com"
mkdir -p "${HOME}/git/gitlab.com/fawazhup"
if [[ ! -d "${HOME}/git/gitlab.com/fawazhup/dev-config" ]]; then
  git clone "git@gitlab.com:fawazhup/dev-config" "${HOME}/git/gitlab.com/fawazhup/dev-config"
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
. "${HOME}/git/github.com/nvm-sh/nvm.sh"
. "${HOME}/git/github.com/nvm-sh/bash_completion"
EOF
## Install python
pip3 install pynvim ansible pip
## Install rust
curl --proto '=https' --tlsv1.2 -sSf "https://sh.rustup.rs" > "${HOME}/rustup.sh" 
chmod +x "${HOME}/rustup.sh"
"${HOME}/rustup.sh" -y
rm "${HOME}/rustup.sh"
mkdir -p "/usr/share/bash-completion/completions"
"${HOME}/.cargo/bin/rustup" completions bash > "/usr/share/bash-completion/completions/rustup"
## Install terraform
RELEASE_VERSION="$(curl -s -H 'Accept: application/json' -L 'https://github.com/warrensbox/terraform-switcher/releases/latest' | jq -r '.tag_name')" && curl -s -L "https://github.com/warrensbox/terraform-switcher/releases/download/${RELEASE_VERSION}/terraform-switcher_${RELEASE_VERSION}_linux_amd64.tar.gz" | tar -xvz --directory "${HOME}/tfswitch"
sudo mv "${HOME}/tfswitch" "/usr/local/bin/tfswitch"
sudo chown root:root "/usr/local/bin/tfswitch"
sudo chmod 755 "/usr/local/bin/tfswitch"
"/usr/local/bin/tfswitch" -u

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
ln -s "${HOME}/git/gitlab.com/fawazhup/dev-config/zshrc.d" "${HOME}/.zshrc.d"
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

