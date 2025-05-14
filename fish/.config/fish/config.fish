# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /Users/vincent/miniconda3/bin/conda
    eval /Users/vincent/miniconda3/bin/conda "shell.fish" hook $argv | source
else
    if test -f "/Users/vincent/miniconda3/etc/fish/conf.d/conda.fish"
        . "/Users/vincent/miniconda3/etc/fish/conf.d/conda.fish"
    else
        set -x PATH /Users/vincent/miniconda3/bin $PATH
    end
end
# <<< conda initialize <<<

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
