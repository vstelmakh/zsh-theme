#!/usr/bin/env zsh
# Run theme tests
# Usage: tests/run.zsh [<file>] [<function>]
# Each test function runs in a new zsh with the theme sourced, inside an empty temporary directory.

DIR_TESTS=${0:A:h}
THEME_FILE=${DIR_TESTS:h}/zsh-theme.zsh
TEST_FUNCTION_PREFIX='test_'

# isolate git from user and system configuration
export GIT_CONFIG_GLOBAL=/dev/null
export GIT_CONFIG_NOSYSTEM=1
export GIT_AUTHOR_NAME=test GIT_AUTHOR_EMAIL=test@example.com
export GIT_COMMITTER_NAME=test GIT_COMMITTER_EMAIL=test@example.com
export TERM=xterm-256color
export LC_ALL=C.UTF-8 # count multibyte characters (e.g. ellipsis) as one

main() {
    local -a TEST_FILES
    if [[ -n $1 ]]; then
        TEST_FILES=( ${1:A} )
    else
        TEST_FILES=( ${DIR_TESTS}/*_test.zsh(N) )
    fi

    local COUNT_TOTAL=0
    local COUNT_FAIL=0
    local -a FAILURES

    local FILE FUNCTION OUTPUT
    local -a FUNCTIONS
    for FILE in $TEST_FILES; do
        if [[ ! -f $FILE ]]; then
            print -r -- "Test file does not exist: ${FILE}"
            return 1
        fi

        FUNCTIONS=( ${(f)"$(get_test_functions "$FILE")"} )
        if [[ -n $2 ]]; then
            FUNCTIONS=( $2 )
        fi

        for FUNCTION in $FUNCTIONS; do
            (( COUNT_TOTAL++ ))
            OUTPUT=$(run_test "$FILE" "$FUNCTION")
            if (( $? == 0 )); then
                print -n "."
            else
                print -n $'\e[1;31mF\e[0m'
                (( COUNT_FAIL++ ))
                FAILURES+=( $'\e[1m'"${COUNT_FAIL})"$'\e[0m'" ${FILE:t} :: ${FUNCTION}"$'\n'"${OUTPUT}" )
            fi
        done
    done

    print "\n\nTests: ${COUNT_TOTAL}, Successful: $(( COUNT_TOTAL - COUNT_FAIL )), Failed: ${COUNT_FAIL}\n"
    if (( COUNT_FAIL > 0 )); then
        print -r -- $'\e[41m Failures \e[0m\n'
        print -rl -- ${^FAILURES}$'\n'
        return 1
    fi
    print -r -- $'\e[42m OK \e[0m'
}

get_test_functions() {
    grep -oE "^${TEST_FUNCTION_PREFIX}[A-Za-z0-9_]+" "$1"
}

run_test() {
    local FILE=$1
    local FUNCTION=$2
    local DIR_TMP
    DIR_TMP=$(mktemp -d) || return 1

    (
        cd "$DIR_TMP" \
        && HOME=$DIR_TMP zsh -f -c 'source "$1" && source "$2" && source "$3" && "$4"' \
            run_test "${DIR_TESTS}/asserts.zsh" "$THEME_FILE" "$FILE" "$FUNCTION"
    ) 2>&1
    local STATUS=$?

    rm -rf "$DIR_TMP"
    return $STATUS
}

main "$@"
