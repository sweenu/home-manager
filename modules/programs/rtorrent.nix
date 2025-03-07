{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.programs.rtorrent;

in {
  meta.maintainers = [ maintainers.marsam ];

  imports = [
    (mkRenamedOptionModule # \
      [ "programs" "rtorrent" "settings" ] # \
      [ "programs" "rtorrent" "extraConfig" ])
  ];

  options.programs.rtorrent = {
    enable = mkEnableOption "rTorrent";

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Configuration written to
        <filename>$XDG_CONFIG_HOME/rtorrent/rtorrent.rc</filename>. See
        <link xlink:href="https://github.com/rakshasa/rtorrent/wiki/Config-Guide" />
        for explanation about possible values.
      '';
    };

  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.rtorrent ];

    xdg.configFile."rtorrent/rtorrent.rc" =
      mkIf (cfg.extraConfig != "") { text = cfg.extraConfig; };
  };
}
