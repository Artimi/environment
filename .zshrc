# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="jreese"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git extract autojump)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=$PATH:/home/psebek/bin:/home/psebek/bin:/usr/lib64/ccache:/usr/libexec/lightdm:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/home/psebek//.local/bin:/home/psebek//bin

alias ls='ls -a --color=always  --group-directories-first'
alias ll='ls -l -a --color=always  --group-directories-first'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias du='du -hc'
alias gvir="gvim --remote"
alias gvim_show='gvim $(git show --pretty="format:" --name-only)'


export PATH="/home/psebek/bin:$PATH";
export HISTTIMEFORMAT='%F %T '

export JAVA_HOME="/usr/java/latest"
## Moving around & all that jazz

#git autocompletion
#if [ -f ~/bin/git-completion.bash ]; then
    #. ~/bin/git-completion.bash
#fi

vdsm_to_repo() {
    rm -fv /var/www/html/vdsm/vdsm-*
    VERSION=`ls ~/rpmbuild/RPMS/x86_64/ -t -w 1 | head -1 | perl -pe 's|^.*?git|git|' | perl -pe 's|\.el6.*||'`
    FILES=`find ~/rpmbuild/RPMS/ | grep $VERSION`
    for package in "${FILES[@]}"
    do
        mv -v $package /var/www/html/vdsm/
    done
    createrepo /var/www/html/vdsm
    restorecon -rv /var/www/html/vdsm
    yum clean expire-cache
}

install_latest_vdsm() {
    yum install -y vdsm vdsm-python vdsm-cli vdsm-xmlrpc vdsm-reg vdsm-debug-plugin
}

remove_vdsm() {
    yum erase -y `rpm -qa | grep vdsm | perl -pe 's|-[0-9].*||' | paste -sd " "`
}
source /usr/bin/virtualenvwrapper.sh

function ipmi() {
    local host="$2"
    local ipmi_user=root
    local ipmi_pass=calvin
    local option
    echo "Connecting to $2"
    case $1 in
        start)   option="-n";;
        stop)    option="-f";;
        restart) option="-r";;
        cycle)   option="-c";;
        soft)    option="--soft";;
        status)  option="-s";;
        console)
            ipmitool -vI lanplus -U $ipmi_user -P $ipmi_pass -H $host sol activate
            return $?
            ;;
    esac
    ipmi-power -u$ipmi_user -p$ipmi_pass $option -h $host
}


