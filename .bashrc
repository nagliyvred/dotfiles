
export HISTCONTROL=erasedups
export HISTSIZE=5000
export HISTTIMEFORMAT="%F %T "

# append to the history file, don't overwrite it
shopt -s histappend
# check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s checkwinsize
# correct minor errors in the spelling of a directory component in a cd command
shopt -s cdspell
# save all lines of a multiple-line command in the same history entry (allows easy re-editing of multi-line commands)
shopt -s cmdhist

export TERM=xterm-256color

USER=`whoami`
if [ $LOGNAME = $USER ] ; then
  COLOUR=44
else
  COLOUR=45
fi

if [ $USER = 'root' ] ; then
  COLOUR=41
fi
#myself=`whoami`
#if [[ "$myself" == "root" ]]; then
#	PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#else
#	PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#fi

# bash aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# get git status
function parse_git_status {
    # clear git variables
    GIT_BRANCH=
    GIT_DIRTY=

    # exit if no git found in system
    local GIT_BIN=$(which git 2>/dev/null)
    [[ -z $GIT_BIN ]] && return

    # check we are in git repo
    local CUR_DIR=$PWD
    while [ ! -d ${CUR_DIR}/.git ] && [ ! $CUR_DIR = "/" ]; do CUR_DIR=${CUR_DIR%/*}; done
    [[ ! -d ${CUR_DIR}/.git ]] && return

    # 'git repo for dotfiles' fix: show git status only in home dir and other git repos
    [[ $CUR_DIR == $HOME ]] && [[ $PWD != $HOME ]] && return

    # get git branch
    GIT_BRANCH=$($GIT_BIN symbolic-ref HEAD 2>/dev/null)
    [[ -z $GIT_BRANCH ]] && return
    GIT_BRANCH=${GIT_BRANCH#refs/heads/}

    # get git status
    local GIT_STATUS=$($GIT_BIN status --porcelain 2>/dev/null)
    [[ -n $GIT_STATUS ]] && GIT_DIRTY=true
}

# setup color variables
color_is_on=
color_red=
color_green=
color_yellow=
color_blue=
color_white=
color_gray=
color_bg_red=
color_off=
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    color_is_on=true
    color_red="\[$(/usr/bin/tput setaf 1)\]"
    color_green="\[$(/usr/bin/tput setaf 2)\]"
    color_yellow="\[$(/usr/bin/tput setaf 3)\]"
    color_blue="\[$(/usr/bin/tput setaf 4)\]"
    color_white="\[$(/usr/bin/tput setaf 7)\]"
    color_gray="\[$(/usr/bin/tput setaf 8)\]"
    color_off="\[$(/usr/bin/tput sgr0)\]"

    color_error="$(/usr/bin/tput setab 1)$(/usr/bin/tput setaf 7)"
    color_error_off="$(/usr/bin/tput sgr0)"

    # set user color
    case `id -u` in
        0) color_user=$color_red ;;
        *) color_user=$color_green ;;
    esac
fi

# some kind of optimization - check if git installed only on config load
PS1_GIT_BIN=$(which git 2>/dev/null)

function prompt_command {
    local PS1_GIT=
    local PWDNAME=$PWD



    # get cursor position and add new line if we're not in first column
    #exec < /dev/tty
    #local OLDSTTY=$(stty -g)
    #stty raw -echo min -1
    #echo -en "\033[6n" > /dev/tty && read -sdR CURPOS
    #stty $OLDSTTY
    #[[ ${CURPOS##*;} -gt 1 ]] && echo "${color_error}↵${color_error_off}"

    echo -en "\033[6n" && read -sdR CURPOS
    [[ ${CURPOS##*;} -gt 1 ]] && echo "${color_error}↵${color_error_off}"
    
    # beautify working firectory name
    if [ $HOME == $PWD ]; then
        PWDNAME="~"
    elif [ $HOME ==  ${PWD:0:${#HOME}} ]; then
        PWDNAME="~${PWD:${#HOME}}"
    fi

    # set title
    echo -ne "\033]0;${USER}@${HOSTNAME}:${PWDNAME}"; echo -ne "\007"

    # parse git status and get git variables
    if [[ ! -z $PS1_GIT_BIN ]]; then
        # check we are in git repo
        local CUR_DIR=$PWD
        while [[ ! -d "${CUR_DIR}/.git" ]] && [[ ! "${CUR_DIR}" == "/" ]] && [[ ! "${CUR_DIR}" == "~" ]] && [[ ! "${CUR_DIR}" == "" ]]; do CUR_DIR=${CUR_DIR%/*}; done
        if [[ -d "${CUR_DIR}/.git" ]]; then
            # 'git repo for dotfiles' fix: show git status only in home dir and other git repos
            if [[ "${CUR_DIR}" != "${HOME}" ]] || [[ "${PWD}" == "${HOME}" ]]; then
                # get git branch
                GIT_BRANCH=$($PS1_GIT_BIN symbolic-ref HEAD 2>/dev/null)
                if [[ ! -z $GIT_BRANCH ]]; then
                    GIT_BRANCH=${GIT_BRANCH#refs/heads/}

                    # get git status
                    local GIT_STATUS=$($PS1_GIT_BIN status --porcelain 2>/dev/null)
                    [[ -n $GIT_STATUS ]] && GIT_DIRTY=1
                fi
            fi
        fi
    fi

    [[ ! -z $GIT_BRANCH ]] && PS1_GIT=" (git: ${GIT_BRANCH})"
    
    if $color_is_on; then
        # build git status for prompt
        if [[ ! -z $GIT_BRANCH ]]; then
            if [[ -z $GIT_DIRTY ]]; then
                PS1_GIT=" (git: ${color_green}${GIT_BRANCH}${color_off})"
            else
                PS1_GIT=" (git: ${color_red}${GIT_BRANCH}${color_off})"
            fi
        fi

        # build python venv status for prompt
        [[ ! -z $VIRTUAL_ENV ]] && PS1_VENV=" (venv: ${color_blue}${VIRTUAL_ENV#$WORKON_HOME}${color_off})"
    fi

    vcp=`vcprompt -f '(%n: %r%u%m)'`
    echo $vcp | grep '(hg:' 2>&1 > /dev/null
    if [ $? -eq 0 ]; then
        echo $vcp | grep -e '[+?]' 2>&1 > /dev/null
        if [ $? -eq 0 ]; then
            color=${color_red}
        else
            color=${color_green}
        fi
        PS1_GIT="${color} $vcp${color_off}"
    fi
    # set new color prompt
    PS1="${color_user}${USER}${color_off}@${color_yellow}${HOSTNAME}${color_off}:${color_blue}${PWDNAME}${color_off}${PS1_GIT}\n➜ "

}
PROMPT_COMMAND=prompt_command

##
# Your previous /Users/edudin/.bash_profile file was backed up as /Users/edudin/.bash_profile.macports-saved_2012-01-17_at_15:17:23
##

# MacPorts Installer addition on 2012-01-17_at_15:17:23: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:/usr/local/scala/bin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

if [ -f bash_env.sh ]; then
    source bash_env.sh
fi

if [ -f /opt/local/etc/bash_completion ]; then
    . /opt/local/etc/bash_completion
fi

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
export CC=gcc-4.2
export JAVA_HOME=/opt/java/

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

if [ -f nbn_stuff.sh ]; then
    source nbn_stuff.sh
fi

