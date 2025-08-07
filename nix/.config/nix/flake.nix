{
  description = "Vincent's nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # https://github.com/zhaofengli/nix-homebrew
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # Optional: Declarative tap management
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    # https://wiki.nixos.org/wiki/Spicetify-Nix
    # spicetify-nix.url = "github:Gerg-L/spicetify-nix";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, homebrew-core, homebrew-cask, ... }:
  let
    configuration = { pkgs, config, ... }: {

      nixpkgs.config.allowUnfree = true;

      system.primaryUser = "vincent";

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = with pkgs; [ 
          # jdk
          # tailscale # Also available via AppStore
          # vscode
          bat
          btop
          docker
          dotnet-sdk
          duf # Alternative to df
          dust # Check disk size
          exiftool # Metadata info
          eza # Better ls
          fastfetch # Better than neofetch
          fd
          firefox
          fish
          fnm # Fast Node Manager
          fzf # Fuzzyfinder
          glow # Render MD on CLI
          htop
          hyperfine # Benchmarking
          lazygit
          navi # CLI Cheatsheets
          neovim
          nerd-fonts.jetbrains-mono
          ngrok
          obsidian
          oh-my-posh
          pipx
          pnpm
          pyenv
          qbittorrent
          ripgrep
          rustup
          scc # Count lines of code
          stow
          supabase-cli
          tesseract # OCR package
          web-ext # Web Extension Testing Tool
          yazi # CLI File Manager
          zoom-us
          zoxide # Better cd
      ] ++ lib.optionals pkgs.stdenv.isDarwin [
          mkalias # Create finder aliases
          karabiner-elements # Customize Keyboard
          raycast
      ];

      # programs.tmux = {
      #     enable = true;
      #     extraConfig = builtins.readFile /Users/vincent/.config/tmux/tmux.conf;
      # };

      homebrew = {
        enable = true;
        taps = builtins.attrNames config.nix-homebrew.taps; # Prevents untap on "zap"
        brews = [
          "mas" # Search Mac Apps over CLI
          "tmux"
        ];
        casks = [
          "activitywatch"
          "iina" # Better video player
          "jordanbaird-ice" # Clean up menu bar 
          "lulu" # Firewall
          "mac-mouse-fix" # Mouse scroll smoothing
          "minecraft"
          "minecraft-server"
          "omnidisksweeper"
          "pearcleaner" # Clean up Install remnants
          "temurin" # Java for Minecraft-server
          "tor-browser"
        ];
        masApps = {
          "LocalSend" = 1661733229;
          "NextDNS" = 1464122853;
          "TailScale" = 1475387142;
          "Telegram" = 747648890;
          "WhatsApp Messenger" = 310633997;
          # "Toggl Track" = 1291898086;
        };
        onActivation.cleanup = "zap";
        onActivation.autoUpdate = true;
        onActivation.upgrade = true;
      };

      # https://unix.stackexchange.com/questions/384040/how-to-change-the-default-shell-in-nixos      
      users.users.vincent = {   
        shell = pkgs.fish;
      };

      fonts.packages = [
        pkgs.nerd-fonts.jetbrains-mono
      ];

      # https://gist.github.com/elliottminns/211ef645ebd484eb9a5228570bb60ec3
      system.activationScripts.applications.text = let
        env = pkgs.buildEnv {
          name = "system-applications";
          paths = config.environment.systemPackages;
          pathsToLink = "/Applications";
        };
      in
        pkgs.lib.mkForce ''
        # Set up applications.
        echo "setting up /Applications..." >&2
        rm -rf /Applications/Nix\ Apps
        mkdir -p /Applications/Nix\ Apps
        find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
        while read -r src; do
          app_name=$(basename "$src")
          echo "copying $src" >&2
          ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
        done
        '';

      # Run `darwin-help` to find available system settings
      system.defaults = {
        NSGlobalDomain."com.apple.trackpad.scaling" = 3.0; # High Trackpad speed
        NSGlobalDomain.AppleEnableSwipeNavigateWithScrolls = false;  # Disable swipe with 2 fingers to navigate back and forth
        NSGlobalDomain.AppleShowAllFiles = true; # Show hidden files
        NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = false; # No period on double space
        dock.autohide = true;
        dock.launchanim = false;
        finder.AppleShowAllExtensions = true;
        finder.AppleShowAllFiles = true; # Show hidden files
        finder.ShowPathbar = true; # Show breadcrumbs in Finder
        finder.ShowStatusBar = true; # Show disk space stats
        loginwindow.LoginwindowText = "Rise and Grind!";
        screencapture.location = "~/Pictures/screenshots";
        screensaver.askForPassword = true;
        screensaver.askForPasswordDelay = 0;
      };
      security.pam.services.sudo_local = {
        touchIdAuth = true; # Enable TouchID for Sudo
        reattach = true; # Enable TouchID in Tmux
      };
      system.keyboard = {
        remapCapsLockToEscape = true;
        enableKeyMapping = true;
      };
      networking.applicationFirewall = {
        enable = true;
        enableStealthMode = true;
      };

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#moneymachine
    darwinConfigurations."moneymachine" = nix-darwin.lib.darwinSystem {
      modules = [ 
        configuration
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            # Install Homebrew under the default prefix
            enable = true;

            # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
            enableRosetta = true;

            # User owning the Homebrew prefix
            user = "vincent";


            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
            };

            # autoMigrate = true;

            # Optional: Enable fully-declarative tap management
            #
            # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
            # mutableTaps = false;

          };
        }
        # inputs.spicetify-nix.nixosModules.default
      ];
    };
  };
}
