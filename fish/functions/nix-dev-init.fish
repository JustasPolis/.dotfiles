function nix-dev-init
    nix flake init -t "github:the-nix-way/dev-templates#$1"
    direnv allow
end
