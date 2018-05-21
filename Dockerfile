FROM centos:6

ENV DISTR_DIR /distr
WORKDIR $DISTR_DIR

COPY OCPlatform11_2.rsp $DISTR_DIR/


RUN echo Update the image with the latest packages && \
	yum update -y -q && \
	echo Install unzip and wget packages && \
	yum install -y -q unzip wget && \
	yum clean -q all && \
	echo Download Oracle JDK 8u172 and ATG Commerce 11.2 with patch 11.2.0.2 with fixpack 1 && \
    wget -q https://getfile.dokpub.com/yandex/get/https://yadi.sk/d/Cv6f-NRV3WHiGS -O jdk-8u172-linux-x64.rpm && \
    wget -q https://getfile.dokpub.com/yandex/get/https://yadi.sk/d/d-InUBZT3VaDu2 -O V78217-01.zip && \
    wget -q https://getfile.dokpub.com/yandex/get/https://yadi.sk/d/BfHLB0Y63VZVJa -O p24950065_112000_Generic.zip && \
    wget -q https://getfile.dokpub.com/yandex/get/https://yadi.sk/d/8_tVHQSw3VaE9R -O p25404313_112020_Generic.zip && \
	echo Install Oracle JDK 8u172, Install ATG Platform with patch 11.2.0.2 with fixpack 1 && \
    rpm -i jdk-8u172-linux-x64.rpm && \
    unzip -q V78217-01.zip && \
    chmod +x OCPlatform11_2.bin && ./OCPlatform11_2.bin -f ./OCPlatform11_2.rsp -i silent && \
    cd /atg/patch/ && unzip -q /distr/p24950065_112000_Generic.zip && cd OCPlatform11.2_p2/ && chmod +x bin/*.sh && echo Y | bin/install.sh && cd .. && rm -rf OCPlatform11.2_p2 && \
    cd /atg/patch/ && unzip -q /distr/p25404313_112020_Generic.zip && cd OCPlatform11.2_p2.1/ && chmod +x bin/*.sh && echo Y | bin/install.sh && cd .. && rm -rf OCPlatform11.2_p2.1 && \
    rm -f $DISTR_DIR/* && \
	echo export DYNAMO_ROOT=/atg >> /etc/profile && \
	echo export JAVA_HOME=/usr/java/latest >> /etc/profile && \
	echo export PATH=\$PATH:\$JAVA_HOME/bin >> /etc/profile

RUN echo Install NodeJS Git && \
	curl --silent --location https://rpm.nodesource.com/setup_8.x | bash - && \
    yum install -y -q http://opensource.wandisco.com/centos/6/git/x86_64/wandisco-git-release-6-1.noarch.rpm && \
    yum install -y -q nodejs git && \
    yum clean all && \
    echo NodeJS version $(node -v) && \
    echo Git version $(git --version) && \
    npm i npm@latest -g && \
    echo npm version $(npm -v) && \
	source /etc/profile

CMD ["/bin/bash"]