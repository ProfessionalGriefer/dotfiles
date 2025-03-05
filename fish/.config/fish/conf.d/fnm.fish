
# fnm
set FNM_PATH "/Users/vincent/Library/Application Support/fnm"
if [ -d "$FNM_PATH" ]
    set PATH "$FNM_PATH" $PATH
    fnm env --use-on-cd --shell fish | source
    # fnm env | source
end
