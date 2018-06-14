# Screenshots

> Some baydl.sh screenshots:

![baydl.sh screenshot 1](https://user-images.githubusercontent.com/31245375/40746951-1807ddee-645c-11e8-8e11-e04cb12d1244.png)
![baydl.sh screenshot 2](https://user-images.githubusercontent.com/31245375/40747315-319f8e86-645d-11e8-80fb-cb02d11949a6.png)

# Demo

Here's a short demo:

[![baydl.sh demo](https://asciinema.org/a/184359.png)](https://asciinema.org/a/184359?autoplay=1)

# Explaination

[youtube-dl] has the capability to download a sequence of video by reading a [batch file] that contains the links to them.
That can be achieved by using the -a or --batch-file option.

# E.g.

Here's an example:

```bash
youtube-dl --batch-file my-hero-academia-3-subita
```

In this example my-hero-academia-3-subita is a text file containing the links to the episodes of this anime that I want to download.

# Installation

This project obviously needs [youtube-dl] and [ffmpeg] to download videos and [mpv] to stream videos.
To download videos from sites like openload, you will need to have [PhantomJS] installed.

==> Termux (can't run mpv so you can only download the videos)
```bash
pkg install python ffmpeg
pip install youtube-dl
```
==> Debian/Ubuntu
```bash
sudo apt install -y youtube-dl ffmpeg mpv
```
==> Arch
```bash
sudo pacman --needed --noconfirm -S youtube-dl ffmpeg mpv
```
==> Other distros
Just search in the official repos of your distro if there are these three programs (most likely there are) or ultimately, compile them from source.

## Installing by cloning the repo

```bash
git clone --depth 1 https://github.com/matteoguarda/youtube-dl-batchfiles
cd youtube-dl-batchfiles
./baydl.sh
```

## Installing using wget or curl

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/matteoguarda/youtube-dl-batchfiles/master/baydl.sh)"

or

sh -c "$(wget -qO- https://raw.githubusercontent.com/matteoguarda/youtube-dl-batchfiles/master/baydl.sh)"
```

The main advantage of using the script I wrote is that you can choose if you want to download all the video specified in the batch file or if you want to download only a single video. Or you can watch a video in streaming by using mpv.

# Supported sites

It's always better to use streamango if available.

* Streamango --> { computer [yes], termux [yes] }

* Rapidvideo --> { computer [yes], termux [yes] }

* VVVVID     --> { computer [yes], termux [yes] }

* Openload   --> { computer [yes] (PhantomJS is required), termux [no] }

* Nitroflare --> { computer [no], termux [no] }

# Contributing

Code of conduct:

  1. Links should not contain the 'www.', e.g. https://vvvvid.it is correct, https://www.vvvvid.it is not!
  2. No blank lines at the end of the document!
  3. Be shure to write a comment before every link explaining what the link is about.
  4. In the comment specify the language of the video, the episode and the season if it is an episode of a series/anime.
  5. If the video is an OVA, specify its title.
  6. Comments should begin with a #
  7. Put the [batch file] in an appropriate folder that indicates it's category.
  8. Openload is always preferred.

Use batch-files/template/name-lang for big batch files.

# Todo

* A baydl.bat to use in windows or an executable.
* Add more batch files, especially in english.

[youtube-dl]: https://github.com/rg3/youtube-dl/
[batch file]: https://en.wikipedia.org/wiki/Batch_file
[ffmpeg]: http://ffmpeg.org/
[mpv]: https://mpv.io/
[PhantomJS]: http://phantomjs.org/
