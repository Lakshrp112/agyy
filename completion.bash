_agy_get_auth_profiles() {
    local auth_dir="${AUTH_DIR:-$HOME/.agy_toys/auth}"
    if [[ -d "$auth_dir" ]]; then
        shopt -s nullglob
        for f in "$auth_dir"/antigravity-oauth-token-*; do
            printf '%s ' "${f##*antigravity-oauth-token-}"
        done
        shopt -u nullglob
    fi
}

# Bash completion for agyy / agy
_agy_extension_completion() {
    local cur prev words cword
    if declare -F _init_completion >/dev/null 2>&1; then
        _init_completion -n = || return
    else
        cur="${COMP_WORDS[COMP_CWORD]}"
        prev="${COMP_WORDS[COMP_CWORD-1]}"
        words=("${COMP_WORDS[@]}")
        cword=$COMP_CWORD
    fi

    local toys_cmds="status swap save delete whoami sync yolo clean sync-skills init help"
    local agy_flags="-y --yolo -c --continue -m --model -p --print -h --help"
    local models="Gemini Claude"
    local clean_opts="chats all -f"
    local yolo_opts="true false status"

    case "$prev" in
        --model|-m)
            COMPREPLY=( $(compgen -W "${models}" -- "$cur") )
            return 0
            ;;
        clean)
            COMPREPLY=( $(compgen -W "${clean_opts}" -- "$cur") )
            return 0
            ;;
        yolo)
            COMPREPLY=( $(compgen -W "${yolo_opts}" -- "$cur") )
            return 0
            ;;
        delete|swap)
            COMPREPLY=( $(compgen -W "$(_agy_get_auth_profiles)" -- "$cur") )
            return 0
            ;;
    esac

    local subcmd=""
    local subcmd_idx=0
    local i
    for (( i=1; i < cword; i++ )); do
        local w="${words[i]}"
        if [[ "$w" != -* ]]; then
            for cmd in $toys_cmds; do
                if [[ "$w" == "$cmd" ]]; then
                    subcmd="$w"
                    subcmd_idx=$i
                    break 2
                fi
            done
        fi
    done

    if [[ "$subcmd" == "status" || "$subcmd" == "swap" ]]; then
        local pos=$(( cword - subcmd_idx ))
        local auths
        auths=$(_agy_get_auth_profiles)

        if (( pos == 1 )); then
            COMPREPLY=( $(compgen -W "${auths} ${models}" -- "$cur") )
            return 0
        elif (( pos == 2 )); then
            COMPREPLY=( $(compgen -W "${models} ${auths}" -- "$cur") )
            return 0
        fi
    elif [[ "$subcmd" == "delete" ]]; then
        if [[ "$cur" == -* ]]; then
            COMPREPLY=( $(compgen -W "-r --revoke -f --force -y" -- "$cur") )
        else
            COMPREPLY=( $(compgen -W "$(_agy_get_auth_profiles) -r --revoke -f --force" -- "$cur") )
        fi
        return 0
    fi

    if [[ "$cur" == -* ]]; then
        COMPREPLY=( $(compgen -W "${agy_flags}" -- "$cur") )
        return 0
    fi

    if [[ -z "$subcmd" ]]; then
        COMPREPLY=( $(compgen -W "${toys_cmds} ${agy_flags}" -- "$cur") )
        return 0
    fi
}

complete -o default -o bashdefault -F _agy_extension_completion agyy
complete -o default -o bashdefault -F _agy_extension_completion agy
