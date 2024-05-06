# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="random"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )
ZSH_THEME_RANDOM_IGNORED=(
  rgm
  frontcube
  cloud
  wezm
  theunraveler
  fwalch
)

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

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
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  colored-man-pages
)

source $ZSH/oh-my-zsh.sh

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
alias l="ls -lah"
alias t="tree"

# .config management
# This amazing solution is copied from here:
# https://news.ycombinator.com/item?id=11071754
#
# Original post:
################################################################################
# StreakyCobra on Feb 10, 2016 | on: Ask HN: What do you use to manage dotfiles?
#
# I use:
#
#     git init --bare $HOME/.myconf
#     alias config='/usr/bin/git --git-dir=$HOME/.myconf/ --work-tree=$HOME'
#     config config status.showUntrackedFiles no
#
# where my ~/.myconf directory is a git bare repository. Then any file within
# the home folder can be versioned with normal commands like:
#
#     config status
#     config add .vimrc
#     config commit -m "Add vimrc"
#     config add .config/redshift.conf
#     config commit -m "Add redshift config"
#     config push
#
# And so one…
#
# No extra tooling, no symlinks, files are tracked on a version control system,
# you can use different branches for different computers, you can replicate you
# configuration easily on new installation. 
################################################################################
# seliopou on Feb 10, 2016
# 
# To complete the description of the workflow (for others), you can replicate
# your home directory on a new machine using the following command:
# 
#    git clone --separate-git-dir=~/.myconf /path/to/repo ~
# 
# This is the best solution I've seen so far, and I may adopt it next time I get
# the itch to reconfigure my environment.
################################################################################
# telotortium on Feb 11, 2016
# 
# For posterity, note that this will fail if your home directory isn't empty. To
# get around that, clone the repo's working directory into a temporary directory
# first and then delete that directory,
# 
#     git clone --separate-git-dir=$HOME/.myconf /path/to/repo $HOME/myconf-tmp
#     cp ~/myconf-tmp/.gitmodules ~  # If you use Git submodules
#     rm -r ~/myconf-tmp/
#     alias config='/usr/bin/git --git-dir=$HOME/.myconf/ --work-tree=$HOME'
# 
# and then proceed as before.
################################################################################
alias cygconf='/usr/bin/git --git-dir=$HOME/.cygconf/ --work-tree=$HOME'
