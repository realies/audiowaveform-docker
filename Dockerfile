FROM alpine:edge as builder
ENV COMMIT 9b73bd1
RUN apk add --no-cache autoconf automake g++ gcc libtool make nasm ncurses-dev && \
	wget https://downloads.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz && \
	tar -xf lame-3.100.tar.gz && \
	cd lame-3.100 && \
	# fix for parallel builds
	mkdir -p libmp3lame/i386/.libs && \
	# fix for pic build with new nasm
	sed -i -e '/define sp/s/+/ + /g' libmp3lame/i386/nasm.h && \
	aclocal && automake --force --add-missing && \
	./configure \
		--build=$CBUILD \
		--host=$CHOST \
		--prefix=/usr \
		--enable-nasm \
		--disable-mp3x \
		--disable-shared \
		--with-pic && \
	make -j $(nproc) && \
	make test && \
	make install
RUN apk add --no-cache autoconf automake g++ gcc libtool gettext git make && \
	git clone https://github.com/xiph/opus && \
	cd opus && \
	./autogen.sh && \
	./configure \
		--prefix=/usr \
		--sysconfdir=/etc \
		--localstatedir=/var \
		--enable-custom-modes && \
	make -j $(nproc) && \
	make check && \
	make install
RUN apk add --no-cache cmake g++ gcc git samurai && \
	git clone https://github.com/xiph/ogg && \
	cd ogg && \
	cmake -B build -G Ninja \
		-DCMAKE_INSTALL_PREFIX=/usr \
		-DCMAKE_INSTALL_LIBDIR=lib \
		-DBUILD_SHARED_LIBS=False \
		-DCMAKE_BUILD_TYPE=Release \
		$CMAKE_CROSSOPTS && \
	cmake --build build -j $(nproc) && \
	cmake --build build --target test -j $(nproc) && \
	cmake --install build
RUN apk add --no-cache autoconf automake libtool g++ gcc gettext git !libiconv make pkgconfig && \
	git clone https://github.com/xiph/flac && \
	cd flac && \
	./autogen.sh && \
	./configure \
		--prefix=/usr \
		--enable-shared=no \
		--enable-ogg \
		--disable-rpath \
		--with-pic && \
	make -j $(nproc) && \
	make check || true && \
	make install
RUN apk add --no-cache alsa-lib-dev cmake git flac-dev libvorbis-dev linux-headers python3 samurai && \
	git clone https://github.com/libsndfile/libsndfile && \
	cd libsndfile && \
	cmake -B build -G Ninja \
		-DBUILD_SHARED_LIBS=OFF \
		-DCMAKE_BUILD_TYPE=MinSizeRel \
		-DCMAKE_INSTALL_PREFIX=/usr \
		-DENABLE_MPEG=ON && \
	cmake --build build -j $(nproc) && \
	cd build && \
	CTEST_OUTPUT_ON_FAILURE=TRUE ctest -E write_read_test_sd2 && \
	cd .. && \
	cmake --install build
RUN apk add --no-cache cmake g++ gcc git samurai zlib-dev && \
	git clone https://github.com/tenacityteam/libid3tag && \
	cd libid3tag && \
	cmake -B build -G Ninja \
		-DBUILD_SHARED_LIBS=OFF \
		-DCMAKE_BUILD_TYPE=MinSizeRel \
		-DENABLE_TESTS=YES \
		-DCMAKE_INSTALL_PREFIX=/usr \
		-DCMAKE_INSTALL_LIBDIR=lib && \
	cmake --build build -j $(nproc) && \
	cd build && \
	CTEST_OUTPUT_ON_FAILURE=TRUE ctest && \
	cd .. && \
	cmake --install build
RUN apk add --no-cache boost-dev boost-static cmake g++ gcc gd-dev git libgd libmad-dev libpng-dev libpng-static libvorbis-static make zlib-dev zlib-static && \
	git clone -n https://github.com/bbc/audiowaveform.git && \
	cd audiowaveform && \
	git checkout ${COMMIT} && \
	git clone https://github.com/google/googletest && \
	mkdir build && \
	cd build && \
	cmake -D ENABLE_TESTS=1 -D BUILD_STATIC=1 .. && \
	make -j $(nproc) && \
	/audiowaveform/build/audiowaveform_tests || true && \
	make install && \
	strip /usr/local/bin/audiowaveform
FROM alpine:edge
RUN apk add --no-cache libstdc++
COPY --from=builder /usr/local/bin/audiowaveform /usr/local/bin/audiowaveform
ENTRYPOINT [ "audiowaveform" ]
CMD [ "--help" ]
