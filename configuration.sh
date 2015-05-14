# This is my configuration sequence. It assumes the value of `$PKG_MGR` is
# correct: probably `apt-get` or `yum`. It must be called as sudo.

# Get user info
user=$(whoami)
home=$(eval echo ~$user)

# Install dev tools. Git in particular is basically necessary for a bunch of the
# other stuff.
$PKG_MGR install git mercurial curl

# TODO: Install and start Dropbox

# Install zsh. Once it's installed, make it the default user shell; then set up
# oh-my-zsh.
$PKG_MGR install zsh
chsh -s /bin/zsh
curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
ln -s "$home/Dropbox/config/.zshrc" "$home/.zshrc"
ln -s "$home/Dropbox/config/krycho.zsh-theme" "$home/.oh-my-zsh/themes/"

# Set keyboard mapping to make Ctrl/Caps-lock flipped (and thus, tolerable)
echo 'setxkbmap -model pc105 -layout us -option caps:ctrl_modifier' >> ~/.zshrc
echo 'xinput set-button-map 7 1 2 3 5 4 6 7 8 9 10 11' >> ~/.zshrc

# TODO: Install desired languages and associated tooling
# Python dependencies
# TODO: make this not explicitly depend on Fedora/yum
$PKG_MGR install zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel

# Setup for pyenv and pyenv-virtualenv
git clone https://github.com/yyuu/pyenv $home/.pyenv
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(pyenv init -)"' >> ~/.zshrc
git clone https://github.com/yyuu/pyenv-virtualenv $home/.pyenv/plugins/pyenv-virtualenv
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.zshrc
exec zsh

pyenv install 3.4.3  # TODO: configure this to install desired version(s).

# Last of all, update *everything*.
$PKG_MGR update

# All done!
exit