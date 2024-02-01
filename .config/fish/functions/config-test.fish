function config-test
    if count $argv = 0
        echo "Usage: config-test <argument>"
        echo "Arguments: nvim, hypr, fish, kitty, starship"
        return 1
    end

    set argument $argv[1]

    switch $argument
        case nvim hypr fish kitty starship
            # Remove existing configuration
            rm -rf "$HOME/.config/$argument"
            
            # Create symlink to ~/.dotfiles/.config/$argument
            ln -s ~/.dotfiles/.config/$argument ~/.config/$argument
            
            echo "Configuration for $argument removed and symlink created."
        case '*'
            echo "Invalid argument. Supported values: nvim, hypr, fish"
            return 1
    end
end
