{
  description = "Kenneth's Neovim Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        # Neovim with custom configuration
        neovimConfig = pkgs.neovim.override {
          configure = {
            customRC = ''
              " Set the runtime path to include this configuration
              set runtimepath^=${self}
              set runtimepath+=${self}/after
              
              " Source the main init.lua
              lua dofile("${self}/init.lua")
            '';
            
            packages.myVimPackage = with pkgs.vimPlugins; {
              # Essential plugins that should be available immediately
              start = [
                # Plugin manager
                lazy-nvim
                
                # Core dependencies
                plenary-nvim
                nvim-web-devicons
                
                # LSP and completion
                nvim-lspconfig
                nvim-cmp
                cmp-nvim-lsp
                cmp-buffer
                cmp-path
                cmp-cmdline
                luasnip
                cmp_luasnip
                
                # Treesitter
                nvim-treesitter.withAllGrammars
                nvim-treesitter-textobjects
                
                # Telescope
                telescope-nvim
                telescope-fzf-native-nvim
                
                # Git
                fugitive
                gitsigns-nvim
                
                # UI
                lualine-nvim
                nvim-notify
                which-key-nvim
                
                # Navigation
                harpoon
                nvim-tree-lua
                
                # Utilities
                comment-nvim
                nvim-autopairs
                indent-blankline-nvim
                
                # Themes
                kanagawa-nvim
                gruvbox-nvim
                
                # Additional useful plugins
                undotree
                vim-sleuth
                nvim-surround
              ];
              
              # Optional plugins that can be lazy-loaded
              opt = [ ];
            };
          };
        };

        # Development tools that complement the Neovim setup
        devTools = with pkgs; [
          # Language servers (matching your LSP config)
          lua-language-server
          rust-analyzer
          nil # Nix LSP
          nixd # Alternative Nix LSP
          nodePackages.typescript-language-server
          nodePackages.vscode-langservers-extracted
          pyright
          
          # Formatters
          stylua
          nixpkgs-fmt
          rustfmt
          nodePackages.prettier
          black
          
          # Linters
          selene # Lua linter
          
          # Tools
          ripgrep
          fd
          fzf
          git
          lazygit
          tree-sitter
          
          # Build tools
          gcc
          cmake
          gnumake
          pkg-config
        ];

      in
      {
        # Main package: Neovim with your configuration
        packages = {
          default = neovimConfig;
          neovim = neovimConfig;
          
          # Alternative: just the config files
          config = pkgs.stdenv.mkDerivation {
            name = "neovim-config";
            src = ./.;
            installPhase = ''
              mkdir -p $out
              cp -r * $out/
            '';
          };
        };

        # Development shell with all tools
        devShells.default = pkgs.mkShell {
          buildInputs = [ neovimConfig ] ++ devTools;
          
          shellHook = ''
            echo "Kenneth's Neovim development environment loaded!"
            echo "Neovim with custom config available as 'nvim'"
            echo ""
            echo "Available tools:"
            echo "  - Language servers: lua-language-server, rust-analyzer, nil, nixd, etc."
            echo "  - Formatters: stylua, nixpkgs-fmt, rustfmt, prettier, black"
            echo "  - Utilities: ripgrep, fd, fzf, lazygit"
            echo ""
            echo "To use this config on NixOS, add to your configuration:"
            echo "  environment.systemPackages = [ inputs.neovim-config.packages.\''${system}.default ];"
          '';
        };

        # Apps for easy running
        apps = {
          default = {
            type = "app";
            program = "${neovimConfig}/bin/nvim";
          };
          neovim = {
            type = "app";
            program = "${neovimConfig}/bin/nvim";
          };
        };

        # Formatter for this flake
        formatter = pkgs.nixpkgs-fmt;
      });
}