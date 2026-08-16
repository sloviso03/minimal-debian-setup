case $- in
    *i*) ;;
      *) return;;
esac

HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s checkwinsize

if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[38;5;242m\]\u@\h\[\033[00m\]:\[\033[38;5;250m\]\w\[\033[01;37m\]\$ \[\033[00m\]'
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi


unset color_prompt force_color_prompt

case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi
export LS_COLORS='di=01;31:ln=01;36:so=01;35:pi=33:ex=01;32:bd=34;43:cd=34;43:su=37;41:sg=30;43:tw=30;42:ow=34;42:'

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


# Exports
eval "$(zoxide init bash --cmd cd)"
export PATH="$HOME/.local/bin:$PATH"
export EDITOR="micro"
export VISUAL="micro"
export QT_QPA_PLATFORM=wayland
export MOZ_ENABLE_WAYLAND=1

# FZF integration
if [ -f /usr/share/doc/fzf/examples/key-bindings.bash ]; then
  source /usr/share/doc/fzf/examples/key-bindings.bash
fi


# Aliases
alias ls='ls -lah --color=auto'
alias la='ls -la --color=auto'
alias fastfetch='fastfetch --structure Title:Separator:Os:Kernel:Uptime:Packages:WM:Terminal:Shell:Memory:Disk:Battery:LocalIp:Locale'
alias fzf-clear='history -c && history -w && clear'
