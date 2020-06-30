from alpine:latest
env commit 8a29de7
run apk update && \
 apk add --virtual build-dependencies cmake curl git jq make && \
 apk add boost-dev g++ gcc gd-dev libid3tag-dev libmad-dev libsndfile-dev && \
 git clone -n https://github.com/bbc/audiowaveform.git && \
 cd audiowaveform && \
 git checkout ${commit} && \
 curl -fL# $(curl -s "https://api.github.com/repos/google/googletest/releases/latest" | jq -r .tarball_url) -o googletest.tar.gz && \
 tar -xf googletest.tar.gz && \
 ln -s google*/google* . && \
 mkdir build && \
 cd build && \
 cmake .. && \
 cd ../build && \
 make -j $(nproc) && \
 make install && \
 apk del build-dependencies && \
 rm -rf /var/cache/apk/* && \
 rm -rf /audiowaveform
entrypoint ["audiowaveform"]
cmd ["--help"]
