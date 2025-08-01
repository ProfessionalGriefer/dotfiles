set PATH $PATH /run/current-system/sw/bin

oh-my-posh init fish | source

# pnpm
set -gx PNPM_HOME /Users/vincent/Library/pnpm
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# Created by `pipx` on 2024-12-10 23:19:10
set PATH $PATH /Users/vincent/.local/bin

fzf --fish | source

zoxide init fish | source

fnm env --use-on-cd --shell fish | source
alias brew="env PATH=(string replace (pyenv root)/shims '' \"\$PATH\") brew"
pyenv init - fish | source
set -gx PATH /opt/homebrew/opt/postgresql@17/bin $PATH

# Load secrets
if test -f ~/.config/fish/secrets.fish
    source ~/.config/fish/secrets.fish
end

# Yazi
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if read -z cwd <"$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

# Atuin
atuin init fish | source

fish_add_path /Users/vincent/.spicetify

# Aerospace Find Window
function ff
    aerospace list-windows --all | fzf --bind 'enter:execute(bash -c "aerospace focus --window-id {1}")+abort'
end

function v
    nvim
end

alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"

# Set default editor - useful for Yazi
set -gx EDITOR nvim

set -Ux PATH $PATH /Users/vincent/.dotnet/tools
