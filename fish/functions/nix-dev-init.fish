function initialize_nix_project
    set template $argv[1]

    # Check if a language is provided
    if test -z "$template"
        echo "Error: Please provide a template."
        return 1
    end

    # Run nix flake init with the specified language
    nix flake init --template "github:the-nix-way/dev-templates#$language"
    
    # Check if the nix flake init command succeeded
    if test $status -eq 0
        direnv allow
    else
        echo "Error: nix flake init command failed."
        return 1
    end
end
