[ -z "$PS1" ] && return

shopt -s checkwinsize

if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

shopt -s checkwinsize

PAGER='most'
EDITOR='vim'

if [[ $EUID -eq 0 ]] ; then
  export PS1='\[\e[1;31m\]\u@\h:\w\[\e[$(($??7:0));37m\]\$\[\e[0;0m\] '
else
  export PS1='\[\e[1;32m\]\u@\h:\w\[\e[$(($??7:0));37m\]\$\[\e[0;0m\] '
fi

alias ls='ls --color=always --human-readable --classify'
alias df='df --human-readable'
alias du='du --human-readable'
alias ssh='ssh -A -l root'
alias rsync='rsync --numeric-ids'
alias grep='grep --color=always --with-filename --line-number'
alias screen='byobu'

[[ -x /etc/bash.bashrc.d ]] &&
for file in /etc/bash.bashrc.d/* ; do
    source $file ;
done;

