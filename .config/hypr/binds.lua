local MAINMOD = "SUPER"
local TERMINAL = "ghostty"
local FILEMGR = "thunar"
local SCREENSHOT = 'grim -g "$(slurp)" - | swappy -f -'

local function bindMain(bind, ...)
  hl.bind(MAINMOD .. " + " .. bind, ...)
end

local function bindr(...)
  local args = { ... }
  table.insert(args, { repeating = true })
  hl.bind(table.unpack(args))
end

bindMain("mouse:272", hl.dsp.window.drag(), { mouse = true })
bindMain("mouse:273", hl.dsp.window.resize(), { mouse = true })
bindMain("SHIFT + mouse:272", hl.dsp.window.resize(), { mouse = true })

bindMain("Q", hl.dsp.window.close())
bindMain("V", hl.dsp.window.float({ action = "toggle" }))
bindMain("P", hl.dsp.window.pseudo({ action = "toggle" }))
bindMain("E", hl.dsp.layout("togglesplit"))
bindMain("F", hl.dsp.window.fullscreen({ action = "toggle" }))
bindMain("RETURN", hl.dsp.exec_cmd("uwsm-app -- " .. TERMINAL))
bindMain("S", hl.dsp.exec_cmd("uwsm-app -- " .. SCREENSHOT))
bindMain("L", hl.dsp.exec_cmd("uwsm-app -- hyprlock"))

hl.bind("ALT_L + SPACE", hl.dsp.exec_cmd("rofi -combi -show"))
hl.bind("ALT_L + E", hl.dsp.exec_cmd("uwsm-app -- " .. FILEMGR))
hl.bind("ALT_L + tab", hl.dsp.group.next())
hl.bind("ALT_L + SHIFT + tab", hl.dsp.group.prev())

bindMain("G", hl.dsp.group.toggle())
bindMain("grave", hl.dsp.workspace.toggle_special("special"))
bindMain("SHIFT + grave", hl.dsp.window.move({ workspace = "special" }))

bindMain("h", hl.dsp.focus({ direction = "l" }))
bindMain("j", hl.dsp.focus({ direction = "d" }))
bindMain("k", hl.dsp.focus({ direction = "u" }))
bindMain("l", hl.dsp.focus({ direction = "r" }))

for idx = 1, 10 do
  -- mod 10 so that 0 maps to 10
  bindMain("" .. idx % 10, hl.dsp.focus({ workspace = idx }))
  bindMain("SHIFT + " .. idx % 10, hl.dsp.window.move({ workspace = idx }))
end

bindMain("SHIFT + l", hl.dsp.focus({ workspace = "e+1" }))
bindMain("SHIFT + h", hl.dsp.focus({ workspace = "e-1" }))
bindMain("tab", hl.dsp.focus({ workspace = "m+1" }))
bindMain("SHIFT + tab", hl.dsp.focus({ workspace = "m-1" }))
bindMain("mouse_down", hl.dsp.focus({ workspace = "e+1" }))
bindMain("mouse_up", hl.dsp.focus({ workspace = "e-1" }))
bindMain("SHIFT + O", hl.dsp.dpms({ action = "on" }))

hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))

hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pamixer -t"))
hl.bind("SHIFT + XF86AudioMute", hl.dsp.exec_cmd("pamixer --default-source -t"))

bindr("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pamixer -i 5"))
bindr("XF86AudioLowerVolume", hl.dsp.exec_cmd("pamixer -d 5"))
bindr("SHIFT + XF86AudioRaiseVolume", hl.dsp.exec_cmd("pamixer --default-source -i 5"))
bindr("SHIFT + XF86AudioLowerVolume", hl.dsp.exec_cmd("pamixer --default-source -d 5"))

bindr("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 5%+"))
bindr("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl --min-value=1 set 5%-"))
bindr("SHIFT + XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 1%+"))
bindr("SHIFT + XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl --min-value=1 set 1%-"))

hl.bind("XF86Calculator", hl.dsp.exec_cmd("qalculate-qt"))
hl.bind("Print", hl.dsp.exec_cmd(SCREENSHOT))

hl.bind(
  "switch:on:Lid Switch",
  hl.dsp.exec_cmd("systemctl suspend; pidof hyprlock || uwsm-app -- hyprlock --immediate"),
  { locked = true }
)
