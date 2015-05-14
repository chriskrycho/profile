# This is my configuration sequence. It assumes the value of `$PKG_MGR` is
# correct: probably `apt-get` or `yum`. It assumes that $ARCH is set as either
# `x86` or `x86_64`.

# Get user info
user=$(whoami)
home=$(eval echo ~$user)

# Set up home directory structure as necessary
mkdir -p $home/bin $home/tools

# Install dev tools. Git in particular is basically necessary for a bunch of the
# other stuff.
sudo $PKG_MGR install zsh git mercurial curl wget

# TODO: Install and start Dropbox
cd $home && wget -O - "https://www.dropbox.com/download?plat=lnx.$ARCH | tar xzf -"
$home/.dropbox-dist/dropboxd
cd $home/bin && { curl -O "https://www.dropbox.com/download??dl=packages/dropbox.py"; cd -; }

# Install zsh. Once it's installed, make it the default user shell; then set up
# oh-my-zsh.
sudo $PKG_MGR install zsh
sudo chsh -s /bin/zsh
curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh

# Install the hg prompt plugin used by the krycho.zsh-theme
hg clone https://bitbucket.org/sjl/hg-prompt/ tools/hg_extensions/hg-prompt

# Clone my profile configuration.
git clone https://github.com/chriskrycho/profile
ln -sf "$home/profile/.zshrc" "$home/.zshrc"
ln -sf "$home/profile/.hgrc" "$home/.hgrc"
ln -sf "$home/profile/krycho.zsh-theme" "$home/.oh-my-zsh/themes/"

# Set keyboard mapping to make Ctrl/Caps-lock flipped (and thus, tolerable)
echo 'setxkbmap -model pc105 -layout us -option caps:ctrl_modifier' >> $home/.zshrc
echo 'xinput set-button-map 7 1 2 3 5 4 6 7 8 9 10 11' >> $home/.zshrc

# TODO: Install desired languages and associated tooling
# Python dependencies
# TODO: make this not explicitly depend on Fedora/yum
sudo $PKG_MGR install zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel

# Setup for pyenv and pyenv-virtualenv
git clone https://github.com/yyuu/pyenv $home/.pyenv
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> $home/.zshrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> $home/.zshrc
echo 'eval "$(pyenv init -)"' >> $home/.zshrc
git clone https://github.com/yyuu/pyenv-virtualenv $home/.pyenv/plugins/pyenv-virtualenv
echo 'eval "$(pyenv virtualenv-init -)"' >> $home/.zshrc

# Switch to zsh to make pyenv available
exec zsh
pyenv install 3.4.3  # TODO: configure this to install desired version(s).

# Last of all, update *everything*.
sudo $PKG_MGR update

# All done!
exit