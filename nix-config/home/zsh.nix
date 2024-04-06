{ config, lib, pkgs, ... }:

let inherit (import ../../options.nix) flakeDir theShell hostname; in
lib.mkIf (theShell == "zsh") {
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    enableAutosuggestions = true;
    historySubstringSearch.enable = true;
    profileExtra = ''
      #if [ -z "$DISPLAY" ] && [ "$XDG_VNTR" = 1 ]; then
      #  exec Hyprland
      #fi
    '';
    initExtra = ''
      if type nproc &>/dev/null; then
        export MAKEFLAGS="$MAKEFLAGS -j$(($(nproc)-1))"
      fi
      bindkey '^[[3~' delete-char                     # Key Del
      bindkey '^[[5~' beginning-of-buffer-or-history  # Key Page Up
      bindkey '^[[6~' end-of-buffer-or-history        # Key Page Down
      bindkey '^[[1;3D' backward-word                 # Key Alt + Left
      bindkey '^[[1;3C' forward-word                  # Key Alt + Right
      bindkey '^[[H' beginning-of-line                # Key Home
      bindkey '^[[F' end-of-line                      # Key End
      bindkey '^F' autosuggest-accept                 # ctrl+f
      neofetch
      if [ -f $HOME/.zshrc-personal ]; then
        source $HOME/.zshrc-personal
      fi
      eval "$(starship init zsh)"
      eval "$(zoxide init zsh)"
    '';
    initExtraFirst = ''
      HISTFILE=~/.histfile
      HISTSIZE=1000
      SAVEHIST=1000
      setopt autocd nomatch
      unsetopt beep extendedglob notify
      autoload -Uz compinit
      compinit
    '';
    sessionVariables = {

    };
    shellAliases = {
      sv="sudo nvim";
      flake-rebuild="nh os switch --hostname ${hostname}";
      flake-update="nh os switch --hostname ${hostname} --update";
      gcCleanup="nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
      cd="z";
      v="nvim";
      ls="lsd";
      ll="lsd -al";
      la="lsd -a";
      lal="lsd -al";
      ".."="cd ..";
      neofetch="neofetch --ascii ~/.config/ascii-neofetch";
      history="history 0";
    };
  };
}
