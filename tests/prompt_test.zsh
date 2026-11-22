# Tests for prompt behavior.

# Previous command status

test_status_success() {
    true
    assert_contains $'\e[32m➜' "$(print -P -- "$PROMPT")"
}

test_status_fail() {
    false
    assert_contains $'\e[31m➜' "$(print -P -- "$PROMPT")"
}

# Git reference

test_no_repo() {
    assert_equals "" "$(git_segment)"
}

test_branch() {
    repo_init
    assert_equals "%F{blue}[%F{red}main%F{blue}]%f " "$(git_segment)"
}

test_branch_without_commits() {
    git init -q -b main
    assert_equals "%F{blue}[%F{red}main%F{blue}]%f " "$(git_segment)"
}

test_branch_max_length() {
    repo_init
    git checkout -q -b feature-15-char
    assert_equals "%F{blue}[%F{red}feature-15-char%F{blue}]%f " "$(git_segment)"
}

test_branch_truncated() {
    repo_init
    git checkout -q -b feature-long-branch-name
    assert_equals "%F{blue}[%F{red}feature-long-b…%F{blue}]%f " "$(git_segment)"
}

test_tag() {
    repo_init
    git tag v1.0.0
    git checkout -q v1.0.0
    assert_equals "%F{blue}[%F{red}v1.0.0%F{blue}]%f " "$(git_segment)"
}

test_commit_sha() {
    repo_init
    git checkout -q --detach
    assert_equals "%F{blue}[%F{red}$(git rev-parse --short HEAD)%F{blue}]%f " "$(git_segment)"
}

# Uncommitted changes

test_changes_modified() {
    repo_diverged
    print changed > file
    assert_equals "%F{blue}[%F{red}other %F{yellow}•%F{blue}]%f " "$(git_segment)"
}

test_changes_untracked() {
    repo_init
    print new > file
    assert_equals "%F{blue}[%F{red}main %F{yellow}•%F{blue}]%f " "$(git_segment)"
}

# Git action

test_action_rebase() {
    repo_diverged
    git rebase -q main &> /dev/null
    local SHA=$(git rev-parse --short HEAD)
    assert_equals "%F{blue}[%F{red}${SHA} %F{yellow}• %F{yellow}rebase%F{blue}]%f " "$(git_segment)"
}

test_action_rebase_without_changes() {
    repo_diverged
    git rebase -q --exec false HEAD~1 &> /dev/null
    local SHA=$(git rev-parse --short HEAD)
    assert_equals "%F{blue}[%F{red}${SHA} %F{yellow}rebase%F{blue}]%f " "$(git_segment)"
}

test_action_merge() {
    repo_diverged
    git merge -q main &> /dev/null
    assert_equals "%F{blue}[%F{red}other %F{yellow}• %F{yellow}merge%F{blue}]%f " "$(git_segment)"
}

test_action_cherry_pick() {
    repo_diverged
    git cherry-pick main &> /dev/null
    assert_equals "%F{blue}[%F{red}other %F{yellow}• %F{yellow}cherry%F{blue}]%f " "$(git_segment)"
}

test_action_revert() {
    repo_diverged
    git checkout -q main
    git revert --no-edit HEAD~1 &> /dev/null
    assert_equals "%F{blue}[%F{red}main %F{yellow}• %F{yellow}revert%F{blue}]%f " "$(git_segment)"
}

test_action_revert_multiple_commits() {
    repo_diverged
    git checkout -q main
    print x > other-file && git add other-file && git commit -q -m "x"
    git revert --no-edit HEAD~2 HEAD~1 &> /dev/null
    assert_equals "%F{blue}[%F{red}main %F{yellow}• %F{yellow}revert%F{blue}]%f " "$(git_segment)"
}

# Theme loading

test_precmd_hook_added_once() {
    source "$THEME_FILE" # second time, first is done by test runner
    assert_equals "theme_precmd" "${precmd_functions[*]}"
}

# Helpers

git_segment() {
    theme_precmd
    print -r -- "${vcs_info_msg_0_}"
}

# Creates repository in current directory (temporary directory of the test)
repo_init() {
    git init -q -b main
    git commit -q --allow-empty -m "init"
}

# Creates repository in current directory (temporary directory of the test) with diverged history.
# Branch "main" changes file to "b", branch "other" changes it to "c".
repo_diverged() {
    git init -q -b main
    print a > file && git add file && git commit -q -m "a"
    print b > file && git commit -q -am "b"
    git checkout -q -b other HEAD~1
    print c > file && git commit -q -am "c"
}
