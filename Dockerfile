FROM debian:stable

RUN mkdir /blender
WORKDIR /blender

#Install tools
RUN apt-get -qqy update && apt-get -qqy install  --no-install-recommends \
  curl ca-certificates \
  && rm -rf /var/lib/apt/lists/* /var/tmp/*


#Install build tools
#git, git-lfs and subversion are required by "make update"
RUN apt-get -qqy update && apt-get -qqy install  --no-install-recommends \
  build-essential \
  python3 \
  cmake \
  git git-lfs subversion \
  && rm -rf /var/lib/apt/lists/* /var/tmp/*

#Install dependencies  (FIXME: libx11 and libwayland are possibly not needed for headless build)
RUN apt-get -qqy update && apt-get -qqy install  --no-install-recommends \
  libx11-dev libxxf86vm-dev libxcursor-dev libxi-dev libxrandr-dev libxinerama-dev \
  libwayland-dev wayland-protocols libxkbcommon-dev libdbus-1-dev linux-libc-dev \
  libegl-dev \
  && rm -rf /var/lib/apt/lists/* /var/tmp/*

RUN cd / && git clone --depth 1 --branch v5.0.1 https://projects.blender.org/blender/blender.git /blender
#RUN curl -fsSL -o "/tmp/blender.tar.gz" "https://projects.blender.org/blender/blender/archive/v5.0.1.tar.gz" \
#  && tar -xf "/tmp/blender.tar.gz" -C "/blender" --strip-components=1 
#Install precompiled libraries
RUN make update
# make update will: 
#  - checkout https://projects.blender.org/blender/lib-linux_x64.git#blender-v5.0-release to lib/linux_x64

RUN make headless
