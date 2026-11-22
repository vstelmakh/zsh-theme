#!/usr/bin/env zsh
# Play a scripted terminal session with the real theme prompt.
# Usage: resources/demo.zsh
# The session starts and ends with the same screen (empty, prompt in home directory), so it can be looped.
# Commands run in a temporary home directory with a Git repository, which is deleted on exit.

DIR_PROJECT=${0:A:h:h}
DIR_TMP=$(mktemp -d) || exit 1
DIR_DEMO=${DIR_TMP}/projects/awesome

TYPE_DELAY=${DEMO_TYPE_DELAY:-0.1} # seconds between typed characters
PAUSE=${DEMO_PAUSE:-1.5} # seconds to show the result of each command

# isolate git from user and system configuration
export GIT_CONFIG_GLOBAL=/dev/null
export GIT_CONFIG_NOSYSTEM=1
export GIT_AUTHOR_NAME=demo GIT_AUTHOR_EMAIL=demo@example.com
export GIT_COMMITTER_NAME=demo GIT_COMMITTER_EMAIL=demo@example.com

main() {
    trap 'rm -rf "$DIR_TMP"' EXIT
    source "${DIR_PROJECT}/zsh-theme.zsh"
    setup_repo
    HOME=$DIR_TMP # prompt shows "~" here
    cd "$HOME" || return 1

    clear
    show_prompt 0
    sleep $PAUSE

    play 'cd projects/awesome'
    play 'echo "buy milk" > todo.txt'
    play 'git add . && git commit -qm "add todo"'
    play 'cat notes.txt'
    play 'git switch -q very-long-branch-name'
    play 'git rebase main'
    play 'git rebase --abort'
    play 'cd ~'
    play 'clear' # back to the first screen, to loop
}

# Repository with branch "very-long-branch-name" that conflicts with "main" on rebase
setup_repo() {
    mkdir -p "$DIR_DEMO" && cd "$DIR_DEMO" || return 1
    git init -q -b main
    git config advice.mergeConflict false
    print "# Awesome" > README.md && git add . && git commit -qm "init"
    git switch -qc very-long-branch-name
    print "# Awesome project" > README.md && git commit -qam "rename project"
    git switch -q main
    print "# Awesome app" > README.md && git commit -qam "rename app"
}

# Type the command, run it and show the next prompt for a while
play() {
    local COMMAND=$1
    type_text "$COMMAND"
    sleep 0.4
    print

    eval "$COMMAND"
    local STATUS=$?

    show_prompt $STATUS
    sleep $PAUSE
}

type_text() {
    local CHAR
    for CHAR in ${(s::)1}; do
        print -n -- "$CHAR"
        sleep $TYPE_DELAY
    done
}

# Print the theme prompt as it would be shown after a command with the given exit status
show_prompt() {
    theme_precmd
    ( exit $1 )
    print -Pn -- "$PROMPT"
}

main "$@"
