{ config, lib, pkgs, ... }:

{
  # Simply install just the packages
  environment.packages = with pkgs; [
    # User-facing stuff that you really really want to have
    vim # or some other editor, e.g. nano or neovim
    neovim

    # Some common stuff that people expect to have
    procps
    killall
    diffutils
    findutils
    utillinux
    tzdata
    hostname
    man
    gnugrep
    gawk
    gnupg
    gnused
    gnutar
    bzip2
    gzip
    xz
    zip
    unzip
    ripgrep
    which
    python3
    curl
    zsh
    git
    openssh
    thefuck
    fzf
    direnv
    go
    gopls
    atuin
    nix-search-cli
    tmux
    gcc
    clang-tools
    gnumake
    binutils
    pkg-config
    cmake
    autoconf
    automake
    libtool
    m4
    patch
    file
    lua51Packages.lua
    lua51Packages.luarocks
    openssl
    patchelf
    jq
    corepack_24
    nodejs_24
    nerd-fonts.jetbrains-mono
    fd
    cargo
    uv
  ];

  terminal.font = "${pkgs.nerd-fonts.jetbrains-mono}/share/fonts/truetype/NerdFonts/JetBrainsMono/JetBrainsMonoNerdFontMono-Regular.ttf";

  # Backup etc files instead of failing to activate generation if a file already exists in /etc
  environment.etcBackupExtension = ".bak";
  environment.motd = null;
#  user.userName = "bjorn";
  user.shell = "${pkgs.zsh}/bin/zsh";
  android-integration.termux-reload-settings.enable = true;
  # Read the changelog before changing this value
  system.stateVersion = "24.05";

  # Set up nix for flakes
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Set your time zone
  time.timeZone = "Europe/Oslo";
  build.extraProotOptions = ["--kill-on-exit"];
}
