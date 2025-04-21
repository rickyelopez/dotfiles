{ hostSpec, ... }: {
  programs.mangohud = {
    enable = true;
    settings = {
      output_folder = "${hostSpec.home}/mangohud/";
      preset = 2;
    };
  };
}

