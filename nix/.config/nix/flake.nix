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
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, homebrew-core, homebrew-cask, ... }:
  let
    configuration = { pkgs, config, ... }: {

      nixpkgs.config.allowUnfree = true;

      system.primaryUser = "vincent";

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = with pkgs; [ 
          dust
          eza
          firefox
          fish
          fnm
          fzf
          glow # Render MD on CLI
          lazygit
          navi
          neovim
          nerd-fonts.jetbrains-mono
          obsidian
          oh-my-posh
          pyenv
          ripgrep
          stow
          yazi
          zoxide
      ] ++ lib.optionals pkgs.stdenv.isDarwin [
          mkalias # Create finder aliases
          karabiner-elements # Customize Keyboard
      ];

      # programs.tmux = {
      #     enable = true;
      #     extraConfig = builtins.readFile /Users/vincent/.config/tmux/tmux.conf;
      # };

      homebrew = {
        enable = true;
        brews = [
          "mas"
          "tmux"
        ];
        casks = [
          "omnidisksweeper"
          "iina"
        ];
        masApps = {
          "WhatsApp Messenger" = 310633997;
          "The Unarchiver" = 425424353;
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
        dock.autohide = true;
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
      ];
    };
  };
}
