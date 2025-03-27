#!/bin/zsh

export http_proxy="127.0.0.1:7890"
export https_proxy="127.0.0.1:7890"
export all_proxy="127.0.0.1:7890"

# test curling
curl -s --head --request GET google.com > /dev/null

if [[ $? -ne 0 ]]; then
  echo "Bad networking. Aborting."
  exit 1
fi

#homebrew

#terminal
echo "Configuring Zsh\n"
if [[ -d "$HOME/.zsh/zsh-syntax-highlighting" ]]; then
  echo "Zsh-syntax-highlighting exists, skipping\n"
else
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.zsh/zsh-syntax-highlighting
echo ""
fi

if [[ -d "$HOME/.zsh/zsh-autosuggestions" ]]; then
  echo "Zsh-autosuggestions exists, skipping\n"
else
git clone https://github.com/zsh-users/zsh-autosuggestions.git $HOME/.zsh/zsh-autosuggestions
echo ""
fi

if [[ -d "$HOME/.zsh/catppuccin" ]]; then
  echo "Catppuccin exists, skipping\n"
else
git clone https://github.com/catppuccin/zsh-syntax-highlighting.git $HOME/.zsh/catppuccin
mv $HOME/.zsh/catppuccin/themes/ $HOME/.zsh/themes/
rm -rf $HOME/.zsh/catppuccin/*
cp $HOME/.zsh/themes/* $HOME/.zsh/catppuccin/
rm -rf $HOME/.zsh/themes/
echo ""
fi

source $HOME/.zshrc
