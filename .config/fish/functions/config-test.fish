function config-test
    if count $argv = 0
        echo "Usage: config-test <argument>"
        echo "Arguments: nvim, hypr, fish, kitty, starship"
        return 1
    end

    set argument $argv[1]

    if test "$argument" = "nvim" -o "$argument" = "hypr" -o "$argument" = "fish" -o "$argument" = "kitty" -o "$argument" = "starship"
        # Remove existing configuration
        rm -rf "$HOME/.config/$argument"

        # Create symlink to ~/.dotfiles/.config/$argument
        ln -s ~/.dotfiles/.config/$argument ~/.config/$argument

        echo "Configuration for $argument removed and symlink created."
    else
        echo "Invalid argument. Supported values: nvim, hypr, fish, kitty, starship"
        return 1
    end
end

