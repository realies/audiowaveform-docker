# Audio Waveform Image Generator Docker Container

[![GitHub Last Commit](https://img.shields.io/github/last-commit/realies/audiowaveform-docker?style=flat-square&logo=git&label=last%20commit)](https://github.com/realies/audiowaveform-docker/commits/master)
[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/realies/audiowaveform-docker/build.yml?style=flat-square&logo=github&label=build)](https://github.com/realies/audiowaveform-docker/actions)
[![Docker Pulls](https://img.shields.io/docker/pulls/realies/audiowaveform?style=flat-square&logo=docker&label=pulls)](https://hub.docker.com/r/realies/audiowaveform)
[![Docker Image Size](https://img.shields.io/docker/image-size/realies/audiowaveform?style=flat-square&logo=docker&label=size)](https://hub.docker.com/r/realies/audiowaveform)

**audiowaveform** is a C++ command-line application that generates waveform data
from either MP3, WAV, FLAC, Ogg Vorbis, or Opus format audio files. Waveform data can
be used to produce a visual rendering of the audio, similar in appearance to
audio editing applications. The code for the application binary can be found [here](https://codeberg.org/chrisn/audiowaveform).
Compiled for 386, amd64, arm/v6, arm/v7, arm64, ppc64le, s390x.

![Example Waveform](https://codeberg.org/chrisn/audiowaveform/raw/branch/master/doc/example.png "Example Waveform")

Waveform data files are saved in either binary format (.dat) or JSON (.json).
Given an input waveform data file, **audiowaveform** can also render the audio
waveform as a PNG image at a given time offset and zoom level.

## Typical Usage

##### Using Docker CLI
```
alias awf='docker run --rm -v `pwd`:/tmp -w /tmp realies/audiowaveform'
awf -i input.wav -o output.png
```
