FROM ubuntu:14.04

ARG PACKAGE
ARG VIDEO_GID

RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get install -y python-software-properties
RUN apt-get install -y software-properties-common
RUN apt-get install -y texlive
RUN apt-get install -y texlive-lang-cjk xdvik-ja texlive-fonts-recommended
RUN apt-get install -y texlive-humanities

RUN apt-get install -y make
RUN apt-get install -y git

WORKDIR unity3d
ADD ${PACKAGE} ${PACKAGE}

#Resolve missing dependencies
RUN dpkg -i ${PACKAGE} || apt-get -f install -y

#Install unity3d
RUN dpkg -i ${PACKAGE}

# Add the gamedev user
RUN useradd -ms /bin/bash gamedev && \
    chmod 0660 /etc/sudoers && \
    echo "gamedev ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    chmod 0440 /etc/sudoers && \
    usermod -aG video gamedev && \
    groupadd -g ${VIDEO_GID} unity3ddockervideo && \
    usermod -aG unity3ddockervideo gamedev

# this is a requirement by chrome-sandbox
RUN chown root /opt/Unity/Editor/chrome-sandbox
RUN chmod 4755 /opt/Unity/Editor/chrome-sandbox

RUN apt-get clean
RUN rm ${PACKAGE}

ADD  https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb /src/google-chrome-stable_current_amd64.deb

# Install Chromium
RUN mkdir -p /usr/share/icons/hicolor && \
	apt-get update && apt-get install -y \
	ca-certificates \
  fonts-liberation \
	gconf-service \
	hicolor-icon-theme \
	libappindicator1 \
	libasound2 \
	libcanberra-gtk-module \
	libcurl3 \
  libdrm-intel1 libdrm-nouveau2 libdrm-radeon1 \
	libexif-dev \
	libgconf-2-4 \
	libgl1-mesa-dri \
	libgl1-mesa-glx \
	libnspr4 \
	libnss3 \
	libpango1.0-0 \
	libv4l-0 \
  libxcb1 \
  libxcb-render0 \
  libxcb-shm0 \
	libxss1 \
	libxtst6 \
  mono-complete \
  monodevelop \
	wget \
	xdg-utils \
	--no-install-recommends && \
	dpkg -i '/src/google-chrome-stable_current_amd64.deb' && \
	rm -rf /var/lib/apt/lists/*

USER gamedev
WORKDIR /home/gamedev
ENV DISPLAY=:0
ENTRYPOINT ["sudo", "/opt/Unity/Editor/Unity"]
