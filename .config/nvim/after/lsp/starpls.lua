return {
  cmd = {
    "starpls",
    "server",
    "--experimental_enable_label_completions", -- Enable completions for labels for targets in the current workspace
    "--experimental_goto_definition_skip_re_exports",
    -- "--analysis_debounce_interval <ANALYSIS_DEBOUNCE_INTERVAL>", -- After receiving an edit event, the amount of time in milliseconds the server will wait for additional events before running analysis [default: 250]
    "--experimental_infer_ctx_attributes", --Infer attributes on a rule implementation function's context parameter
    "--experimental_use_code_flow_analysis", --Use code-flow analysis during typechecking
  },
}
