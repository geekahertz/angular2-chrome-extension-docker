FROM node:latest
MAINTAINER dman1680

LABEL "version"="0.0.1"

# uncomment to allow self-sign certs if you are behind a coporate CA (open to MitM)
RUN echo "" | openssl s_client -host registry.npmjs.org -port 443 -showcerts | awk '/BEGIN CERT/ {p=1} ; p==1; /END CERT/ {p=0}' > /usr/local/share/ca-certificates/npmjs.org.crt
RUN update-ca-certificates
RUN npm config set cafile "/etc/ssl/certs/npmjs.org.pem"
RUN git config --global http.sslVerify false

# Install samba
RUN export DEBIAN_FRONTEND='noninteractive' && \
    apt-get update -qq && \
    apt-get install -qqy --no-install-recommends procps samba \
                $(apt-get -s dist-upgrade|awk '/^Inst.*ecurity/ {print $2}') &&\
    useradd -c 'Samba User' -d /tmp -M -r smbuser && \
    sed -i 's|^\(   log file = \).*|\1/dev/stdout|' /etc/samba/smb.conf && \
    sed -i 's|^\(   unix password sync = \).*|\1no|' /etc/samba/smb.conf && \
    sed -i '/Share Definitions/,$d' /etc/samba/smb.conf && \
    echo '   security = user' >>/etc/samba/smb.conf && \
    echo '   create mask = 0664' >>/etc/samba/smb.conf && \
    echo '   force create mode = 0664' >>/etc/samba/smb.conf && \
    echo '   security mask = 0664' >>/etc/samba/smb.conf && \
    echo '   force security mode = 0664' >>/etc/samba/smb.conf && \
    echo '   directory mask = 0775' >>/etc/samba/smb.conf && \
    echo '   force directory mode = 0775' >>/etc/samba/smb.conf && \
    echo '   directory security mask = 0775' >>/etc/samba/smb.conf && \
    echo '   force directory security mode = 0775' >>/etc/samba/smb.conf && \
    echo '   force user = smbuser' >>/etc/samba/smb.conf && \
    echo '   force group = users' >>/etc/samba/smb.conf && \
    echo '   load printers = no' >>/etc/samba/smb.conf && \
    echo '   printing = bsd' >>/etc/samba/smb.conf && \
    echo '   printcap name = /dev/null' >>/etc/samba/smb.conf && \
    echo '   disable spoolss = yes' >>/etc/samba/smb.conf && \
    echo '   socket options = TCP_NODELAY' >>/etc/samba/smb.conf && \
    echo '' >>/etc/samba/smb.conf && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/*
COPY samba.sh /usr/bin/

VOLUME ["/etc/samba"]

# node setup
RUN npm install -g node-gyp
ENV NODE_PATH=/usr/local/lib/node_modules/:/usr/local/lib NODE_ENV=development

# sitepoint-editors/sitepoint_projectcode_chrome-extension-angular-typescript setup
RUN mkdir -p /usr/src
WORKDIR /usr/src
RUN git clone https://github.com/sitepoint-editors/sitepoint_projectcode_chrome-extension-angular-typescript.git ng2ce
WORKDIR /usr/src/ng2cd
RUN npm install
RUN chmod -R 776 *

EXPOSE 137/udp 138/udp 139 445 8000 3001

# launch app 
CMD ["npm","run start" ]


