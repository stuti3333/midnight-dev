midnight_prompt() {
    local exit_code=$?
    local branch=""

    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        branch=" ($(git branch --show-current 2>/dev/null))"
    fi

    if (( exit_code == 0 )); then
        PS1='\[\e[38;5;81m\]❯\[\e[0m\] '
    else
        PS1='\[\e[38;5;203m\]✗\[\e[0m\] '
    fi

    PS1="\[\e[38;5;141m\]\w\[\e[0m\]\[\e[38;5;141m\]${branch}\[\e[0m\] ${PS1}"
}

PROMPT_COMMAND=midnight_prompt
