{
  config,
  pkgs,
  ...
}:
{
  home = {
    packages = with pkgs; [
      protobuf
    ];
  };

  programs.zsh.initContent = /* bash */ ''
    export GITHUB_TOKEN="$(cat ${config.sops.secrets."github_tokens/work".path})"
  '';

  imports = [
    ../../../platforms/linux/home
  ];

  sops.secrets = {
    "github_tokens/work" = { };
  };

  my = {
    bazel.enable = true;
    docker.enable = true;
    remote-open.client.enable = true;
    sops = {
      enable = true;
      addKeys = false;
    };
  };
}
