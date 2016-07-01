### Description
# Adds git branch name to command prompt

### Usage
# Add to .bash_profile: 
# if [ -f ~/.show-git-branch.bash ]; then
#   . ~/.show-git-branch.bash
# fi

# Git branch in prompt.
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

export PS1="\u@\h \W\[\033[32m\]\$(parse_git_branch)\[\033[00m\] $ "
