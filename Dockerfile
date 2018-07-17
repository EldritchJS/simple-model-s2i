FROM registry.fedoraproject.org/f27/s2i-base:latest

USER root

ADD . /opt/sms

WORKDIR /opt/sms

ENV PYTHON_VERSION=3.6 \
    PATH=$HOME/.local/bin/:$PATH \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    PIP_NO_CACHE_DIR=off

ENV NAME=python3 \
    VERSION=0 \
    RELEASE=1 \
    ARCH=x86_64


RUN INSTALL_PKGS="python3 python3-devel python3-setuptools python3-pip python3-virtualenv \
            nss_wrapper httpd httpd-devel atlas-devel gcc-gfortran \
            libffi-devel libtool-ltdl enchant" && \
        dnf -y --setopt=tsflags=nodocs install $INSTALL_PKGS && \
        rpm -V $INSTALL_PKGS && \
        dnf -y clean all --enablerepo='*'&& \
        pip install "cloudpickle == 0.1.1" && \
        pip install -r requirements.txt

RUN chmod 755 /opt/sms/app.py

EXPOSE 8080

LABEL io.k8s.description="Example model microservice." \
      io.k8s.display-name="simple-model-server" \
      io.openshift.expose-services="8080:http"

USER 185

CMD ./run.sh
