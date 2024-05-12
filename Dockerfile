FROM rkrahl/opensuse:15.6

RUN zypper --non-interactive refresh

RUN zypper --non-interactive removelock python3-base

RUN zypper --non-interactive install \
	build \
	python-rpm-macros \
	python3-base \
	rpm-build \
	sudo

COPY macros.python /etc/rpm/macros.python

ENV RPM_TOPDIR /usr/src/packages

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
