hl.window_rule({
  match = { class = "thunar" },
  float = true,
  size = { 1200, 600 },
  center = true,
  fullscreen_state = 0,
})

hl.window_rule({
  match = { class = "org.pulseaudio.pavucontrol" },
  float = true,
  size = { 1160, 600 },
  center = true,
})

hl.window_rule({
  match = { class = "blueman-manager" },
  float = true,
  size = { 530, 550 },
  center = true,
})

hl.window_rule({
  match = { class = "nm-connection-editor" },
  float = true,
  size = { 530, 550 },
  center = true,
})

hl.window_rule({
  match = { class = "btop" },
  float = true,
})

hl.window_rule({
  match = { class = "io.github.Qalculate.qalculate-qt" },
  float = true,
  persistent_size = true,
  fullscreen_state = 0,
})

hl.window_rule({
  name = "nextcloud",
  match = {
    title = "^Nextcloud$",
  },
  float = true,
  move = { "(monitor_w*0.75)", 50 },
  size = { "(monitor_w*0.25)", 600 },
  stay_focused = true,
})

hl.window_rule({
  match = { title = "^Nextcloud Settings$" },
  float = true,
  size = { 530, 550 },
  center = true,
  fullscreen_state = 0,
})

hl.window_rule({
  match = { title = "^Ferdium$" },
  float = true,
  workspace = "special",
  move = { 884, 50 },
  size = { 1033, 1027 },
})

hl.window_rule({
  match = {
    class = "^brave-.*$",
    initial_title = "^_crx_.*$",
  },
  float = true,
  size = { 450, 550 },
  center = true,
})

hl.window_rule({
  match = { class = "^bitwarden$" },
  float = true,
  fullscreen_state = 0,
  size = { 1169, 754 },
})
