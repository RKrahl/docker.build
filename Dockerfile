FROM rkrahl/opensuse:42.1

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

# Enable install locally build RPMs from zypper.
RUN zypper --non-interactive addrepo /usr/src/packages/RPMS/ local && \
    zypper --non-interactive modifyrepo \
	   --refresh --priority 150 --no-gpgcheck local

USER abuild
WORKDIR $RPM_TOPDIR

CMD ["bash"]

VOLUME ["$RPM_TOPDIR"]
