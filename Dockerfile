FROM jjanzic/docker-python3-opencv

ENV DLIB_VERSION="19.13"
RUN wget http://dlib.net/files/dlib-${DLIB_VERSION}.tar.bz2
RUN tar xvf dlib-${DLIB_VERSION}.tar.bz2
RUN apt-get update
RUN apt-get -y install libopenblas-dev liblapack-dev 
RUN mkdir /dlib-${DLIB_VERSION}/build
WORKDIR /dlib-${DLIB_VERSION}/build 
RUN cmake .. && cmake --build . --config Release
RUN make install && ldconfig

WORKDIR /dlib-${DLIB_VERSION}
RUN pkg-config --libs --cflags dlib-1
RUN python setup.py install
RUN pip install dlib
RUN rm -rf /dlib-${DLIB_VERSION}.tar.bz2
RUN rm -rf /dlib-${DLIB_VERSION}

# clean up all temporary files 
RUN apt-get clean &&\
    apt-get autoclean -y &&\
    apt-get autoremove -y &&\
    apt-get clean &&\
    rm -rf /tmp/* /var/tmp/* &&\
    rm -rf /var/lib/apt/lists/* &&\    
    rm -f /etc/ssh/ssh_host_*
