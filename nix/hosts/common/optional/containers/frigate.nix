{ ... }: {
  # this is required so that intel_gpu_top works for non-root users
  boot.kernel.sysctl."perf_event_paranoid" = 1;

  networking.firewall.allowedTCPPorts = [
    8555 # frigate
    8971 # frigate
  ];
}
