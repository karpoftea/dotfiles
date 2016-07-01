### Description
# Sets iTerm2 profile on ssh connection

### Usage
# To enable coloring feature add alias for ssh command: 'alias ssh=color_ssh'

### Aliasing IP or Domain
# To alias ip to domain use '/etc/hosts'
# To alias domain use '~/.ssh/config' 
# For example:
# Host dev-my-host
# HostName my-host.long.name
# User my-user


function set_profile() {
  NAME=$1; if [ -z "$NAME" ]; then NAME="Default"; fi
  # if you have trouble with this, change
  # "Default" to the name of your default theme
  echo -e "\033]50;SetProfile=$NAME\a"
}

function reset_profile() {
    NAME="Default"
    echo -e "\033]50;SetProfile=$NAME\a"
    trap - INT EXIT
}

function color_ssh() {
    if [[ -n "$ITERM_SESSION_ID" ]]; then
        trap "reset_profile" INT EXIT
        if [[ "$*" =~ prod-.* ]]; then
            set_profile Production
        elif [[ "$*" =~ dev-.* ]]; then
            set_profile Develop
        elif [[ "$*" =~ local-.* ]]; then
            set_profile Local
        else
            set_profile Default
        fi
    fi
    ssh $*
}
