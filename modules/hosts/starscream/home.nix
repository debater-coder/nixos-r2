{ self, inputs, ... }:
{
  flake.homeManagerModules.starscreamHomeManager =
    {
      config,
      pkgs,
      lib,
      ...
    }:

    {
      # Home Manager needs a bit of information about you and the paths it should
      # manage.
      home.username = "hamzah";
      home.homeDirectory = "/home/hamzah";

      # This value determines the Home Manager release that your configuration is
      # compatible with. This helps avoid breakage when a new Home Manager release
      # introduces backwards incompatible changes.
      #
      # You should not change this value, even if you update Home Manager. If you do
      # want to update the value, then make sure to first check the Home Manager
      # release notes.
      home.stateVersion = "24.05"; # Please read the comment before changing.

      # The home.packages option allows you to install Nix packages into your
      # environment.
      home.packages = with pkgs; [
        onlyoffice-desktopeditors
        rustup
        gcc
      ];

      # Home Manager is pretty good at managing dotfiles. The primary way to manage
      # plain files is through 'home.file'.
      home.file = {
        ".ssh/allowed_signers".text =
          "* ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICQIQ9YQeFmE3sMsEKLlsGdxAJsvZ9g9bnIpQojY9r4c hamzah@syedahmed.net";
        # # Building this configuration will create a copy of 'dotfiles/screenrc' in
        # # the Nix store. Activating the configuration will then make '~/.screenrc' a
        # # symlink to the Nix store copy.
        # ".screenrc".source = dotfiles/screenrc;

        # # You can also set the file content immediately.
        # ".gradle/gradle.properties".text = ''
        #   org.gradle.console=verbose
        #   org.gradle.daemon.idletimeout=3600000
        # '';
      };

      # Home Manager can also manage your environment variables through
      # 'home.sessionVariables'. These will be explicitly sourced when using a
      # shell provided by Home Manager. If you don't want to manage your shell
      # through Home Manager then you have to manually source 'hm-session-vars.sh'
      # located at either
      #
      #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
      #
      # or
      #
      #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
      #
      # or
      #
      #  /etc/profiles/per-user/hamzah/etc/profile.d/hm-session-vars.sh
      #
      home.sessionVariables = {
        EDITOR = "nvim";
        WLR_NO_HARDWARE_CURSORS = "1";
        GOROOT = "/usr/local/go";
        GOPATH = "$HOME/go";
      };
      home.sessionPath = [
        "$GOPATH/bin"
        "$GOROOT/bin"
        "$HOME/.local/bin"
      ];

      programs.kitty.enable = true;

      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;

      # shell (TODO refactor)
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        shellAliases = {
          update = "sudo nixos-rebuild switch --flake ~/nixos-r2#starscream";
          test-update = "sudo nixos-rebuild test --flake ~/nixos-r2#starscream";
          lg = "lazygit";
        };
      };

      programs.starship = {
        enable = true;
      };
      programs.atuin = {
        enable = true;
        settings = {
          auto_sync = true;
          sync_frequency = "5m";
          sync_address = "https://api.atuin.sh";
          search_mode = "fuzzy";
        };
      };
      # direnv (TODO refactor)
      programs.direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };

      programs.git = {
        enable = true;
        signing = {
          key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICQIQ9YQeFmE3sMsEKLlsGdxAJsvZ9g9bnIpQojY9r4c hamzah@syedahmed.net";
          signByDefault = true;
          format = "openpgp";
        };
        settings = {
          gpg.format = "ssh";
          user.name = "debater-coder";
          user.email = "hamzah@syedahmed.net";
        };
      };

      programs.neovim = {
        enable = true;
        withRuby = false;
        withNodeJs = true;
        withPython3 = true;
        extraConfig = ''
          set number relativenumber expandtab autoindent
          set sw=2
        '';
      };

      programs.ssh = {
        enable = true;
        matchBlocks."*".addKeysToAgent = "yes";
        extraConfig = ''
          Host login.trustworthy.systems
              User debater-coder
              IdentityFile ~/.ssh/id_ed25519

          Match Host *.keg.cse.unsw.edu.au !localnetwork 10.13.0.0/23,172.16.0.0/16
              ProxyJump login.trustworthy.systems
              User debater-coder
              IdentityFile ~/.ssh/id_ed25519

          Match Host *.keg.cse.unsw.edu.au localnetwork 10.13.0.0/23,172.16.0.0/16
              User debater-coder
              IdentityFile ~/.ssh/id_ed25519


          Host *.keg !socks-proxy.keg !login.trustworthy.systems
              CanonicalizeHostname yes
              CanonicalDomains keg.cse.unsw.edu.au
              CanonicalizePermittedCNAMEs *.keg:*.keg.cse.unsw.edu.au
              CanonicalizeMaxDots 1
              CanonicalizeFallbackLocal yes
              ProxyJump login.trustworthy.systems
              User debater-coder
              IdentityFile ~/.ssh/id_ed25519

          Host *.trustworthy.systems
              ControlMaster auto
              ControlPersist 300
              ControlPath ~/.ssh/cm-%C
              ServerAliveInterval 60
              TCPKeepAlive yes

          Match Host socks-proxy.keg
              Hostname login.trustworthy.systems
              DynamicForward 8080
              ForkAfterAuthentication yes
              SessionType none
              ControlMaster auto
              ControlPersist yes
              ControlPath ~/.ssh/cm-socks-proxy.keg
              IdentityFile ~/.ssh/id_ed25519

              User debater-coder
        '';
      };
      services.ssh-agent.enable = true;

      programs.gh = {
        enable = true;
        gitCredentialHelper.enable = true;
        settings = {
          git_protocol = "https";
        };
      };
    };
}
