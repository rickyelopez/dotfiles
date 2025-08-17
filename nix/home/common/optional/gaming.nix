# FIXME: turn this into a module under `modules/home-manager` once in-flight changes on aretuza are sorted
{ hostSpec, ... }: {
  programs.mangohud = {
    enable = true;
    settings = {
      output_folder = "${hostSpec.home}/mangohud/";
      preset = 2;
    };
  };
}

