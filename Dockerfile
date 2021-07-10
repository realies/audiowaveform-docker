from alpine:latest
env tag 1.5.0
run apk update && \
 apk add --virtual build-dependencies cmake curl git jq make && \
 apk add boost-dev g++ gcc gd-dev libid3tag-dev libmad-dev libsndfile-dev && \
 git clone -n https://github.com/bbc/audiowaveform.git && \
 cd audiowaveform && \
 git checkout ${tag} && \
 curl -fL# $(curl -s "https://api.github.com/repos/google/googletest/releases/latest" | jq -r .tarball_url) -o googletest.tar.gz && \
 mkdir googletest && \
 tar -xf googletest.tar.gz -C googletest --strip-components=1 && \
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
