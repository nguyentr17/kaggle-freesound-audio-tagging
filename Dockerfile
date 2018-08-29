FROM python:3.6

MAINTAINER Trang Nguyen <tnguyen@air.org>

RUN apt-get update && \
        apt-get install -y \
        build-essential \
        cmake \
        git \
        wget \
        unzip \
        vim

ADD . /freesound

WORKDIR /freesound

RUN pip install -r requirements.txt

CMD ["sh", "run_all.sh"]