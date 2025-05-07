export CLICOLOR=1
export PS1='%n@%m:%{%F{cyan}%} %~ %{%f%}%% '

export http_proxy="127.0.0.1:7890"
export https_proxy="127.0.0.1:7890"
export all_proxy="127.0.0.1:7890"
export LANG=en_US.UTF-8
export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
export HOMEBREW_INSTALL_FROM_API=1
export VCPKG_ROOT="$HOME/vcpkg"

# llvm
export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export CC="opt/homebrew/opt/llvm/bin/clang"
export CXX="opt/homebrew/opt/llvm/bin/clang++"

# caching
export ZSH_COMPDUMP="$HOME/.cache/zsh/zcompdump-$HOST"
export PYTHON_HISTORY="$HOME/.cache/python/.python_history"

export HISTFILE="$HOME/.cache/zsh/.zsh_history"
export HISTSIZE=5000
export SAVEHIST=5000
export HISTCONTROL=ignoredups
setopt append_history
setopt share_history

alias l="ls"
alias la="ls -a"
alias ll="ls -l"
alias lla="ls -la"
alias vim="nvim"
alias python3="/opt/homebrew/Caskroom/miniconda/base/bin/python"
alias clang="/opt/homebrew/opt/llvm/bin/clang -Werror -Wall -Wextra -Wshadow -Wconversion -Wpedantic"
alias clang++="/opt/homebrew/opt/llvm/bin/clang++ -std=c++20 -Werror -Wall -Wextra -Wshadow -Wconversion -Wpedantic"

# preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR="vim"
else
  export EDITOR="nvim"
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

eval "$(/opt/homebrew/bin/brew shellenv)"
source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh 
source $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/.zsh/catppuccin/catppuccin_latte-zsh-syntax-highlighting.zsh
