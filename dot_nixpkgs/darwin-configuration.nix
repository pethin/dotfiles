{ config, pkgs, ... }:

let home = builtins.getEnv "HOME";

    xdg_configHome = "${home}/.config";
    xdg_dataHome   = "${home}/.local/share";
    xdg_cacheHome  = "${home}/.cache";
in {
  imports = [ <home-manager/nix-darwin> ];

  services = {
    nix-daemon.enable = true;
  };

  environment = {
    systemPackages = [
      pkgs.coreutils
      pkgs.exa
      pkgs.kitty
      pkgs.rectangle
    ];
  };

  users = {
    users.peter = {
      name = "peter";
      home = "/Users/peter";
      shell = pkgs.zsh;
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    
    users.peter = {
      home = {
        stateVersion = "22.11";

        sessionVariables = {
	  DOTNET_CLI_TELEMETRY_OPTOUT = "1";
	};

        sessionPath = [
          "$HOME/.local/bin"
        ];

        packages = [
          pkgs.dotnet-sdk
	  pkgs.fzf
	  pkgs.gitAndTools.gitFull
          pkgs.git-lfs
	  pkgs.nerdfonts
	  pkgs.neovim-unwrapped
	  pkgs.nodejs
	  pkgs.poetry
	  pkgs.python311
	  pkgs.starship
          pkgs.zsh
        ];
      };

      fonts.fontconfig.enable = true;

      programs = {
        zsh = rec {
          enable = true;
          enableCompletion = false;
          enableAutosuggestions = true;
          dotDir = ".config/zsh";

	  shellAliases = {};
        };

        dircolors = {
	  enable = true;
	  enableZshIntegration = true;
	};

	exa = {
	  enable = true;
	  enableAliases = true;
	};

        fzf = {
          enable = true;
          enableZshIntegration = true;
        };

        starship = {
          enable = true;
          enableZshIntegration = true;
        };

        neovim = {
          enable = true;
          viAlias = true;
          vimAlias = true;
          vimdiffAlias = true;
        };

	git = {
	  enable = true;
	  package = pkgs.gitAndTools.gitFull;

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
      };
    };
  };

  nix.package = pkgs.nixStable;

  nixpkgs.config = {
    packageOverrides = pkgs: {
      nerdfonts = pkgs.nerdfonts.override {
        fonts = [
          "JetBrainsMono"
        ];
      };
    };
  };


  programs = {
    zsh = {
      # Create /etc/zshrc that loads the nix-darwin environment.
      enable = true;
      enableCompletion = false;
    };
  };

  system = {
    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 4;
  };
}
