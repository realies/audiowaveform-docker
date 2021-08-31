# Audio Waveform Image Generator Docker Container

![GitHub Workflow Status](https://shields.api-test.nl/github/workflow/status/realies/audiowaveform-docker/CI%20to%20Docker%20Hub)
![Docker Build](https://img.shields.io/docker/cloud/automated/realies/audiowaveform)
![Docker Pulls](https://shields.api-test.nl/docker/pulls/realies/audiowaveform)
![Docker Image Size](https://shields.api-test.nl/docker/image-size/realies/audiowaveform)

**audiowaveform** is a C++ command-line application that generates waveform data
from either MP3, WAV, FLAC, Ogg Vorbis, or Opus format audio files. Waveform data can
be used to produce a visual rendering of the audio, similar in appearance to
audio editing applications. The code for the application binary can be found [here](https://github.com/bbc/audiowaveform).
Compiled for 386, amd64, arm/v6, arm/v7, arm64, ppc64le, s390x.

![Example Waveform](https://raw.githubusercontent.com/bbc/audiowaveform/master/doc/example.png "Example Waveform")

Waveform data files are saved in either binary format (.dat) or JSON (.json).
Given an input waveform data file, **audiowaveform** can also render the audio
waveform as a PNG image at a given time offset and zoom level.

## Typical Usage

##### Using Docker CLI
```
alias awf='docker run --rm -v `pwd`:/tmp -w /tmp realies/audiowaveform'
awf -i input.wav -o output.png
```
