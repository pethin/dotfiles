{ config, pkgs, ... }:

let
  pkgConfig = {
    allowUnfree = true;

    packageOverrides = pkgs: rec {
      nerdfonts = pkgs.nerdfonts.override {
        fonts = [
         "JetBrainsMono"
        ];
      };
    };

    permittedInsecurePackages = [];  
  };
  pkgsUnstable = import <nixpkgs-unstable> {
    config = pkgConfig;
  };

  user = builtins.getEnv "USER";
  home = builtins.getEnv "HOME";

  xdg_configHome = "${home}/.config";
  xdg_dataHome   = "${home}/.local/share";
  xdg_cacheHome  = "${home}/.cache";
in
{
  home = {
    username = user;
    homeDirectory = home; 

    sessionVariables = {
      DOTNET_CLI_TELEMETRY_OPTOUT = "1";
    };

    sessionPath = [
      "$HOME/.local/bin"
    ];

    packages = [
      pkgsUnstable.dotnet-sdk
      pkgsUnstable.gitAndTools.gitFull
      pkgsUnstable.git-lfs
      pkgsUnstable.jetbrains.rider
      pkgsUnstable.jetbrains.webstorm
      pkgsUnstable.kitty
      pkgsUnstable.nerdfonts
      pkgsUnstable.nodejs
      pkgsUnstable.poetry
      pkgsUnstable.python311
      pkgsUnstable.rectangle
      pkgsUnstable.vscodium
      pkgsUnstable.zsh
    ];

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "22.11";
  };

  fonts.fontconfig.enable = true;

  programs = {
    zsh = rec {
      enable = true;
      enableCompletion = false;
      enableAutosuggestions = true;
      dotDir = ".config/zsh";

      defaultKeymap = "emacs";
      initExtra = ''
        if [[ $TERM == "xterm-kitty" ]]
        then
          bindkey "\e[1;3D" backward-word
          bindkey "\e[1;3C" forward-word
        else
          bindkey "\e\e[D" backward-word
          bindkey "\e\e[C" forward-word
        fi
        bindkey "^[[H" beginning-of-line
        bindkey "^[[F" end-of-line
      '';
      shellAliases = {};
    };

    dircolors = {
      enable = true;
      enableZshIntegration = true;
    };

    exa = {
      package = pkgsUnstable.exa;
      enable = true;
      enableAliases = true;
    };

    fzf = {
      package = pkgsUnstable.fzf;
      enable = true;
      enableZshIntegration = true;
    };

    starship = {
      package = pkgsUnstable.starship;
      enable = true;
      enableZshIntegration = true;
    };

    neovim = {
      package = pkgsUnstable.neovim-unwrapped;
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };

    git = {
      enable = true;
      package = pkgsUnstable.gitAndTools.gitFull;

      userEmail = "peter@phn.sh";
      userName = "Peter Nguyen";

      extraConfig = {
        core = {
          autoclrf = "input";
          eol = "lf";
          symlinks = "true";
          trustctime = "false";
          precomposeunicode = "false";
          untrackedCache = "true";
        };
        pull = {
          rebase = "true";
        };
        fetch = {
          prune = "true";
        };
        merge = {
          conflictStyle = "zdiff3";
          log = "true";
        };
        sendemail = {
          smtpserver = "smtp.mail.me.com";
          smtpuser = "peter@phn.sh";
          smtpencryption = "tls";
          smtpserverport = "587";
          annotate = "yes";
        };
        format = {
          signOff = "yes";
        };
        init = {
          defaultBranch = "main";
        };
        color = {
          ui = "auto";
        };
        rerere = {
          enabled = "true";
          autoupdate = "true";
        };
        rebase = {
          autosquash = "true";
        };
        branch = {
          sort = "-committerdate";
        };
        diff = {
          renames = "copies";
        };
              "diff \"bin\"" = {
          textconv = "hexdump -v -C";
        };
        push = {
          followTags = true;
        };
      };

      attributes = [];
      ignores = [
        "*.pyc"
        ".DS_Store"
        "Desktop.ini"
        "._*"
        "Thumbs.db"
        ".Spotlight-V100"
        ".Trashes"
      ];

      lfs = {
        enable = true;
      };
    };
  
    kitty = {
      package = pkgsUnstable.kitty;
      enable = true;
      theme = "Tokyo Night Storm";
      font = {
        name = "JetBrainsMono Nerd Font Mono Regular";
        size = 12;
      };
      settings = {
        bold_font = "JetBrainsMono Nerd Font Mono Bold";
        italic_font = "JetBrainsMono Nerd Font Mono Italic";
        bold_italic_font = "JetBrainsMono Nerd Font Mono Bold Italic";
        update_check_interval = 0;
        tab_bar_style = "powerline";
        tab_bar_min_tabs = 1;
        tab_powerline_style = "slanted";
        tab_title_template = "\"  {fmt.fg.red}{bell_symbol}{activity_symbol}{fmt.fg.tab}{title}  \"";
        window_padding_width = 6;
      };
    };

    # Let Home Manager install and manage itself.
    home-manager.enable = true;
  };

  nixpkgs.config = pkgConfig;
}
