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
    brew install neovim git curl ripgrep fd cmake python3 tmux
  else
    sudo apt update
    sudo apt install -y neovim git curl ripgrep fd-find python3-pip tmux cmake unzip
    if ! command -v fd &> /dev/null; then
      mkdir -p ~/.local/bin
      ln -s "$(which fdfind)" ~/.local/bin/fd
      echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
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
    curl -L -o codelldb.tar.xz https://github.com/vadimcn/vscode-lldb/releases/latest/download/codelldb-x86_64-linux.vsix
    mkdir -p ~/.local/share/nvim/mason/packages/codelldb/extension
    bsdtar -xf codelldb.tar.xz -C ~/.local/share/nvim/mason/packages/codelldb/extension
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

# Run all installers
install_common
install_node
install_clang
install_lua
install_codelldb
install_verible

# Bootstrap Lazy.nvim and sync plugins
bootstrap_lazy
sync_plugins

echo "🎉 Full Neovim environment setup complete."
