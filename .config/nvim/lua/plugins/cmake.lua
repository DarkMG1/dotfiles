return {
  {
    "Civitasv/cmake-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("cmake-tools").setup({
        cmake_command = "cmake", -- defaults to "cmake"
        cmake_build_directory = "build", -- default build dir
        cmake_build_type = "Debug", -- Debug, Release, etc.
        cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },
        cmake_regenerate_on_save = true,
        cmake_console_size = 10,
        cmake_show_console = "always", -- "always", "only_on_error"
      })
    end,
  },
}
