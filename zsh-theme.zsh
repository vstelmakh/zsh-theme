# Custom ZSH theme of Volodymyr Stelmakh
# https://github.com/vstelmakh/zsh-theme
# MIT License

# ZSH Prompt-Expansion Reference
# https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html
# git:
# %s - vcs type
# %b - branch
# %a - action (rebase/merge)
# %m - misc content (set with git-check hook)
# prompt:
# %F - foreground color
# %f - reset color
# %B - bold
# %b - reset bold
# %~ - current path
# %1~ - last directory of current path
# %(::) - prompt conditional - %(condition:true:false)

# Hook to set Git reference to misc (%m) content
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' formats "%%F{blue}[%m%%F{blue}]%%f "
zstyle ':vcs_info:*' actionformats "%%F{blue}[%m%%F{blue}]%%f " # action is added to misc by hook
zstyle ':vcs_info:git*+set-message:*' hooks git-check
+vi-git-check() {
    # - branch name
    # - or tag name
    # - or short SHA of the commit
    local REF
    REF=$(git symbolic-ref --short HEAD 2> /dev/null) \
    || REF=$(git describe --tags --exact-match HEAD 2> /dev/null) \
    || REF=$(git rev-parse --short HEAD 2> /dev/null) \
    || return 0

    local REF_MAX_LENGTH
    zstyle -s ':vstelmakh:theme' ref-max-length REF_MAX_LENGTH
    if [[ $REF_MAX_LENGTH != <-> ]]; then
        REF_MAX_LENGTH=15 # default, if not set or not a number
    fi
    if (( REF_MAX_LENGTH > 0 && ${#REF} > REF_MAX_LENGTH )); then # 0 disables truncation
        REF="${REF[1,REF_MAX_LENGTH-1]}…"
    fi
    REF=${REF//\%/%%} # escape % to not interpret it as prompt sequence
    hook_com[misc]="%F{red}${REF}" # replace default misc content (e.g. rebase patch info)

    if [[ -n $(git status --porcelain 2> /dev/null) ]]; then
        hook_com[misc]+=" %F{yellow}•" # repository has changes
    fi

    # short action name (e.g. rebase-i -> rebase, cherry-pick -> cherry)
    local ACTION=${hook_com[action]%%[-/]*}
    if [[ -f ${vcs_comm[gitdir]}/REVERT_HEAD ]]; then
        ACTION="revert" # not detected by vcs_info
    fi
    if [[ -n $ACTION ]]; then
        hook_com[misc]+=" %F{yellow}${ACTION}"
    fi
}

setopt prompt_subst
autoload -Uz add-zsh-hook
theme_precmd () {
    theme_workdir='%1~'
    zstyle -t ':vstelmakh:theme' full-path && theme_workdir='%~'

    vcs_info
}
add-zsh-hook precmd theme_precmd # adds hook only once, even if theme sourced again

PROMPT="%B" # text style bold
PROMPT+="%(?:%F{green}:%F{red})➜ " # previous command status
PROMPT+='%F{cyan}${theme_workdir} ' # workdir
PROMPT+='${vcs_info_msg_0_}' # git reference (if git repo)
PROMPT+="%b%f%u" # reset all text styles
