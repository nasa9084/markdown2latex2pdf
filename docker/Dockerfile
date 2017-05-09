FROM ubuntu:17.04
MAINTAINER nasa9084

#
# USAGE
#
# docker run -v "$PWD":/workdir nasa9084/md2pdf
# document.md must be in $PWD.
#

RUN apt update -y &&\
    apt upgrade -y &&\
    apt install -y texlive-full pandoc
RUN apt install -y python python-pip git &&\
    apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* &&\
    pip install pyyaml
RUN git clone http://gitlab.local.virtualtech.jp/nasa9084/markdown2latex2pdf.git

WORKDIR markdown2latex2pdf
ADD compile.sh .

CMD ["./compile.sh"]
