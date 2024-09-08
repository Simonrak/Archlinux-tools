#Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
#Initialization code that may require console input (password prompts, [y/n]
#confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Define plugin paths
# If you come from bash you might have to change your $PATH.
#export PATH=$HOME/bin:/usr/local/bin:$PATH
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"
# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )
#POWERLEVEL10K_MODE='flat'
# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.0
# Case-sensitive completion must be off. _ and - will be interchangeable.\
HYPHEN_INSENSITIVE="true"
HISTSIZE=10000
SAVEHIST=10000
# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
#ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy/mm/dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
export ZSH_AUTOSUGGESTIONS_PATH="$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
export ZSH_SYNTAX_HIGHLIGHTING_PATH="$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
plugins=(git python zoxide brew systemd colorize cp compleat dircycle dirpersist extract rsync screen safe-paste sprunge tmux lol tmuxinator urltools wakeonlan web-search aliases zoxide dirhistory history copypath copyfile sudo copybuffer colored-man-pages fancy-ctrl-z command-not-found docker-compose fzf)
source $ZSH/oh-my-zsh.sh
source $ZSH_AUTOSUGGESTIONS_PATH
source $ZSH_SYNTAX_HIGHLIGHTING_PATH
source $HOME/.fzf/shell/key-bindings.zsh
source $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
#source $HOME/.oh-my-zsh/plugins/auto-fu/auto-fu.zsh
#source ~/.oh-my-zsh/lib/key-bindings.zsh
# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8


# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

 # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
 [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
 alias H="tail -n 100 ~/.zsh_history"
 alias PASTE="| pastebinit"

 POWERLEVEL9K_DIR_PATH_ABSOLUTE=true
 POWERLEVEL9K_HOME_ICON='🤥'
 POWERLEVEL9K_HOME_SUB_ICON='🤥'
 POWERLEVEL9K_FOLDER_ICON='🤥'
 POWERLEVEL9K_ETC_ICON='🤥'
 POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir docker_machine vcs virtualenv root_indicator dir_writable)
 POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status ram background_jobs public_ip)
 alias zshconfig="nano ~/.zshrc"
 alias ohmyzsh="nano ~/.oh-my-zsh"
 alias p10kconfig="nano ~/.p10k.zsh"
 #list all files
 alias la='eza -lgaF --icons=always --color=always  --sort=name --group-directories-first -o'
 #list all files in current directory
 alias lat='eza -lgaTF --level=2 --icons=always --color=always  --sort=name --group-directories-first -o --no-filesize'
 #list all files in current directory and subdirectories
 alias lad='eza -lgDF --icons=always --color=always  --sort=name --group-directories-first -o'
 #list all files in current directory and subdirectories and their sizes
 alias ladt='eza -lgaDTF --level=2 --icons=always --color=always  --sort=name --group-directories-first -o --no-filesize'
 #list all files in current directory
 alias laf='eza -lgfF --icons=always --color=always  --sort=name --group-directories-first -o'
 #list all files in current directory and subdirectories
 alias laft='eza -lgafTF --level=2 --icons=always --color=always  --sort=name --group-directories-first -o --no-filesize'
 alias dcof='docker compose -f'
 alias dco='docker compose'
 PROMPT="${PROMPT/\%c/\%~}"

 alias ENV="cat ~/ENVman.md"
 alias Aliases="nano ~/.zshrc"
 alias pbpaste="powershell.exe -command 'Get-Clipboard' | sed -e 's/\r\n$//g'"
 alias xclip="xclip -selection c"
 # usage: cheat bash/sed
 
export PATH="$PATH:/home/$USER/.local/bin"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
