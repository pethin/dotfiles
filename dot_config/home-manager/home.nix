{ config, pkgs, ... }:

let
  user = "peter";
  home = "/Users/peter";

  xdg_configHome = "${home}/.config";
  xdg_dataHome   = "${home}/.local/share";
  xdg_cacheHome  = "${home}/.cache";
in
{
  imports = [
    ./darwin-application-activation.nix
  ];

  home = {
    username = "${user}";
    homeDirectory = "${home}";

    sessionVariables = {
      DOTNET_CLI_TELEMETRY_OPTOUT = "1";
      LDFLAGS = "-L${home}/.nix-profile/lib";
      CFLAGS = "-I${home}/.nix-profile/include";
      CPPFLAGS = "-I${home}/.nix-profile/include";
      LD_LIBRARY_PATH = "${home}/.nix-profile/lib";
      DYLD_LIBRARY_PATH = "${home}/.nix-profile/lib";
      C_INCLUDE_PATH = "${home}/.nix-profile/include";
      CPLUS_INCLUDE_PATH = "${home}/.nix-profile/include";
      PKG_CONFIG_PATH = "${home}/.nix-profile/lib/pkgconfig";
      LIBS = "-L${home}/.nix-profile/lib -Wl,-rpath,${home}/.nix-profile/lib";
      JAVA_HOME = "${home}/.jdks/${pkgs.temurin-bin-23.version}";
    };

    sessionPath = [
      "${home}/.local/bin"
      "${home}/.cargo/bin"
      "${home}/.deno/bin"
      "${home}/.jdks"
      "${home}/Library/Application Support/JetBrains/Toolbox/scripts"
    ];

    packages = [
      pkgs.bash
      pkgs.bzip2.bin
      pkgs.bzip2.dev
      pkgs.bzip2.out
      #pkgs.deno
      (with pkgs.dotnetCorePackages; combinePackages [
        sdk_8_0
      ])
      pkgs.ffmpeg-full
      pkgs.fnm
      pkgs.gitAndTools.gitFull
      pkgs.git-lfs
      pkgs.gitsign
      pkgs.gnupg
      pkgs.kind
      pkgs.kubectl
      pkgs.libffi.dev
      pkgs.libffi.out
      pkgs.libxml2.bin
      pkgs.libxml2.dev
      pkgs.libxml2.out
      pkgs.ncurses.out
      pkgs.ncurses.dev
      pkgs.nerd-fonts.jetbrains-mono
      pkgs.oci-cli
      pkgs.openssl.bin
      pkgs.openssl.dev
      pkgs.openssl.out
      pkgs.pkg-config
      pkgs.readline.dev
      pkgs.readline.out
      pkgs.rustup
      pkgs.sqlite.bin
      pkgs.sqlite.dev
      pkgs.sqlite.out
      pkgs.temurin-bin-23
      pkgs.tk.dev
      pkgs.tk.out
      pkgs.uv
      pkgs.wasmtime
      pkgs.xmlsec.out
      pkgs.xmlsec.dev
      pkgs.xz.bin
      pkgs.xz.dev
      pkgs.xz.out
      pkgs.zlib.dev
      pkgs.zlib.out
      pkgs.zsh
    ];

    file.".jdks/${pkgs.temurin-bin-21.version}".source = pkgs.temurin-bin-21;

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "24.05";
  };

  fonts.fontconfig.enable = true;

  programs = {
    zsh = rec {
      enable = true;
      enableCompletion = true;
      autosuggestion = {
        enable = true;
      };
      syntaxHighlighting = {
        enable = true;
      };
      dotDir = ".config/zsh";

      defaultKeymap = "emacs";
      initExtra = ''
        if [[ -a "$WEZTERM_EXECUTABLE_DIR/../Resources/wezterm.sh" ]]; then
          source "$WEZTERM_EXECUTABLE_DIR/../Resources/wezterm.sh"
        fi

        if [[ $TERM == "xterm-"* ]]
        then
          bindkey "\e[1;3D" backward-word
          bindkey "\e[1;3C" forward-word
        else
          bindkey "\e\e[D" backward-word
          bindkey "\e\e[C" forward-word
        fi
        bindkey "^[[H" beginning-of-line
        bindkey "^[[F" end-of-line

        eval "$(fnm env --use-on-cd)"
      '';

      shellAliases = {
        nix-home-update = "nix flake update --flake ~/.config/home-manager && home-manager switch";
        cp = "cp -c";
      };

      envExtra = ''
        export SSH_AUTH_SOCK="$(launchctl getenv SSH_AUTH_SOCK)"
      '';
    };

    bat = {
      enable = true;
    };

    dircolors = {
      enable = true;
      enableZshIntegration = true;
    };

    eza = {
      package = pkgs.eza;
      enable = true;
      enableZshIntegration = true;
      git = true;
    };

    fzf = {
      package = pkgs.fzf;
      enable = true;
      enableZshIntegration = true;
    };

    starship = {
      package = pkgs.starship;
      enable = true;
      enableZshIntegration = true;
    };

    helix = {
      package = pkgs.helix;
      enable = true;
      defaultEditor = true;
    };

    ssh = {
      enable = true;
      addKeysToAgent = "yes";
      extraConfig = ''
        IgnoreUnknown UseKeychain
        UseKeychain yes
      '';
    };

    git = {
      enable = true;
      package = pkgs.gitAndTools.gitFull;

      userEmail = "peter@phn.sh";
      userName = "Peter Nguyen";

      signing = {
        signer = "${pkgs.gnupg}/bin/gpg2";
        key = "EC65AD5C0718F688BE8677D5009A5BD1B3A9F56D";
        signByDefault = true;
      };

      extraConfig = {
        gpg = {
          x509 = {
            program = "${pkgs.gitsign}/bin/gitsign";
          };
        };
        tag = {
          forceSignAnnotated = "true";
        };
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

    wezterm = {
      package = pkgs.zsh;
      enable = true;
      enableBashIntegration = false;
      enableZshIntegration = false;
      extraConfig = ''
        -- This table will hold the configuration.
        local config = {}

        -- In newer versions of wezterm, use the config_builder which will
        -- help provide clearer error messages
        if wezterm.config_builder then
          config = wezterm.config_builder()
        end

        config.initial_cols = 120
        config.initial_rows = 30

        config.font = wezterm.font("JetBrains Mono")
        config.color_scheme = "tokyonight-storm"

        config.enable_kitty_keyboard = true

        config.unix_domains = {
          {
            name = 'unix',
          },
        }

        -- This causes `wezterm` to act as though it was started as
        -- `wezterm connect unix` by default, connecting to the unix
        -- domain on startup.
        config.default_gui_startup_args = { 'connect', 'unix' }

        return config
      '';
    };

    # Let Home Manager install and manage itself.
    home-manager.enable = true;
  };

  targets = {
    darwin = {
      defaults = {
        "Apple Global Domain" = {
          # Always show scrollbars
          AppleShowScrollBars = "Always";

          # Don't automatically switch to a space when switching applications
          AppleSpacesSwitchOnActivate = false;

          # Disable the over-the-top focus ring animation
          NSUseAnimatedFocusRing = false;

          # Adjust toolbar title rollover delay
          NSToolbarTitleViewRolloverDelay = 0.0;

          # Increase window resize speed for Cocoa applications
          NSWindowResizeTime = 0.001;

          # Expand save panel by default
          NSNavPanelExpandedStateForSaveMode = true;
          NSNavPanelExpandedStateForSaveMode2 = true;

          # Expand print panel by default
          PMPrintingExpandedStateForPrint = true;
          PMPrintingExpandedStateForPrint2 = true;

          # Save to disk (not to iCloud) by default
          NSDocumentSaveNewDocumentsToCloud = false;

          # Display ASCII control characters using caret notation in standard text views
          # Try e.g. `cd /tmp; unidecode "\x{0000}" > cc.txt; open -e cc.txt`
          NSTextShowsControlCharacters = true;

          # Enable automatic termination of inactive apps
          NSDisableAutomaticTermination = false;

          # Disable automatic capitalization as it’s annoying when typing code
          NSAutomaticCapitalizationEnabled = false;

          # Disable smart dashes as they’re annoying when typing code

          # Disable automatic period substitution as it’s annoying when typing code
          NSAutomaticPeriodSubstitutionEnabled = false;

          # Disable smart quotes as they’re annoying when typing code
          NSAutomaticQuoteSubstitutionEnabled = false;

          # Disable auto-correct
          NSAutomaticSpellingCorrectionEnabled = false;

          # Enable full keyboard access for all controls
          # (e.g. enable Tab in modal dialogs)
          AppleKeyboardUIMode = 3;

          # Disable press-and-hold for keys in favor of key repeat
          ApplePressAndHoldEnabled = false;

          # Set a blazingly fast keyboard repeat rate
          KeyRepeat = 1;
          InitialKeyRepeat = 15;

          "com.apple.keyboard.fnState" = true;

          # Enable subpixel font rendering on non-Apple LCDs
          # Reference: https://github.com/kevinSuttle/macOS-Defaults/issues/17#issuecomment-266633501
          AppleFontSmoothing = 1;

          # Finder: show all filename extensions
          AppleShowAllExtensions = true;

          # Add a context menu item for showing the Web Inspector in web views
          WebKitDeveloperExtras = true;

          NSPreferredWebServices = {
	          NSWebServicesProviderWebSearch = {
	            NSDefaultDisplayName = "Google";
              NSProviderIdentifier = "com.google.www";
	          };
	        };
        };
        "com.apple.Siri" = {
          ConfirmSiriInvokedViaEitherCmdTwice = false;
          StatusMenuVisible = true;
        };
        "com.apple.assistant.support" = {
          "Search Queries Data Sharing Status" = 2;
          "Siri Data Sharing Opt-In Status" = 2;
        };
        "com.apple.LaunchServices" = {
          # Disable the “Are you sure you want to open this application?” dialog
          LSQuarantine = false;
        };
        "com.apple.WindowManager" = {
          GloballyEnabled = false;
          AppWindowGroupingBehavior = true;
          AutoHide = true;
          EnableStandardClickToShowDesktop = true;
          HideDesktop = true;
          StageManagerHideWidgets = true;
          StandardHideDesktopIcons = false;
          StandardHideWidgets = false;
        };
        "com.apple.print.PrintingPrefs" = {
          # Automatically quit printer app once the print jobs complete
          "Quit When Finished" = true;
        };
        "com.apple.BluetoothAudioAgent" = {
          # Increase sound quality for Bluetooth headphones/headsets
          "Apple Bitpool Min (editable)" = 40;
        };
        "com.apple.screensaver" = {
          # Require password immediately after sleep or screen saver begins
          askForPassword = 1;
          askForPasswordDelay = 0;
        };
        "com.apple.screencapture" = {
          # Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
          type = "png";

          # Disable shadow in screenshots
          disable-shadow = true;
        };
        "com.apple.finder" = {
          # Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
          QuitMenuItem = true;

          # Finder: disable window animations and Get Info animations
          DisableAllAnimations = true;

          # Set Home as the default location for new Finder windows
          # For other paths, use `PfLo` and `file:///full/path/here/`
          NewWindowTarget = "PfLo";
          NewWindowTargetPath = "file:///${home}/";

          # Finder: show status bar
          ShowStatusBar = true;

          # Finder: show path bar
          ShowPathbar = true;

          # Display full POSIX path as Finder window title
          _FXShowPosixPathInTitle = true;

          # Keep folders on top when sorting by name
          _FXSortFoldersFirst = true;

          # When performing a search, search the current folder by default
          FXDefaultSearchScope = "SCcf";

          # Disable the warning when changing a file extension
          FXEnableExtensionChangeWarning = false;

          # Automatically open a new Finder window when a volume is mounted
          OpenWindowForNewRemovableDisk = true;

          # Use list view in all Finder windows by default
          # Four-letter codes for the other view modes: `icnv`, `clmv`, `glyv`
          FXPreferredViewStyle = "Nlsv";
        };
        "com.apple.desktopservices" = {
          # Avoid creating .DS_Store files on network or USB volumes
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };
        "com.apple.frameworks.diskimages" = {
          auto-open-ro-root = true;
          auto-open-rw-root = true;
        };
        "com.apple.NetworkBrowser" = {
          # Enable AirDrop over Ethernet and on unsupported Macs running Lion
          BrowseAllInterfaces = true;
        };
        "com.apple.dock" = {
          # Change minimize/maximize window effect
          mineffect = "scale";

          # Don’t animate opening applications from the Dock
          launchanim = false;

          # Speed up Mission Control animations
          expose-animation-duration = 0.1;
        };
        "com.apple.Safari" = {
          # Restore Session
          AlwaysRestoreSessionAtLaunch = true;
          OpenPrivateWindowWhenNotRestoringSessionAtLaunch = false;
          ExcludePrivateWindowWhenRestoringSessionAtLaunch = true;

          # Set Safari’s home page to `about:blank` for faster loading
          HomePage = "about:blank";

          # Prevent Safari from opening ‘safe’ files automatically after downloading
          AutoOpenSafeDownloads = false;

          # Separate tabs
          ShowStandaloneTabBar = true;
          EnableNarrowTabs = false;

          # AutoFill
          AutoFillFromAddressBook = true;
          AutoFillPasswords = true;
          AutoFillCreditCardData = true;
          AutoFillMiscellaneousForms = true;

          # Set search provider
          SearchProviderShortName = "Google";
          PrivateSearchEngineUsesNormalSearchEngineToggle = false;
          PrivateSearchProviderShortName = "Ecosia";
          WBSOfflineSearchSuggestionsModelGoogleWasDefaultSearchEngineKey = true;

          # Don’t send search queries to Apple
          UniversalSearchEnabled = false;

          # Disable website specific search
          WebsiteSpecificSearchEnabled = false;

          # Disable search preload
          PreloadTopHit = false;

          # Keep search suggestions
          SuppressSearchSuggestions = false;

          # Search favorites
          ShowFavoritesUnderSmartSearchField = true;

          # Show the full URL in the address bar (note: this still hides the scheme)
          ShowFullURLInSmartSearchField = true;

          # Warn about fraudulent websites
          WarnAboutFraudulentWebsites = true;

          # Prevent cross-site tracking
          BlockStoragePolicy = 2;
          "WebKitPreferences.storageBlockingPolicy" = 1;
          WebKitStorageBlockingPolicy = 1;

          # Hide IP from trackers in Safari and Mail (iCloud Private Relay)
          WBSPrivacyProxyAvailabilityTraffic = 66977004;

          # Disable ad effectiveness measurement
          "WebKitPreferences.privateClickMeasurementEnabled" = false;

          # Press Tab to highlight each item on a web page
          WebKitTabToLinksPreferenceKey = true;
          "com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks" = true;

          # Allow hitting the Backspace key to go to the previous page in history
          "com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled" = true;

          # Hide Safari’s bookmarks bar by default
          ShowFavoritesBar = false;

          # Hide Safari’s sidebar in Top Sites
          ShowSidebarInTopSites = false;

          # Disable Safari’s thumbnail cache for History and Top Sites
          DebugSnapshotsUpdatePolicy = 2;

          # Enable Safari’s develop menu
          IncludeDevelopMenu = true;
          WebKitDeveloperExtrasEnabledPreferenceKey = true;
          "WebKitPreferences.developerExtrasEnabled" = true;

          # Enable Safari’s debug menu
          IncludeInternalDebugMenu = true;

          # Make Safari’s search banners default to Contains instead of Starts With
          FindOnPageMatchesWordStartsOnly = false;

          # Remove useless icons from Safari’s bookmarks bar
          ProxiesInBookmarksBar = "()";

          # Enable continuous spellchecking
          WebContinuousSpellCheckingEnabled = true;

          # Disable auto-correct
          WebAutomaticSpellingCorrectionEnabled = false;

          # Disable plug-ins
          WebKitPluginsEnabled = false;
          "com.apple.Safari.ContentPageGroupIdentifier.WebKit2PluginsEnabled" = false;

          # Disable Java
          WebKitJavaEnabled = false;
          "com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled" = false;
          "com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabledForLocalFiles" = false;

          # Block pop-up windows
          WebKitJavaScriptCanOpenWindowsAutomatically = false;
          "com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically" = false;

          # Enable “Do Not Track”
          SendDoNotTrackHTTPHeader = true;

          # Update extensions automatically
          InstallExtensionUpdatesAutomatically = true;
        };
        "com.apple.mail" = {
          # Auto retry sending mail
          SuppressDeliveryFailure = true;

          # Disable send and reply animations in Mail.app
          DisableReplyAnimations = true;
          DisableSendAnimations = true;

          # Disable inline attachments (just show the icons)
          DisableInlineAttachmentViewing = true;

          # Auto reply format
          AutoReplyFormat = true;

          # Spell checking
          SpellCheckingBehavior = "InlineSpellCheckingEnabled";
        };
        "com.apple.mail-shared" = {
          # Disable smart addresses
          AddressDisplayMode = 3;
          AlertForNonmatchingDomains = false;
          ExpandPrivateAliases = true;
        };
        "com.apple.spotlight" = {
          # Disable web search
          orderedItems = [
            {
              enabled = 1;
              name = "APPLICATIONS";
            }
            {
              enabled = 1;
              name = "MENU_EXPRESSION";
            }
            {
              enabled = 1;
              name = "CONTACT";
            }
            {
              enabled = 1;
              name = "MENU_CONVERSION";
            }
            {
              enabled = 1;
              name = "MENU_DEFINITION";
            }
            {
              enabled = 1;
              name = "SOURCE";
            }
            {
              enabled = 1;
              name = "DOCUMENTS";
            }
            {
              enabled = 1;
              name = "EVENT_TODO";
            }
            {
              enabled = 1;
              name = "DIRECTORIES";
            }
            {
              enabled = 1;
              name = "FONTS";
            }
            {
              enabled = 1;
              name = "IMAGES";
            }
            {
              enabled = 1;
              name = "MESSAGES";
            }
            {
              enabled = 1;
              name = "MOVIES";
            }
            {
              enabled = 1;
              name = "MUSIC";
            }
            {
              enabled = 1;
              name = "MENU_OTHER";
            }
            {
              enabled = 1;
              name = "PDF";
            }
            {
              enabled = 1;
              name = "PRESENTATIONS";
            }
            {
              enabled = 0;
              name = "MENU_SPOTLIGHT_SUGGESTIONS";
            }
            {
              enabled = 1;
              name = "SPREADSHEETS";
            }
            {
              enabled = 1;
              name = "SYSTEM_PREFS";
            }
            {
              enabled = 0;
              name = "TIPS";
            }
            {
              enabled = 0;
              name = "BOOKMARKS";
            }
          ];
        };
        "com.apple.terminal" = {
          # Only use UTF-8 in Terminal.app
          StringEncodings = [4];

          # Enable Secure Keyboard Entry in Terminal.app
          SecureKeyboardEntry = true;

          # Disable the annoying line marks
          ShowLineMarks = 0;
        };
        "com.apple.TimeMachine" = {
          # Prevent Time Machine from prompting to use new hard drives as backup volume
          DoNotOfferNewDisksForBackup = true;
        };
        "com.apple.ActivityMonitor" = {
          # Show the main window when launching Activity Monitor
          OpenMainWindow = true;

          # Visualize CPU usage in the Activity Monitor Dock icon
          IconType = 5;

          # Show all processes in Activity Monitor
          ShowCategory = 0;

          # Sort Activity Monitor results by CPU usage
          SortColumn = "CPUUsage";
          SortDirection = 0;
        };
        "com.apple.addressbook" = {
          # Enable the debug menu in Address Book
          ABShowDebugMenu = true;
        };
        "com.apple.dashboard" = {
          # Enable Dashboard dev mode (allows keeping widgets on the desktop)
          devmode = true;
        };
        "com.apple.TextEdit" = {
          # Use plain text mode for new TextEdit documents
          RichText = 0;

          # Open and save files as UTF-8 in TextEdit
          PlainTextEncoding = 4;
          PlainTextEncodingForWrite = 4;
        };
        "com.apple.DiskUtility" = {
          # Enable the debug menu in Disk Utility
          DUDebugMenuEnabled = true;
          advanced-image-options = true;
        };
        "com.apple.QuickTimePlayerX" = {
          # Auto-play videos when opened with QuickTime Player
          MGPlayMovieOnOpen = true;
        };
        "com.apple.appstore" = {
          # Enable the WebKit Developer Tools in the Mac App Store
          WebKitDeveloperExtras = true;

          # Enable Debug Menu in the Mac App Store
          ShowDebugMenu = true;
        };
        "com.apple.SoftwareUpdate" = {
          # Enable the automatic update check
          AutomaticCheckEnabled = true;

          # Check for software updates daily, not just once per week
          ScheduleFrequency = 1;

          # Download newly available updates in background
          AutomaticDownload = 1;

          # Install System data files & security updates
          CriticalUpdateInstall = 1;
        };
        "com.apple.commerce" = {
          # Turn on app auto-update
          AutoUpdate = true;

          # Allow the App Store to reboot machine on macOS updates
          AutoUpdateRestartRequired = true;
        };
        "com.apple.ImageCapture" = {
          # Prevent Photos from opening automatically when devices are plugged in
          disableHotPlug = true;
        };
        "com.google.Chrome" = {
          # Use the system-native print preview dialog
          DisablePrintPreview = true;

          # Expand the print dialog by default
          PMPrintingExpandedStateForPrint2 = true;
        };
        "com.google.Chrome.canary" = {
          # Use the system-native print preview dialog
          DisablePrintPreview = true;

          # Expand the print dialog by default
          PMPrintingExpandedStateForPrint2 = true;
        };
        "org.m0k.transmission" = {
          # Use `~/Downloads/IncompleteTorrents` to store incomplete downloads
          UseIncompleteDownloadFolder = true;
          IncompleteDownloadFolder = "${home}/Downloads/IncompleteTorrents";

          # Use `~/Downloads` to store completed downloads
          DownloadLocationConstant = true;

          # Don’t prompt for confirmation before downloading
          DownloadAsk = false;
          MagnetOpenAsk = false;

          # Don’t prompt for confirmation before removing non-downloading active transfers
          CheckRemoveDownloading = true;

          # Trash original torrent files
          DeleteOriginalTorrent = true;

          # Hide the donate message
          WarningDonate = false;

          # Hide the legal disclaimer
          WarningLegal = false;

          # IP block list.
          BlocklistNew = true;
          BlocklistURL = "https://raw.githubusercontent.com/ktsaou/blocklist-ipsets/master/firehol_level1.netset";
          BlocklistAutoUpdate = true;

          # Require encryption
          EncryptionRequire = true;

          # Randomize port on launch
          RandomPort = true;
        };
      };
    };
  };
}
