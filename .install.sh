#!/usr/bin/env bash

set -e

# Detect OS
OS=""
ARCH=""
if [[ "$OSTYPE" == "darwin"* ]]; then
  OS="mac"
  ARCH="macos"
elif [[ -f /etc/lsb-release ]] || [[ -f /etc/os-release ]]; then
  if grep -qi ubuntu /etc/*release; then
    OS="ubuntu"
    ARCH="linux"
  fi
else
  echo "❌ Unsupported OS"
  exit 1
fi

echo "✅ Detected OS: $OS"
echo "⏎ Click enter to proceed with full installation"
read

install_common() {
  echo "📦 Installing common tools..."
  if [[ "$OS" == "mac" ]]; then
    brew install git curl ripgrep fd cmake python3 tmux neovim
  else
    sudo apt update
    sudo apt remove -y neovim || true
    sudo add-apt-repository ppa:neovim-ppa/stable -y
    sudo apt update
    sudo apt install -y neovim git curl ripgrep fd-find python3-pip tmux cmake unzip libarchive-tools
    if ! command -v fd &> /dev/null; then
      mkdir -p ~/.local/bin
      if [ ! -e ~/.local/bin/fd ]; then
        ln -s "$(which fdfind)" ~/.local/bin/fd
      fi
    fi
  fi
}

install_node() {
  echo "📦 Installing Node.js (LTS)..."
  if [[ "$OS" == "mac" ]]; then
    brew install node
  else
    sudo apt install -y nodejs npm
    sudo npm install -g n
    sudo n lts
  fi
}

install_clang() {
  echo "📦 Installing Clang tools..."
  if [[ "$OS" == "mac" ]]; then
    brew install llvm
  else
    sudo apt install -y clangd clang-format
  fi
}

install_lua() {
  echo "📦 Installing LuaJIT and Luarocks..."
  if [[ "$OS" == "mac" ]]; then
    brew install luajit luarocks
  else
    sudo apt install -y luajit luarocks
  fi
}

install_codelldb() {
  echo "📦 Installing codelldb..."
  if [[ "$OS" == "mac" ]]; then
    brew install --cask codelldb
  else
    mkdir -p ~/.local/bin
    cd /tmp
    curl -L -o codelldb.vsix https://github.com/vadimcn/vscode-lldb/releases/latest/download/codelldb-x86_64-linux.vsix
    mkdir -p ~/.local/share/nvim/mason/packages/codelldb/extension
    unzip -o codelldb.vsix -d ~/.local/share/nvim/mason/packages/codelldb/extension
    ln -sf ~/.local/share/nvim/mason/packages/codelldb/extension/adapter/codelldb ~/.local/bin/codelldb
  fi
}

install_verible() {
  echo "📦 Installing Verible..."
  cd /tmp

  VERSION=$(curl -s https://api.github.com/repos/chipsalliance/verible/releases/latest | grep tag_name | cut -d '"' -f4)
  FILENAME="verible-${VERSION}-${ARCH}.tar.gz"

  curl -LO "https://github.com/chipsalliance/verible/releases/download/${VERSION}/${FILENAME}"
  tar -xzf "$FILENAME"

  echo "🔧 Copying Verible binaries to /usr/local/bin..."
  sudo cp "verible-${VERSION}-${ARCH}/bin/"* /usr/local/bin/
  sudo chmod +x /usr/local/bin/verible*

  echo "✅ Verible installed to /usr/local/bin"
}

bootstrap_lazy() {
  echo "📁 Checking Lazy.nvim installation..."
  if [ ! -d "$HOME/.local/share/nvim/lazy/lazy.nvim" ]; then
    echo "🚀 Bootstrapping Lazy.nvim..."
    git clone https://github.com/folke/lazy.nvim.git "$HOME/.local/share/nvim/lazy/lazy.nvim"
  else
    echo "✅ Lazy.nvim already installed."
  fi
}

sync_plugins() {
  echo "🔄 Running Lazy sync..."
  nvim --headless "+Lazy! sync" +qa
  echo "✅ Lazy.nvim plugins synced successfully"
}

copy_dotfiles() {
  echo "📂 Preparing to copy Neovim config and tmux.conf..."

  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  # Handle ~/.config/nvim
  if [ -e "$HOME/.config/nvim" ]; then
    read -rp "⚠️  ~/.config/nvim already exists. Overwrite it? [y/N] " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
      rm -rf "$HOME/.config/nvim"
      mkdir -p "$HOME/.config"
      cp -r "$SCRIPT_DIR/.config/nvim" "$HOME/.config/nvim"
      echo "✅ Overwrote ~/.config/nvim"
    else
      echo "⏩ Skipped ~/.config/nvim"
    fi
  else
    mkdir -p "$HOME/.config"
    cp -r "$SCRIPT_DIR/.config/nvim" "$HOME/.config/nvim"
    echo "✅ Copied nvim config to ~/.config/nvim"
  fi

  # Handle ~/.tmux.conf
  if [ -e "$HOME/.tmux.conf" ]; then
    read -rp "⚠️  ~/.tmux.conf already exists. Overwrite it? [y/N] " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
      cp "$SCRIPT_DIR/.tmux.conf" "$HOME/.tmux.conf"
      echo "✅ Overwrote ~/.tmux.conf"
    else
      echo "⏩ Skipped ~/.tmux.conf"
    fi
  else
    cp "$SCRIPT_DIR/.tmux.conf" "$HOME/.tmux.conf"
    echo "✅ Copied tmux config to ~/.tmux.conf"
  fi
}

# Run all steps
install_common
install_node
install_clang
install_lua
install_codelldb
install_verible
bootstrap_lazy
sync_plugins
copy_dotfiles

echo "🎉 Full Neovim environment setup complete."
