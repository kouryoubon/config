set -g fish_greeting ''
set -gx EDITOR nvim

#Aliases
alias ll="ls -lh"
alias la="ls -a"
alias lla="ls -lha"
alias grep="grep --color=auto"
alias diff="diff --color=auto"
alias clang="/usr/bin/clang -Wall -Wextra -Wshadow -Wconversion -Wpedantic"
alias clang++="/usr/bin/clang++ -std=c++20 -Werror -Wall -Wextra -Wshadow -Wconversion -Wpedantic"
alias archivebox="docker compose -f ~/archivebox/docker-compose.yml run --remove-orphans archivebox"
alias p="python"
#alias cmake_export="cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1"

set -gx CLICOLOR 1
function fish_prompt
    set_color normal
    echo -n (whoami)"@"(hostname)": "(set_color cyan)(prompt_pwd)(set_color normal)" % "
end

# set -gx http_proxy http://127.0.0.1:7890
# set -gx https_proxy http://127.0.0.1:7890
# set -gx all_proxy socks5://127.0.0.1:7890

set -gx LANG en_US.UTF-8

set -gx HOMEBREW_API_DOMAIN https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api
set -gx HOMEBREW_BREW_GIT_REMOTE https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git
set -gx HOMEBREW_CORE_GIT_REMOTE https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git
set -gx HOMEBREW_BOTTLE_DOMAIN https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles
set -gx HOMEBREW_INSTALL_FROM_API 1

set -gx CC /opt/homebrew/opt/llvm/bin/clang
set -gx CXX /opt/homebrew/opt/llvm/bin/clang++
set -gx CMAKE_TOOLCHAIN_FILE /Users/k/vcpkg/scripts/buildsystems/vcpkg.cmake
set -gx CMAKE_EXPORT_COMPILE_COMMANDS 1
set -gx UV_DEFAULT_INDEX https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple
set -gx UV_INDEX https://mirrors.ustc.edu.cn/pypi/simple https://mirrors.aliyun.com/pypi/simple/


set -gx PYTHON_HISTORY $HOME/.cache/python/.python_hisotory

set -gx VCPKG_ROOT $HOME/vcpkg

set -gx LDFLAGS "-L/opt/homebrew/opt/llvm/lib"
set -gx CPPFLAGS "-I/opt/homebrew/opt/llvm/include"
set -gx CMAKE_PREFIX_PATH "/opt/homebrew/opt/llvm"


# if set -q COLORFGBG
#     set -l parts (string split ";" $COLORFGBG)
#     set -l bg (math $parts[-1])
#     if test $bg -gt 7
#         set -l fish_theme "Catppuccin Latte"
#     else
#         set -l fish_theme "Catppuccin Frappe"
#     end
# else
#     set -l fish_theme "Catppuccin Latte"
# end
#
# set -U fish_theme $fish_theme

fish_config theme choose "Catppuccin Mocha"

# fzf 
#fzf --fish | source 

### uv completion
uv generate-shell-completion fish | source

function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end

# some tricks
function ch 
	curl cheat.sh/$argv[1]
end

function d 
	date +"%m-%d %A %T"
end

thefuck --alias | source

# VI mode
function fish_user_key_bindings
    fish_default_key_bindings -M insert
    fish_vi_key_bindings --no-erase insert
end

eval "$(/opt/homebrew/bin/brew shellenv)"
# Added by Antigravity
fish_add_path /Users/k/.antigravity/antigravity/bin
fish_add_path /opt/homebrew/opt/llvm/bin
set -gx PATH ~/.local/bin $VCPKG_ROOT $PATH

source ~/Code/Python/.venv/bin/activate.fish
