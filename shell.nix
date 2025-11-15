# Legacy shell.nix for non-flake users
# Use: nix-shell
{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    # Neovim
    neovim
    
    # Language servers
    lua-language-server
    rust-analyzer
    nil
    nixd
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted
    pyright
    
    # Formatters
    stylua
    nixpkgs-fmt
    rustfmt
    nodePackages.prettier
    black
    
    # Tools
    ripgrep
    fd
    fzf
    git
    lazygit
    tree-sitter
    gcc
    cmake
    gnumake
    pkg-config
  ];
  
  shellHook = ''
    echo "Kenneth's Neovim development shell (legacy)"
    echo "Note: Consider using 'nix develop' with flakes for better experience"
  '';
}