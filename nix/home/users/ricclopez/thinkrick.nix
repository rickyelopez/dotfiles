{
  inputs,
  pkgs,
  ...
}:
{
  home = {
    packages = with pkgs; [
      protobuf
      ghostty.terminfo
    ];

    file = {
      ".terminfo/g/ghostty".source = "${pkgs.ghostty.terminfo}/share/terminfo/g/ghostty";
      ".terminfo/x/xterm-ghostty".source = "${pkgs.ghostty.terminfo}/share/terminfo/x/xterm-ghostty";
    };
  };

  imports = [
    inputs.stylix.homeModules.stylix
  ];

  my = {
    bazel.enable = true;
    docker.enable = true;
    remote-open.client.enable = true;
    sops = {
      enable = true;
      addKeys = false;
    };
    stylix.enable = true;
    work = {
      enable = true;
      secrets.enable = true;
    };
  };
}
