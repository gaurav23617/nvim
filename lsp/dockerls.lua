return {
  cmd = {
    "docker-langserver",
    "--stdio",
  },
  filetypes = {
    "dockerfile",
    "Dockerfile",
  },
  root_markers = {
    ".git",
    "Dockerfile",
    "dockerfile",
  },

  single_file_support = true,
}
