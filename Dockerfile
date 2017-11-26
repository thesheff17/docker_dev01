FROM ubuntu:16.04

# install local-gen
RUN apt-get clean && apt-get update && apt-get install -y locales && \
    apt-get autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# helper ENV variables
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV EDITOR vim
ENV SHELL bash

# build date
RUN echo `date` > /root/build_date.txt

RUN \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -yq curl wget python-pip python-dev \
    git python3-pip python3-dev build-essential gcc vim \
    lsb-release mysql-client libpq-dev libjpeg-dev ffmpeg tmux \
    screen php-mcrypt php-mysql php php-cli pypy libffi-dev \
    libssl-dev openssl openjdk-8-jdk libmemcached-dev nodejs npm \
    zlib1g-dev libssl-dev libreadline-dev libyaml-dev \
    sudo liblttng-ust-ctl2 liblttng-ust0 libunwind8 liburcu4 \
    libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev \
    python-software-properties libgdbm-dev libncurses5-dev \
    automake libtool bison libffi-dev gawk libgmp-dev pkg-config \
    gcc make libffi-dev pkg-config libz-dev libbz2-dev tcl-dev \
    libsqlite3-dev libncurses-dev libexpat1-dev libssl-dev pypy mercurial \
    libgc-dev liblzma-dev tcl8.4-dev tk8.4-dev tk-dev net-tools man \
    telnet && \
    apt-get autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# go
RUN wget https://storage.googleapis.com/golang/go1.9.2.linux-amd64.tar.gz && \
  tar -C /usr/local -xzf go1.9.2.linux-amd64.tar.gz && \
  echo 'export PATH=$PATH:/usr/local/go/bin' >> /root/.bashrc && \
  echo 'export GOBIN=/root/go/bin' >> /root/.bashrc && \
  echo 'export GOPATH=/root/go/bin' >> /root/.bashrc

# vim modules
RUN mkdir -p /root/.vim/autoload /root/.vim/bundle /root/.vim/colors/ /root/.vim/ftplugin/
RUN curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
WORKDIR /root/.vim/bundle/
RUN git clone https://github.com/tpope/vim-sensible.git
RUN git clone https://github.com/ctrlpvim/ctrlp.vim.git

# project died
# RUN git clone https://github.com/kien/ctrlp.vim.git
RUN git clone https://github.com/scrooloose/nerdtree
RUN git clone https://github.com/Lokaltog/vim-powerline.git
RUN git clone https://github.com/jistr/vim-nerdtree-tabs.git
RUN git clone https://github.com/python-mode/python-mode.git
# RUN git clone --recursive https://github.com/davidhalter/jedi-vim.git
RUN git clone https://github.com/fatih/vim-go.git
RUN git clone https://github.com/vim-syntastic/syntastic.git

WORKDIR /root/.vim/colors/
RUN wget https://raw.githubusercontent.com/thesheff17/youtube/master/vim/wombat256mod.vim
WORKDIR /root/.vim/ftplugin/
RUN wget https://raw.githubusercontent.com/thesheff17/youtube/master/vim/python_editing.vim
WORKDIR /root/
RUN wget https://raw.githubusercontent.com/thesheff17/youtube/master/vim/vimrc2
RUN mv vimrc2 .vimrc

# go packages
RUN export PATH=$PATH:/usr/local/go/bin && \
    export GOPATH=/root/go/bin && \
    export GOBIN=/root/go/bin && \
    go get github.com/nsf/gocode && \
    go get github.com/alecthomas/gometalinter && \
    go get golang.org/x/tools/cmd/goimports && \
    go get golang.org/x/tools/cmd/guru && \
    go get golang.org/x/tools/cmd/gorename && \
    go get github.com/golang/lint/golint && \
    go get github.com/rogpeppe/godef && \
    go get github.com/kisielk/errcheck && \
    go get github.com/jstemmer/gotags && \
    go get github.com/klauspost/asmfmt/cmd/asmfmt && \
    go get github.com/fatih/motion && \
    go get github.com/zmb3/gogetdoc && \
    go get github.com/josharian/impl

# start a python web server
WORKDIR /
CMD ["python", "-m", "SimpleHTTPServer", "8000"]
