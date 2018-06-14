#!/usr/bin/env sh
# install-phantom.js (You need to run this if you want to download/stream from openload.co and other sites that aren't natively supported by youtube-dl)
# vim:ft=sh
#
# Created by Matteo Guarda


youtube_dl_batch_files_dir=$(pwd)


echo; read -p "==> PhantomJS for GNU/Linux is only available for x86_64 and i686 systems, if you are using a different CPU architecture, interrupt the script by pressing CTRL-C, continue by pressing ENTER: " agnipau


which tar &> /dev/null; [[ $? != 0 ]] && echo && echo "==> You need to install tar!" && exit 1
which wget &> /dev/null; [[ $? != 0 ]] && echo && echo "==> You need to install wget!" && exit 1


echo
echo "==> Are you running a 64 bit or 32 bit GNU/Linux system? Enter only the number:"
read -p "==> " arc


if [[ $arc == 64 ]]; then
  rm -rf .phantomjs
  mkdir -p .phantomjs
  cd .phantomjs
  echo
  echo "==> Starting do download PhantomJS..."
  echo
  wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2
  tar -xvf phantomjs-2.1.1-linux-x86_64.tar.bz2 && rm -rf phantomjs-2.1.1-linux-x86_64.tar.bz2
  [[ -f ${HOME}/.bashrc ]] && echo >> ${HOME}/.bashrc && echo "export \$PATH=${youtube_dl_batch_files_dir}/.phantomjs/phantomjs-2.1.1-linux-x86_64/bin:\${PATH}" >> ${HOME}/.bashrc
  [[ -f ${HOME}/.zshrc ]] && echo >> ${HOME}/.zshrc && echo "export \$PATH=${youtube_dl_batch_files_dir}/.phantomjs/phantomjs-2.1.1-linux-x86_64/bin:\${PATH}" >> ${HOME}/.zshrc
  echo
  echo "==> Restart your shell to get things work. If PhantomJS doesn't work, add this line, but without quotes, in your shell's config file: 'export \$PATH=${youtube_dl_batch_files_dir}/.phantomjs/phantomjs-2.1.1-linux-x86_64/bin:\${PATH}'"
  exit 0
elif [[ $arc == 32 ]]; then
  rm -rf .phantomjs
  mkdir -p .phantomjs
  cd .phantomjs
  echo
  echo "==> Starting do download PhantomJS..."
  echo
  wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-i686.tar.bz2
  tar -xvf phantomjs-2.1.1-linux-i686.tar.bz2 && rm -rf phantomjs-2.1.1-linux-i686.tar.bz2
  [[ -f ${HOME}/.bashrc ]] && echo >> ${HOME}/.bashrc && echo "export \$PATH=${youtube_dl_batch_files_dir}/.phantomjs/phantomjs-2.1.1-linux-i686/bin:\${PATH}" >> ${HOME}/.bashrc
  [[ -f ${HOME}/.zshrc ]] && echo >> ${HOME}/.zshrc && echo "export \$PATH=${youtube_dl_batch_files_dir}/.phantomjs/phantomjs-2.1.1-linux-i686/bin:\${PATH}" >> ${HOME}/.zshrc
  echo
  echo "==> Restart your shell to get things work. If PhantomJS doesn't work, add this line, but without quotes, in your shell's config file: 'export \$PATH=${youtube_dl_batch_files_dir}/.phantomjs/phantomjs-2.1.1-linux-i686/bin:\${PATH}'"
  exit 0
fi
