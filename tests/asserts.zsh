# Assert functions available in every test

assert_equals() {
    local EXPECTED=$1
    local ACTUAL=$2
    if [[ $ACTUAL == "$EXPECTED" ]]; then
        return 0
    fi
    print -r -- $'\e[33mExpected: \e[0m'"${EXPECTED}"
    print -r -- $'\e[36mActual:   \e[0m'"${ACTUAL}"
    return 1
}

assert_contains() {
    local EXPECTED=$1
    local ACTUAL=$2
    if [[ $ACTUAL == *"$EXPECTED"* ]]; then
        return 0
    fi
    print -r -- $'\e[33mContains: \e[0m'"${EXPECTED}"
    print -r -- $'\e[36mActual:   \e[0m'"${ACTUAL}"
    return 1
}
