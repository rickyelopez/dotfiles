hl.on("hyprland.start", function()
  hl.exec_cmd("systemctl --user start hyprpolkitagent")
  hl.exec_cmd("uwsm app -- hyprpanel")
end)

hl.config({
  general = {
    allow_tearing = true,
    border_size = 1,
    gaps_in = 2,
    gaps_out = 2,
    layout = "dwindle",
  },
  cursor = {
    no_hardware_cursors = true,
  },
  decoration = {
    blur = {
      enabled = false,
      new_optimizations = true,
      passes = 1,
      size = 3,
    },
    rounding = 5,
  },
  dwindle = {
    preserve_split = true,
  },
  gestures = {
    workspace_swipe_invert = false,
  },
  input = {
    accel_profile = "flat",
    follow_mouse = 1,
    special_fallthrough = true,
    kb_layout = "us",
    kb_options = "ctrl:nocaps,fkeys:basic_13-24",
    natural_scroll = false,
    numlock_by_default = true,
    repeat_delay = 175,
    repeat_rate = 35,
    sensitivity = 0.3,
    touchpad = {
      clickfinger_behavior = true,
      disable_while_typing = false,
      scroll_factor = 0.3,
    },
  },
  master = {
    new_status = "master",
  },
  misc = {
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
  },
  ecosystem = {
    no_update_news = true,
    no_donation_nag = true,
  },
})

hl.gesture({
  fingers = 3,
  direction = "horizontal",
  action = "workspace",
})

-- default monitor rule in case a monitor is plugged in that is not defined (eg. on a laptop)
hl.monitor({
  output = "",
  mode = "preferred",
  position = "auto",
  scale = 1,
})
