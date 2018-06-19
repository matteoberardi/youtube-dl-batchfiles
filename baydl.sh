#!/usr/bin/env sh
# Script written in BASH that automates the download process of the videos from youtube-dl using the provided batch files


# Help text
help() {
  echo "BAtchYoutube-DL"
  echo "(https://github.com/matteoguarda/youtube-dl-batchfiles)"
  echo
  echo "Usage: baydl.sh --> standard menu"
  echo "       baydl.sh -s [category]/[lang]/[batch-dir]/[batch-file]/[modality] --> for a faster way of using the script."
  echo
  echo "Options:"
  echo "    -h, --help --> show this help text."
  echo "    -s, --short [category]/[lang]/[batch-dir]/[batch-file]/[modality] --> the fastest way to use the script."
  echo "    -v, --view [all/modalities] --> view the available options."
}


# This is required if you run the script with wget and not by cloning the repo
if [ ! -d batch-files ]; then
  git clone https://github.com/matteoguarda/youtube-dl-batchfiles --depth 1
  cd youtube-dl-batchfiles
fi

if [ ! -d downloaded ]; then
  mkdir -p downloaded
fi


# With these lines an alias for baydl.sh should work
# For example you can try to put this in your .bashrc or .zshrc: alias baydl="cd [path to youtube-dl-batchfiles] && ./baydl.sh"
# Note that the alias won't work when launching the script in its short form
root=$(pwd)
# Delete .masiero files
delmastot() {
  delmas() {
    rm -rf .megasiero
    for i in $(ls); do cd $i; rm -rf .masiero; cd ..; done
  }
  cd ${root}/batch-files
  for m in $(ls); do cd $m; for g in $(ls); do cd $g; delmas; cd ..; done; cd ..; done
}
delmastot
cd ${root}/batch-files


# Crono function
crono() {
  echo
  read -p "==> Premi [INVIO] quando sei pronto a iniziare: " agnipau
  echo

  ore_prima=$(echo $(echo $(date) | cut -d " " -f 5 ) | cut -d . -f 1)
  minuti_prima=$(echo $(echo $(date) | cut -d " " -f 5 ) | cut -d . -f 2)
  secondi_prima=$(echo $(echo $(echo $(date) | cut -d " " -f 5 ) | cut -d . -f 3) | cut -d , -f 1)


  echo
  read -p "==> Premi [INVIO] quando hai finito: " agnipau
  echo

  ore_dopo=$(echo $(echo $(date) | cut -d " " -f 5 ) | cut -d . -f 1)
  minuti_dopo=$(echo $(echo $(date) | cut -d " " -f 5 ) | cut -d . -f 2)
  secondi_dopo=$(echo $(echo $(echo $(date) | cut -d " " -f 5 ) | cut -d . -f 3) | cut -d , -f 1)


  ore_finali=$(( $ore_dopo - $ore_prima ))
  minuti_finali=$(( $minuti_dopo - $minuti_prima ))
  secondi_finali=$(( $secondi_dopo - $secondi_prima ))

  if [ $(printf $ore_finali | wc -m ) -eq 1 ]; then
    ore_finali="0${ore_finali}"
  fi
  if [ $(printf $minuti_finali | wc -m ) -eq 1 ]; then
    minuti_finali="0${minuti_finali}"
  fi
  if [ $(printf $secondi_finali | wc -m ) -eq 1 ]; then
    secondi_finali="0${secondi_finali}"
  fi

  tempo_prima=$(echo ${ore_prima}:${minuti_prima}:${secondi_prima})
  tempo_dopo=$(echo ${ore_dopo}:${minuti_dopo}:${secondi_dopo})
  tempo_finale=$(echo ${ore_finali}:${minuti_finali}:${secondi_finali})


  echo
  echo "==> Hai iniziato alle $tempo_prima"
  echo "==> Hai finito alle $tempo_dopo"
  echo
  echo "==> Ci hai messo $tempo_finale"
  echo
}


# Category prompt
category() {
  clear
  echo
  echo "==> Choose a category from the list:"
  echo "==> [q to quit]"
  echo
  for i in $(ls); do if [ "$i" != "template" ]; then echo "  ==> $i"; fi; done
  echo
  read -p "==> " chosen_category
  if [ "$chosen_category" = "q" ] || [ "$chosen_category" = "e" ]; then
    echo
    exit
  elif [ -d $chosen_category ]; then
    cd $chosen_category
  elif [ ! -d $chosen_category ]; then
    clear
    echo
    echo "==> Specified category isn't available!"
    sleep 2s
    category
  fi
}


# Language prompt
lang() {
  clear
  echo
  echo "==> Choose a language from the list:"
  echo "==> [q to quit] [b to go back]"
  echo
  for i in $(ls); do echo "  ==> $i"; done
  echo
  read -p "==> " chosen_lang
  if [ "$chosen_lang" = "q" ] || [ "$chosen_lang" = "e" ]; then
    echo
    exit
  elif [ "$chosen_lang" = "b" ]; then
    cd ..
    category
    lang
  elif [ -d $chosen_lang ]; then
    cd $chosen_lang
  elif [ ! -d $chosen_lang ]; then
    clear
    echo
    echo "==> Specified lang isn't available!"
    sleep 2s
    lang
  fi
}


# Small function for controlling the exit code of youtube-dl and open the chosen batch file in the default editor if the download fails
ydl_control_ecode() {
  if [ $? -eq 0 ]; then
    clear
    echo
    echo "==> Video succesfully downloaded!"
    echo
  else
    clear
    echo
    echo "==> An error occurred and the video has not been succesfully downloaded, copy your link from here and open it in your browser."
    echo
    cat ../../batch-files/$chosen_category/$chosen_lang/$chosen_batch_dir/$chosen_batch_file
    echo
  fi
}


# Small function for controlling the exit code of mpv and open the chosen batch file in the default editor if an error occurs
mpv_control_ecode() {
  if [ ! $? -eq 0 ]; then
    clear
    echo
    echo "==> The site is not supported by mpv, copy your link from here and open it in your browser."
    echo
    cat ../../batch-files/$chosen_category/$chosen_lang/$chosen_batch_dir/$chosen_batch_file
    echo
  fi
}


# Fetch the extension of the video
ext_fetcher() {
  if [ "$(head -n $(( $chosen_line * 2 )) ../../batch-files/$chosen_category/$chosen_lang/$chosen_batch_dir/$chosen_batch_file | tail -1 | cut -d / -f 3)" = "vvvvid.it" ]; then
    ext=$(youtube-dl --get-filename $(head -n $(( $chosen_line * 2 )) ../../batch-files/$chosen_category/$chosen_lang/$chosen_batch_dir/$chosen_batch_file | tail -1) | cut -d . -f2)
  elif [ "$(head -n $(( $chosen_line * 2 )) ../../batch-files/$chosen_category/$chosen_lang/$chosen_batch_dir/$chosen_batch_file | tail -1 | cut -d / -f 3)" = "streamango.com" ]; then
    ext=$(youtube-dl --get-filename $(head -n $(( $chosen_line * 2 )) ../../batch-files/$chosen_category/$chosen_lang/$chosen_batch_dir/$chosen_batch_file | tail -1) | cut -d - -f2 | cut -d . -f 2)
  elif [ "$(head -n $(( $chosen_line * 2 )) ../../batch-files/$chosen_category/$chosen_lang/$chosen_batch_dir/$chosen_batch_file | tail -1 | cut -d / -f 3)" = "openload.co" ]; then
    ext=$(youtube-dl --get-filename $(head -n $(( $chosen_line * 2 )) ../../batch-files/$chosen_category/$chosen_lang/$chosen_batch_dir/$chosen_batch_file | tail -1) | cut -d - -f2 | cut -d . -f 2)
  elif [ "$(head -n $(( $chosen_line * 2 )) ../../batch-files/$chosen_category/$chosen_lang/$chosen_batch_dir/$chosen_batch_file | tail -1 | cut -d / -f 3)" = "openload.com" ]; then
    ext=$(youtube-dl --get-filename $(head -n $(( $chosen_line * 2 )) ../../batch-files/$chosen_category/$chosen_lang/$chosen_batch_dir/$chosen_batch_file | tail -1) | cut -d - -f2 | cut -d . -f 2)
  fi
}


# Modality prompt
modality_func() {
  clear
  echo
  echo "==> Choose a modality:"
  echo
  echo "    ==> all         -> download all the videos in the chosen batch file."
  echo "    ==> single      -> download a single video from the chosen batch file."
  echo "    ==> from        -> download a single video and all its subsequent ones."
  echo "    ==> from-to     -> download a single video and all its subsequent ones to the one specified."
  echo "    ==> stream      -> stream a video using mpv."
  echo "    ==> last-stream -> stream the last episode."
  echo "    ==> last-down   -> download the last episode."
  echo
  echo "==> [q to quit] [b to go back]"
  echo
  read -p "==> " modality
  if [ "$modality" = "q" ] || [ "$modality" = "e" ]; then
    echo
    exit
  elif [ "$modality" = "b" ]; then
    cd ../../batch-files/$chosen_category/$chosen_lang
    batch_file
  elif [ "$modality" = "all" ]; then
    all_mod
  elif [ "$modality" = "single" ]; then
    single_mod
  elif [ "$modality" = "from" ]; then
    from_mod
  elif [ "$modality" = "from-to" ]; then
    from_to_mod
  elif [ "$modality" = "stream" ]; then
    stream_mod
  elif [ "$modality" = "last-stream" ]; then
    last_stream_mod
  elif [ "$modality" = "last-down" ]; then
    last_down_mod
  else
    clear
    echo
    echo "==> Enter a valid modality!"
    sleep 2s
    modality_func
  fi
}


# Single episode downloader
single_mod() {
  clear
  echo
  echo "==> Choose a video: [number in the brackets]"
  echo "==> [q to quit] [b to go back]"
  echo
  echo "  ->$(head -n 1 ../../batch-files/$chosen_category/$chosen_lang/$chosen_batch_dir/$chosen_batch_file | cut -d "#" -f 2)"
  echo "  ->$(head -n 3 ../../batch-files/$chosen_category/$chosen_lang/$chosen_batch_dir/$chosen_batch_file | tail -1 | cut -d "#" -f 2)"
  c=5
  while [ $c -lt $(wc -l ../../batch-files/$chosen_category/$chosen_lang/$chosen_batch_dir/$chosen_batch_file | cut -d " " -f 1) ]; do
    echo "  ->$(head -n $c ../../batch-files/$chosen_category/$chosen_lang/$chosen_batch_dir/$chosen_batch_file | tail -1 | cut -d "#" -f 2)"
    c=$(( $c + 2 ))
  done
  echo
  read -p "==> " chosen_line
  if [ "$chosen_line" = "q" ] || [ "$chosen_line" = "e" ]; then
    exit
  elif [ "$chosen_line" = "b" ]; then
    modality_func
  elif [ $chosen_line -le $(( $(wc -l ../../batch-files/$chosen_category/$chosen_lang/$chosen_batch_dir/$chosen_batch_file | cut -d " " -f 1) / 2 )) ] && [ $chosen_line -gt 0 ]; then
    ext_fetcher
    youtube-dl -o ${chosen_batch_file}_${chosen_line}.$ext $(head -n $(( $chosen_line * 2 )) ../../batch-files/$chosen_category/$chosen_lang/$chosen_batch_dir/$chosen_batch_file | tail -1)
    ydl_control_ecode
  else
    clear
    echo
    echo "==> Enter a valid number!"
    sleep 2s
    single_mod
  fi
}


# All episodes downloader
all_mod() {
  chosen_line=1
  ext_fetcher
  while [ $chosen_line -le $(( $(wc -l ../../batch-files/$chosen_category/$chosen_lang/$chosen_batch_dir/$chosen_batch_file | cut -d " " -f 1) / 2 )) ]; do
    youtube-dl -o ${chosen_batch_file}_${chosen_line}.$ext $(head -n $(( $chosen_line * 2 )) ../../batch-files/$chosen_category/$chosen_lang/$chosen_batch_dir/$chosen_batch_file | tail -1)
    ydl_control_ecode
    chosen_line=$(( $chosen_line + 1 ))
  done
}


# From to end episode downloader
from_mod() {
  clear
  echo
  echo "==> Specify a video where I have to start downloading: [number in the brackets]"
  echo "==> [q to quit] [b to go back]"
  echo
  echo "  ->$(head -n 1 ../../batch-files/$chosen_category/$chosen_lang/$chosen_batch_dir/$chosen_batch_file | cut -d "#" -f 2)"
  echo "  ->$(head -n 3 ../../batch-files/$chosen_category/$chosen_lang/$chosen_batch_dir/$chosen_batch_file | tail -1 | cut -d "#" -f 2)"
  c=5
  while [ $c -lt $(wc -l ../../batch-files/$chosen_category/$chosen_lang/$chosen_batch_dir/$chosen_batch_file | cut -d " " -f 1) ]; do
    echo "  ->$(head -n $c ../../batch-files/$chosen_category/$chosen_lang/$chosen_batch_dir/$chosen_batch_file | tail -1 | cut -d "#" -f 2)"
    c=$(( $c + 2 ))
  done
  echo
  read -p "==> " chosen_line
  if [ "$chosen_line" = "q" ] || [ "$chosen_line" = "e" ]; then
    echo
    exit
  elif [ "$chosen_line" = "b" ]; then
    modality_func
  elif [ $chosen_line -le $(( $(wc -l ../../batch-files/$chosen_category/$chosen_lang/$chosen_batch_dir/$chosen_batch_file | cut -d " " -f 1) / 2 )) ] && [ $chosen_line -gt 0 ]; then
    ext_fetcher
    while [ $chosen_line -le $(( $(wc -l ../../batch-files/$chosen_category/$chosen_lang/$chosen_batch_dir/$chosen_batch_file | cut -d " " -f 1) / 2 )) ]; do
      youtube-dl -o ${chosen_batch_file}_${chosen_line}.$ext $(head -n $(( $chosen_line * 2 )) ../../batch-files/$chosen_category/$chosen_lang/$chosen_batch_dir/$chosen_batch_file | tail -1)
      ydl_control_ecode
      chosen_line=$(( $chosen_line + 1 ))
    done
  else
    clear
    echo
    echo "==> Enter a valid number!"
    sleep 2s
    from_mod
  fi
}


# From-to episode downloader
from_to_mod() {
  clear
  echo
  echo "==> Specify a video where I have to start downloading: [number in the brackets]"
  echo "==> [q to quit] [b to go back]"
  echo
  echo "  ->$(head -n 1 ../../batch-files/$chosen_category/$chosen_lang/$chosen_batch_dir/$chosen_batch_file | cut -d "#" -f 2)"
  echo "  ->$(head -n 3 ../../batch-files/$chosen_category/$chosen_lang/$chosen_batch_dir/$chosen_batch_file | tail -1 | cut -d "#" -f 2)"
  c=5
  while [ $c -lt $(wc -l ../../batch-files/$chosen_category/$chosen_lang/$chosen_batch_dir/$chosen_batch_file | cut -d " " -f 1) ]; do
    echo "  ->$(head -n $c ../../batch-files/$chosen_category/$chosen_lang/$chosen_batch_dir/$chosen_batch_file | tail -1 | cut -d "#" -f 2)"
    c=$(( $c + 2 ))
  done
  echo
  read -p "==> " chosen_line
  clear
  echo
  echo "==> Specify the last video I have to download: [number in the brackets]"
  echo "==> [q to quit] [b to go back]"
  echo
  echo "  ->$(head -n 1 ../../batch-files/$chosen_category/$chosen_lang/$chosen_batch_dir/$chosen_batch_file | cut -d "#" -f 2)"
  echo "  ->$(head -n 3 ../../batch-files/$chosen_category/$chosen_lang/$chosen_batch_dir/$chosen_batch_file | tail -1 | cut -d "#" -f 2)"
  c=5
  while [ $c -lt $(wc -l ../../batch-files/$chosen_category/$chosen_lang/$chosen_batch_dir/$chosen_batch_file | cut -d " " -f 1) ]; do
    echo "  ->$(head -n $c ../../batch-files/$chosen_category/$chosen_lang/$chosen_batch_dir/$chosen_batch_file | tail -1 | cut -d "#" -f 2)"
    c=$(( $c + 2 ))
  done
  echo
  read -p "==> " chosen_end
  if [ "$chosen_line" = "q" ] || [ "$chosen_line" = "e" ] || [ "$chosen_end" = "e" ] || [ "$chosen_end" = "q" ]; then
    echo
    exit
  elif [ "$chosen_line" = "b" ] || [ "$chosen_end" = "b" ]; then
    modality_func
  elif [ $chosen_line -le $(( $(wc -l ../../batch-files/$chosen_category/$chosen_lang/$chosen_batch_dir/$chosen_batch_file | cut -d " " -f 1) / 2 )) ] && [ $chosen_end -le $(( $(wc -l ../../batch-files/$chosen_category/$chosen_lang/$chosen_batch_dir/$chosen_batch_file | cut -d " " -f 1) / 2 )) ] && [ $chosen_end -gt $chosen_line ] && [ $chosen_end -gt 0 ] && [ $chosen_line -gt 0 ]; then
    ext_fetcher
    while [ $chosen_line -le $(( $(wc -l ../../batch-files/$chosen_category/$chosen_lang/$chosen_batch_dir/$chosen_batch_file | cut -d " " -f 1) / 2 )) ] && [ $chosen_line -lt $(( $chosen_end + 1 )) ]; do
      youtube-dl -o ${chosen_batch_file}_${chosen_line}.$ext $(head -n $(( $chosen_line * 2 )) ../../batch-files/$chosen_category/$chosen_lang/$chosen_batch_dir/$chosen_batch_file | tail -1)
      ydl_control_ecode
      chosen_line=$(( $chosen_line + 1 ))
    done
  else
    clear
    echo
    echo "==> Enter a valid number!"
    sleep 2s
    from_mod
  fi
}


# Download last video using youtube-dl
last_down_mod() {
  chosen_line=$(( $(wc -l ../../batch-files/$chosen_category/$chosen_lang/$chosen_batch_dir/$chosen_batch_file | cut -d " " -f 1) / 2 ))
  ext_fetcher
  youtube-dl -o ${chosen_batch_file}_${chosen_line}.$ext $(head -n $(( $chosen_line * 2 )) ../../batch-files/$chosen_category/$chosen_lang/$chosen_batch_dir/$chosen_batch_file | tail -1)
  ydl_control_ecode
}


# Stream last video using mpv
last_stream_mod() {
  chosen_line= $(( $(wc -l ../../batch-files/$chosen_category/$chosen_lang/$chosen_batch_dir/$chosen_batch_file | cut -d " " -f 1) / 2 ))
  mpv $(head -n $(( $chosen_line * 2 )) ../../batch-files/$chosen_category/$chosen_lang/$chosen_batch_dir/$chosen_batch_file | tail -1)
  mpv_control_ecode
}


# Stream a video using mpv
stream_mod() {
  clear
  echo
  echo "==> Choose a video: [number in the brackets]"
  echo "==> [q to quit] [b to go back]"
  echo
  echo "  ->$(head -n 1 ../../batch-files/$chosen_category/$chosen_lang/$chosen_batch_dir/$chosen_batch_file | cut -d "#" -f 2)"
  echo "  ->$(head -n 3 ../../batch-files/$chosen_category/$chosen_lang/$chosen_batch_dir/$chosen_batch_file | tail -1 | cut -d "#" -f 2)"
  c=5
  while [ $c -lt $(wc -l ../../batch-files/$chosen_category/$chosen_lang/$chosen_batch_dir/$chosen_batch_file | cut -d " " -f 1) ]; do
    echo "  ->$(head -n $c ../../batch-files/$chosen_category/$chosen_lang/$chosen_batch_dir/$chosen_batch_file | tail -1 | cut -d "#" -f 2)"
    c=$(( $c + 2 ))
  done
  echo
  read -p "==> " chosen_line
  if [ "$chosen_line" = "q" ] || [ "$chosen_line" = "e" ]; then
    exit
  elif [ "$chosen_line" = "b" ]; then
    modality_func
  elif [ $chosen_line -le $(( $(wc -l ../../batch-files/$chosen_category/$chosen_lang/$chosen_batch_dir/$chosen_batch_file | cut -d " " -f 1) / 2 )) ] && [ $chosen_line -gt 0 ]; then
    mpv $(head -n $(( $chosen_line * 2 )) ../../batch-files/$chosen_category/$chosen_lang/$chosen_batch_dir/$chosen_batch_file | tail -1)
    mpv_control_ecode
  else
    clear
    echo
    echo "==> Enter a valid number!"
    sleep 2s
    stream_mod
  fi
}


# Main function that includes other important functions
batch_file() {
pass=0
while [ $pass -lt 2 ]; do
  clear
  echo
  echo "==> Choose what to download:"
  echo "==> [q to quit] [b to go back] [a to show all]"
  echo
  for i in $(ls); do echo "  ==> $i"; if [ -f ${i}/.masiero ]; then cd $i; for m in $(ls); do echo "    -> $m"; done; cd ..; fi; done
  echo
  read -p "==> " chosen_batch_dir
  if [ "$chosen_batch_dir" = "a" ]; then
    if [ ! -f .megasiero ]; then
      touch .megasiero
      for i in $(ls); do cd $i; touch .masiero; cd ..; done
    elif [ -f .megasiero ]; then
      for i in $(ls); do cd $i; rm -rf .masiero; cd ..; done
      rm -rf .megasiero
    fi
  fi
  if [ -f ${chosen_batch_dir}/.masiero ]; then
    pass=0
  elif [ ! -f ${chosen_batch_dir}/.masiero ]; then
    pass=1
  fi
  for i in $(ls); do cd $i; if [ -f $chosen_batch_dir ]; then pass=2; chosen_batch_file=$chosen_batch_dir; chosen_batch_dir=$i; fi; cd ..; done
  if [ $pass -eq 1 ]; then
    if [ "$chosen_batch_dir" = "q" ] || [ "$chosen_batch_dir" = "e" ]; then
      echo
      exit
    elif [ "$chosen_batch_dir" = "b"  ]; then
      cd ..
      lang
      batch_file
    elif [ "$chosen_batch_dir" = "a" ]; then
      batch_file
    elif [ -d "$chosen_batch_dir" ]; then
      touch ${chosen_batch_dir}/.masiero
    else
        clear
        echo
        echo "==> What you have chosen isn't available!"
        sleep 2s
        batch_file
    fi
  elif [ $pass -eq 2 ]; then
    if [ "$chosen_batch_dir" = "q" ]; then
      echo
      exit
    elif [ "$chosen_batch_dir" = "b" ]; then
      cd ..
      lang
      batch_file
    else
      cd ../../../downloaded
      mkdir -p $chosen_batch_file
      cd $chosen_batch_file
      modality_func
    fi
  elif [ $pass -eq 0 ]; then
    if [ "$chosen_batch_dir" = "q" ]; then
      echo
      exit
    elif [ "$chosen_batch_dir" = "b"  ]; then
      cd ..
      lang
      batch_file
    elif [ -d "$chosen_batch_dir" ]; then
      rm ${chosen_batch_dir}/.masiero
    else
        clear
        echo
        echo "==> What you have chosen isn't available!"
        sleep 2s
        batch_file
    fi
  fi
done
}


# Short way to use the script by using some of its options
short_way() {
  if [ -d $chosen_category ]; then
    cd $chosen_category
  else
    echo
    echo "==> Chosen category isn't available, try again"
    echo
    exit 1
  fi
  if [ -d $chosen_lang ]; then
    cd $chosen_lang
  else
    echo
    echo "==> Chosen lang isn't available, try again"
    echo
    exit 1
  fi
  if [ -d $chosen_batch_dir ]; then
    cd $chosen_batch_dir
  else
    echo
    echo "==> Chosen batch dir isn't available, try again"
    echo
    exit 1
  fi
  if [ -f $chosen_batch_file ]; then
    cd ../../../../downloaded
    mkdir -p $chosen_batch_file
    cd $chosen_batch_file
  else
    echo
    echo "==> Chosen batch file isn't available, try again"
    echo
    exit 1
  fi
  if [ "$modality" = "all" ]; then
    all_mod
  elif [ "$modality" = "from" ]; then
    from_mod
  elif [ "$modality" = "from-to" ]; then
    from_to_mod
  elif [ "$modality" = "single" ]; then
    single_mod
  elif [ "$modality" = "stream" ]; then
    stream_mod
  elif [ "$modality" = "last-down" ]; then
    last_down_mod
  elif [ "$modality" = "last-stream" ]; then
    last_stream_mod
  else
    echo
    echo "==> Invalid modality!"
    echo
    exit 1
  fi
}


# Func to view all the tree
view_all() {
  echo
  for i in $(ls); do echo "  ==> $i"; cd $i; for m in $(ls); do echo "    => $m"; cd $m; for g in $(ls); do echo "      -> $g"; cd $g; for f in $(ls); do echo "        > $f"; done; cd ..; done; cd ..; done; cd ..; done
  echo
}


# Func to view all the available modalities
view_modalities() {
  echo
  echo "all         -> download all the videos in the chosen batch file."
  echo "single      -> download a single video from the chosen batch file."
  echo "from        -> download a single video and all its subsequent ones."
  echo "from-to     -> download a single video and all its subsequent ones to the one specified."
  echo "stream      -> stream a video using mpv."
  echo "last-stream -> stream the last episode."
  echo "last-down   -> download the last episode."
  echo
}


[ $# -eq 0 ] && category && lang && batch_file


# Provide options
case $1 in
  -h|--help)
    help
    ;;
  -s|--short)
    chosen_category=$(echo $2 | cut -d '/' -f1)
    chosen_lang=$(echo $2 | cut -d '/' -f2)
    chosen_batch_dir=$(echo $2 | cut -d '/' -f3)
    chosen_batch_file=$(echo $2 | cut -d '/' -f4)
    modality=$(echo $2 | cut -d '/' -f5)
    short_way
    ;;
  -v|--view)
    if [ "$2" = "all" ]; then
      view_all
    elif [ "$2" = "modalities" ]; then
      view_modalities
    else
      echo
      echo "==> Invalid argument!"
      echo
    fi
    ;;
  *)
    help
    exit 1
    ;;
esac
