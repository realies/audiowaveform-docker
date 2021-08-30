FROM alpine:latest as builder
ENV COMMIT 4548d9c
RUN apk add --no-cache boost-dev boost-static cmake curl g++ gcc gd-dev git \
    jq libid3tag-dev libmad-dev libpng-static libsndfile-dev libvorbis-static make zlib-static
RUN apk add --no-cache autoconf automake libtool gettext && \
    curl -fL# $(curl -s "https://api.github.com/repos/xiph/flac/tags" | jq -r '. | first | .tarball_url') -o flac.tar.gz && \
    mkdir flac && \
    tar -xf flac.tar.gz -C flac --strip-components=1 && \
    cd flac && \
    ./autogen.sh && \
    ./configure --enable-shared=no && \
    make -j $(nproc) && \
    make install
RUN git clone -n https://github.com/bbc/audiowaveform.git && \
    cd audiowaveform && \
    git checkout ${COMMIT} && \
    curl -fL# $(curl -s "https://api.github.com/repos/google/googletest/releases/latest" | jq -r .tarball_url) -o googletest.tar.gz && \
    mkdir googletest && \
    tar -xf googletest.tar.gz -C googletest --strip-components=1 && \
    mkdir build && \
    cd build && \
    cmake -D ENABLE_TESTS=1 -D BUILD_STATIC=1 .. && \
    make -j $(nproc) && \
    # /audiowaveform/build/audiowaveform_tests && \
    make install && \
    strip /usr/local/bin/audiowaveform
FROM alpine:latest
RUN apk add --no-cache libstdc++
COPY --from=builder /usr/local/bin/audiowaveform /usr/local/bin/audiowaveform
ENTRYPOINT [ "audiowaveform" ]
CMD [ "--help" ]
