{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    grim
    slurp
    swappy
  ];

  services.displayManager.sddm.wayland.enable = true;
}
