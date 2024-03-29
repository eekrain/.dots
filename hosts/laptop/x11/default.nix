{ config, pkgs, user, inputs, ... }:

{
  imports =
    (import ../../../modules/hardware) ++
    [
      ../hardware-configuration.nix
      ../../../modules/fonts
    ] ++ [
      ../../../modules/desktop/bspwm
    ];

  users.users.root.initialHashedPassword = "$6$IwdihcNtlzcPQmO1$iDZjGZEOJ9Je4KHBYEtomTNUrl0FASKrmziZkSlw6/ui6WOP/7XQzbC8H1cwBp3UaJvTLIu79cLODSYLL2X0W0";
  users.users.${user} = {
    initialHashedPassword = "$6$IwdihcNtlzcPQmO1$iDZjGZEOJ9Je4KHBYEtomTNUrl0FASKrmziZkSlw6/ui6WOP/7XQzbC8H1cwBp3UaJvTLIu79cLODSYLL2X0W0";
    # shell = pkgs.fish;
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" ];
    packages = [ ];
  };
  boot = {
    supportedFilesystems = [ "ntfs" ];
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "auto";
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      timeout = 3;
    };
    kernelParams = [
      "quiet"
      "splash"
      # "nvidia-drm.modeset=1"
    ];
    consoleLogLevel = 0;
    initrd.verbose = false;
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-rime fcitx5-chinese-addons fcitx5-table-extra fcitx5-pinyin-moegirl fcitx5-pinyin-zhwiki ];
  };

  environment = {
    systemPackages = with pkgs; [
      libnotify
      xclip
      xorg.xrandr
      cinnamon.nemo
      networkmanagerapplet
      alsa-lib
      alsa-utils
      flac
      pulsemixer
      imagemagick
      flameshot
    ];
  };

  services = {
    dbus.packages = [ pkgs.gcr ];
    getty.autologinUser = "${user}";
    gvfs.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };

  security.polkit.enable = true;
  security.sudo = {
    enable = true;
    extraConfig = ''
      ${user} ALL=(ALL) NOPASSWD:ALL
    '';
  };
  security.doas = {
    enable = false;
    extraConfig = ''
      permit nopass :wheel
    '';
  };

}
