# Dockerfile to build PyYashe

FROM alpine:edge

RUN ["apk", "add", "--no-cache", "musl-dev", "g++", "make", "python3", "python3-dev", "swig"]
# Even after specifying "gmp", we see this warning:
# Your GMP library is incompatible with the compiler settings.
# Building without GNU MP support

# https://pari.math.u-bordeaux.fr/download.html
RUN wget https://pari.math.u-bordeaux.fr/pub/pari/unix/pari-2.9.3.tar.gz \
    && tar -xzf pari-2.9.3.tar.gz \
    && cd pari-2.9.3 \
    && ./Configure \
    && make install

RUN ["mkdir", "/PyYashe"]
COPY . /PyYashe
WORKDIR /PyYashe

RUN swig -c++ -python -py3 example.i

RUN python3 setup.py install
