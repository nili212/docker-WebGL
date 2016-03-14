FROM ubuntu:15.10
MAINTAINER yutaro hotta "hottayuutarou0206@gmail.com"

RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get install -y python-software-properties
RUN apt-get install -y software-properties-common
RUN apt-get install -y texlive
RUN apt-get install -y texlive-lang-cjk xdvik-ja texlive-fonts-recommended
RUN apt-get install -y texlive-humanities

RUN apt-get install -y make
RUN apt-get install -y git
RUN wget -y http://unity3d.com/jp/get-unity/download?thank-you=personal&download_nid=28745&os=Win