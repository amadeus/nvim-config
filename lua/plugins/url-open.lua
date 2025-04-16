return {
  -- Not using this right now because I worry the syntax
  -- highlighting stuff it may be doing is expensive and
  -- unnecessary.  But keeping it around in case I have have
  -- second thoughts
  "sontungexpt/url-open",
  version = false,
  enabled = false,
  event = "VeryLazy",
  opts = {
    highlight_url = {
      all_urls = {
        enabled = false,
      },
      cursor_move = {
        underline = true,
      },
    },
  },
  config = function(_, opts)
    local status_ok, url_open = pcall(require, "url-open")
    if not status_ok then
      vim.notify("Unable to load sontungexpt/url-open")
      return
    end
    url_open.setup(opts)
    vim.keymap.set({ "n" }, "gx", "<esc>:URLOpenUnderCursor<cr>")
  end,
}
