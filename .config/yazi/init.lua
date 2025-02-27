Status:children_add(function()
  local h = cx.active.current.hovered
  if h == nil or ya.target_family() ~= "unix" then
    return ui.Line({})
  end

  return ui.Line({
    ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
    ui.Span(":"),
    ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
    ui.Span(" "),
  })
end, 500, Status.RIGHT)

require("augment-command"):setup({
  prompt = true,
  default_item_group_for_prompt = "none",
  smart_enter = false,
  smart_paste = true,
  smart_tab_create = false,
  smart_tab_switch = true,
  open_file_after_creation = false,
  enter_directory_after_creation = false,
  use_default_create_behaviour = false,
  enter_archives = false,
  extract_retries = 0,
  recursively_extract_archives = false,
  preserve_file_permissions = false,
  must_have_hovered_item = true,
  skip_single_subdirectory_on_enter = false,
  skip_single_subdirectory_on_leave = false,
  wraparound_file_navigation = true,
})
