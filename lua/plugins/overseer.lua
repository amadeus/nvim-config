return {
  "stevearc/overseer.nvim",
  version = false,
  enabled = false,
  opts = {},
  config = function(_, opts)
    local overseer = require("overseer")
    overseer.setup(opts)

    -- A super AI slopped variant to try and detect the type of task and be
    -- able to process its output.  Unfortunately while this works, it feels
    -- very kludgy
    overseer.add_template_hook(nil, function(task_defn, util)
      local is_package_manager_run = false
      local script_name = nil
      if
        type(task_defn.cmd) == "table"
        and #task_defn.cmd > 0
        and (task_defn.cmd[1] == "npm" or task_defn.cmd[1] == "bun" or task_defn.cmd[1] == "pnpm")
        and type(task_defn.args) == "table"
        and #task_defn.args > 1
        and task_defn.args[1] == "run"
      then
        is_package_manager_run = true
        script_name = task_defn.args[2] -- Get the script name
      end

      if is_package_manager_run and script_name then
        local problem_matcher = nil
        -- Determine the problem matcher based on the script name
        -- You might need to adjust these conditions based on your actual script names
        if
          script_name == "tsc"
          or string.find(script_name, "check", 1, true)
          or string.find(script_name, "type", 1, true)
        then
          problem_matcher = "$tsc"
        elseif script_name == "lint" or script_name == "eslint" or string.find(script_name, "eslint", 1, true) then
          problem_matcher = "$eslint-stylish" -- Or "$eslint-compact" if your output is compact
        end

        if problem_matcher then
          util.add_component(task_defn, { "on_output_parse", problem_matcher = problem_matcher })
          util.add_component(task_defn, { "on_result_diagnostics_quickfix", open = true })
          util.remove_component(task_defn, "on_output_quickfix")
        end
      end
    end)
    vim.keymap.set("n", "<leader>or", ":OverseerRun<cr>", { noremap = true, silent = true, desc = "Run Overseer task" })
  end,
}
