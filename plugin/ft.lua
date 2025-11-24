-- if a file is a .env or .envrc file, set the filetype to sh
vim.filetype.add({
  extension = {
    env = "dotenv",
  },
  filename = {
    [".env"] = "sh",
    [".envrc"] = "sh",
    ["*.env"] = "sh",
    ["*.envrc"] = "sh",
    ["env"] = "dotenv",
  },
  pattern = {
    ["[jt]sconfig.*.json"] = "jsonc",
    ["%.env%.[%w_.-]+"] = "dotenv",
  },
})
