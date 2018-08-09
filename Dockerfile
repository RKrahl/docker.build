FROM rkrahl/centos:7

ENV RPM_TOPDIR /usr/src/packages

RUN yum -y install \
	rpm-build \
	sudo

RUN mkdir -p \
	$RPM_TOPDIR/BUILD \
	$RPM_TOPDIR/BUILDROOT \
	$RPM_TOPDIR/RPMS/noarch \
	$RPM_TOPDIR/RPMS/x86_64 \
	$RPM_TOPDIR/SOURCES \
	$RPM_TOPDIR/SPECS \
	$RPM_TOPDIR/SRPMS && \
    groupadd abuild && \
    useradd -g abuild -c "Build user" -d $RPM_TOPDIR abuild && \
    chgrp -R abuild $RPM_TOPDIR && \
    chmod -R g+w $RPM_TOPDIR

COPY sudoers /etc/sudoers

USER abuild
WORKDIR $RPM_TOPDIR

CMD ["bash"]

VOLUME ["$RPM_TOPDIR"]
