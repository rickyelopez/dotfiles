{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.printing;
in
{
  options.my.printing = {
    enable = lib.mkEnableOption "host sops module.";
    printers = {
      mtlXerox = lib.mkEnableOption "Xerox printer in mtl";
    };
  };

  config = lib.mkIf cfg.enable {
    services.printing = {
      enable = true;
      drivers = with pkgs; [
        cups-filters
        cups-browsed
      ];
    };

    hardware.printers = {
      ensurePrinters = lib.mkIf cfg.printers.mtlXerox [
        {
          deviceUri = "ipp://192.168.2.12/ipp";
          location = "mtl";
          name = "Xerox";
          model = "everywhere";
        }
      ];
    };
  };
}
