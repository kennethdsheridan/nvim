# Neovim Configuration

My personal Neovim configuration with LSP support, AI integration, and customized keybindings.

## Features

- **LSP Support**: Full language server protocol integration for multiple languages
- **Markdown Preview**: Multiple preview options (browser and native webview)
- **Completion**: nvim-cmp with LSP sources (Tab completion disabled)
- **Git Integration**: Fugitive, Gitsigns, and Diffview
- **File Navigation**: Telescope fuzzy finder and Harpoon
- **Debugging**: DAP (Debug Adapter Protocol) support

## Key Bindings

### Leader Key: `<Space>`

### Autocomplete
- `<leader>tc` - Toggle autocomplete on/off
- `<C-n>` / `<C-p>` - Navigate completion suggestions
- `<C-y>` - Accept completion
- `<C-Space>` - Trigger completion

### Markdown Preview
- `<leader>mp` - Toggle Markdown Preview (browser-based)
- `<leader>pk` - Open Peek preview (native webview)
- `<leader>pc` - Close Peek preview

### File Navigation
- `<leader>pf` - Find files
- `<C-p>` - Git files
- `<leader>/` - Live grep
- `<leader>pb` - Browse buffers

### LSP
- `gd` - Go to definition
- `gr` - Go to references
- `gi` - Go to implementation
- `K` - Hover documentation
- `<leader>rn` - Rename symbol
- `<leader>ca` - Code actions

### Git
- `<leader>gs` - Git status (Fugitive)
- `<leader>gp` - Preview git hunk
- `<leader>gb` - Git blame line

## Customizations

- Tab key inserts literal tabs (autocomplete acceptance disabled)
- Dark chalkboard color theme
- Custom status line with git integration
- Automatic formatting on save for supported languages

## Nix Flake Support

This configuration is available as a Nix flake for easy installation on NixOS and other Nix-based systems.

### Using the Flake

#### On NixOS
Add to your `flake.nix` inputs:
```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    neovim-config.url = "github:kennethdsheridan/nvim";
  };
  
  outputs = { self, nixpkgs, neovim-config }: {
    nixosConfigurations.your-hostname = nixpkgs.lib.nixosSystem {
      # ... your config
      modules = [
        {
          environment.systemPackages = [
            neovim-config.packages.${system}.default
          ];
        }
      ];
    };
  };
}
```

#### Direct Usage
```bash
# Run Neovim with this config
nix run github:kennethdsheridan/nvim

# Enter development shell with all tools
nix develop github:kennethdsheridan/nvim

# Install locally
nix profile install github:kennethdsheridan/nvim
```

#### Home Manager
```nix
{
  inputs.neovim-config.url = "github:kennethdsheridan/nvim";
  
  # In your home.nix
  home.packages = [
    inputs.neovim-config.packages.${pkgs.system}.default
  ];
}
```

### Development Shell
The flake provides a development shell with all necessary tools:
- Language servers (lua-language-server, rust-analyzer, nil, nixd, etc.)
- Formatters (stylua, nixpkgs-fmt, rustfmt, prettier, black)
- Utilities (ripgrep, fd, fzf, lazygit)

### Local Development
```bash
# Clone and enter development environment
git clone https://github.com/kennethdsheridan/nvim ~/.config/nvim
cd ~/.config/nvim
nix develop

# Or with direnv (if .envrc is present)
direnv allow
```
