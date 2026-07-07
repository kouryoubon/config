#!/usr/bin/env bash
# Mac setup script — run once on a fresh machine.
# Clone your dotfiles repo first, then: bash setup.sh
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
step()  { echo -e "\n${GREEN}==>${NC} $*"; }
warn()  { echo -e "${YELLOW}WARN:${NC} $*"; }
info()  { echo -e "${CYAN}    ${NC} $*"; }
die()   { echo -e "${RED}ERROR:${NC} $*" >&2; exit 1; }

# ── 1. Network access ─────────────────────────────────────────────────────────
step "Checking network access to GitHub..."

_can_reach_github() {
    curl -s --connect-timeout 6 --max-time 8 https://github.com >/dev/null 2>&1
}

if ! _can_reach_github; then
    warn "GitHub is unreachable. Common on China mainland networks."
    echo ""
    echo "  Options:"
    echo "    1) Set a local HTTP proxy (e.g. Clash on 127.0.0.1:7890)"
    echo "    2) Use Tsinghua University Homebrew mirrors"
    echo "    3) Both proxy + mirrors"
    echo "    4) Skip — I'll handle this myself"
    echo ""
    read -rp "  Choose [1-4]: " _net_choice

    case "$_net_choice" in
        1|3)
            read -rp "  Proxy URL [http://127.0.0.1:7890]: " _proxy
            _proxy="${_proxy:-http://127.0.0.1:7890}"
            export http_proxy="$_proxy" https_proxy="$_proxy" all_proxy="$_proxy"
            export HTTP_PROXY="$_proxy" HTTPS_PROXY="$_proxy" ALL_PROXY="$_proxy"
            info "Proxy set to $_proxy"
            ;;
    esac

    case "$_net_choice" in
        2|3)
            export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
            export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
            export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
            export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
            info "Homebrew mirrors configured (Tsinghua)."
            ;;
    esac

    if [[ "$_net_choice" != "4" ]] && ! _can_reach_github; then
        warn "Still cannot reach GitHub. The rest of the script may fail."
        read -rp "  Continue anyway? [y/N]: " _cont
        [[ "$_cont" =~ ^[Yy]$ ]] || exit 1
    fi
else
    info "GitHub is reachable."
fi

# ── 2. Xcode Command Line Tools ───────────────────────────────────────────────
step "Xcode Command Line Tools..."
if ! xcode-select -p &>/dev/null; then
    xcode-select --install
    echo ""
    warn "Xcode CLT installer launched. Complete it, then re-run this script."
    exit 0
else
    info "Already installed at $(xcode-select -p)"
fi

# ── 3. Homebrew ───────────────────────────────────────────────────────────────
step "Homebrew..."
if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Ensure brew is in PATH (Apple Silicon)
if [[ "$(uname -m)" == "arm64" ]] && [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

brew update --quiet
info "Homebrew $(brew --version | head -1)"

# ── 4. CLI tools ──────────────────────────────────────────────────────────────
step "Installing CLI tools..."
CLI_TOOLS=(fish neovim tmux cmake fzf ripgrep fd llvm)
brew install "${CLI_TOOLS[@]}"

# ── 5. vcpkg ──────────────────────────────────────────────────────────────────
step "vcpkg..."
VCPKG_DIR="$HOME/vcpkg"
if [[ ! -d "$VCPKG_DIR" ]]; then
    git clone https://github.com/microsoft/vcpkg.git "$VCPKG_DIR"
    "$VCPKG_DIR/bootstrap-vcpkg.sh" -disableMetrics
    info "vcpkg bootstrapped at $VCPKG_DIR"
else
    info "vcpkg already present at $VCPKG_DIR"
fi

# ── 6. Essential casks ────────────────────────────────────────────────────────
step "Installing essential casks (iterm2, aerospace)..."
_install_cask() {
    if brew list --cask "$1" &>/dev/null; then
        info "$1 already installed"
    else
        brew install --cask "$1"
    fi
}
_install_cask iterm2
brew tap nikitabobko/tap
_install_cask nikitabobko/tap/aerospace

# ── 6b. Catppuccin color schemes for iTerm2 ──────────────────────────────────
step "Catppuccin themes for iTerm2..."
for _flavor in frappe latte macchiato mocha; do
    curl -sLo "/tmp/catppuccin-${_flavor}.itermcolors" \
        "https://github.com/catppuccin/iterm/raw/main/colors/catppuccin-${_flavor}.itermcolors"
    open "/tmp/catppuccin-${_flavor}.itermcolors"
done
info "All four Catppuccin flavors imported into iTerm2"

# ── 7. Fish as default shell ──────────────────────────────────────────────────
step "Setting fish as default shell..."
FISH_BIN="$(command -v fish)"
if ! grep -qF "$FISH_BIN" /etc/shells; then
    echo "$FISH_BIN" | sudo tee -a /etc/shells
fi
if [[ "$SHELL" != "$FISH_BIN" ]]; then
    chsh -s "$FISH_BIN"
    info "Default shell changed to fish — re-login or run 'exec fish'"
else
    info "Fish is already the default shell"
fi

# ── 8. Symlinks ───────────────────────────────────────────────────────────────
step "Creating symlinks..."

_link() {
    local src="$1" dst="$2"
    if [[ ! -e "$src" ]]; then
        warn "Source not found, skipping: $src"
        return
    fi
    mkdir -p "$(dirname "$dst")"
    if [[ -L "$dst" ]]; then
        rm "$dst"
    elif [[ -e "$dst" ]]; then
        mv "$dst" "${dst}.bak"
        warn "Backed up existing file to ${dst}.bak"
    fi
    ln -s "$src" "$dst"
    info "Linked: $dst -> $src"
}

# tmux looks for .tmux.conf in $HOME, but the file lives inside the repo at tmux/.tmux.conf
_link "$DOTFILES_DIR/tmux/.tmux.conf"       "$HOME/.tmux.conf"
# quick-edit shortcut in home dir
_link "$DOTFILES_DIR/fish/config.fish"      "$HOME/config.fish"

# If the repo was NOT cloned directly as ~/.config, also wire up the config dirs.
# (Normal workflow: git clone <repo> ~/.config — no extra links needed.)
if [[ "$DOTFILES_DIR" != "$HOME/.config" ]]; then
    _link "$DOTFILES_DIR/fish/config.fish"          "$HOME/.config/fish/config.fish"
    _link "$DOTFILES_DIR/aerospace/aerospace.toml"  "$HOME/.config/aerospace/aerospace.toml"
    _link "$DOTFILES_DIR/nvim"                      "$HOME/.config/nvim"
fi

# ── 9. Tmux Plugin Manager ────────────────────────────────────────────────────
step "Tmux Plugin Manager (TPM)..."
TPM_DIR="$HOME/.config/tmux/plugins/tpm"
if [[ ! -d "$TPM_DIR" ]]; then
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    info "TPM installed"
else
    info "TPM already present"
fi

# ── 10. Tmux plugins (catppuccin, etc.) ───────────────────────────────────────
step "Installing tmux plugins via TPM..."
# TPM reads the config from TMUX_CONF or ~/.tmux.conf
TMUX_CONF="$HOME/.tmux.conf"
if [[ -f "$TMUX_CONF" ]] || [[ -f "$HOME/.config/tmux/tmux.conf" ]]; then
    TMUX_PLUGIN_MANAGER_PATH="$HOME/.config/tmux/plugins" \
        "$TPM_DIR/bin/install_plugins" || warn "TPM install_plugins returned non-zero (may be fine)"
else
    warn "No tmux config found — skipping plugin install. Run prefix+I inside tmux later."
fi

# ── 11. Nerd font ─────────────────────────────────────────────────────────────
step "Code New Roman Nerd Font..."
_install_cask font-code-new-roman-nerd-font

# ── 12. iTerm2 shell integration ─────────────────────────────────────────────
step "iTerm2 shell integration..."
ITERM2_INT="$HOME/.iterm2_shell_integration.bash"
if [[ ! -f "$ITERM2_INT" ]]; then
    curl -sL https://iterm2.com/shell_integration/install_shell_integration_and_utilities.sh | bash
else
    info "Shell integration already installed"
fi

# ── 13. fish: add paths ───────────────────────────────────────────────────────
step "Configuring fish universal PATH..."
fish -c "fish_add_path /opt/homebrew/bin" 2>/dev/null || true
fish -c "fish_add_path $VCPKG_DIR" 2>/dev/null || true
info "Paths added for homebrew and vcpkg"

# ── 14. macOS sensible defaults ───────────────────────────────────────────────
step "Applying macOS defaults..."
defaults write com.apple.finder AppleShowAllFiles -bool true          # Show hidden files
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false    # Key repeat
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write com.apple.dock autohide -bool true                     # Auto-hide dock
defaults write com.apple.dock show-recents -bool false
killall Finder 2>/dev/null || true
killall Dock   2>/dev/null || true
info "Done (Finder + Dock restarted)"

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}✓ Core setup complete!${NC}"
echo ""
echo "  Next steps:"
echo "    1. Re-login (or: exec fish) to switch to fish shell"
echo "    2. Open tmux, press prefix+I to install any remaining plugins"
echo "    3. Run ${CYAN}./setup_apps.sh${NC} to install large apps (Chrome, VSCode, Cursor, WeChat)"
echo ""
