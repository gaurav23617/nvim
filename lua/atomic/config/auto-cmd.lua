vim.api.nvim_create_autocmd("BufWinLeave", {
  pattern = "?*", -- Avoid running for unnamed buffers
  callback = function()
    if vim.fn.empty(vim.fn.expand("%")) == 0 then -- Check if file has a name
      vim.cmd("silent! mkview")
    end
  end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = "?*", -- Avoid running for unnamed buffers
  callback = function()
    if vim.fn.empty(vim.fn.expand("%")) == 0 and vim.fn.filereadable(vim.fn.expand("%:p")) == 1 then
      vim.cmd("silent! loadview")
    end
  end,
})
