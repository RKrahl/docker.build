FROM rkrahl/opensuse:42.2

ENV RPM_TOPDIR /usr/src/packages

RUN zypper --non-interactive install \
	build \
	rpm-build \
	sudo

RUN groupadd abuild && \
    useradd -g abuild -c "Build user" -d $RPM_TOPDIR abuild && \
    chgrp -R abuild $RPM_TOPDIR && \
    chmod -R g+w $RPM_TOPDIR

COPY sudoers /etc/sudoers

USER abuild
WORKDIR $RPM_TOPDIR

CMD ["bash"]

VOLUME ["$RPM_TOPDIR"]
