# $OpenBSD: Makefile,v 1.15 2015/04/27 13:52:17 nicm Exp $

PROG=   file
SRCS=   file.c magic-dump.c magic-load.c magic-test.c magic-common.c sandbox.c \
	text.c xmalloc.c compat/reallocarray.c compat/vis.c compat/fgetln.c \
	compat/strlcpy.c compat/strlcat.c compat/imsg-buffer.c compat/imsg.c
OBJS=	$(patsubst %.c,%.o,$(SRCS))
MAN=	file.1 magic.5

#LDADD=	-lutil
#DPADD=	${LIBUTIL}

CFLAGS= -O2 -D_BSD_SOURCE -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -I. -Icompat
CDIAGFLAGS+= -Wno-long-long -Wall -W -Wnested-externs -Wformat=2
CDIAGFLAGS+= -Wmissing-prototypes -Wstrict-prototypes -Wmissing-declarations
CDIAGFLAGS+= -Wwrite-strings -Wshadow -Wpointer-arith -Wsign-compare
CDIAGFLAGS+= -Wundef -Wbad-function-cast -Winline -Wcast-align

MAGIC=		/etc/magic
MAGICOWN=	root
MAGICGRP=	bin
MAGICMODE=	444

#CLEANFILES+=	magic post-magic

MAG1=		$(.CURDIR)/magdir/Header \
		$(.CURDIR)/magdir/Localstuff \
		$(.CURDIR)/magdir/OpenBSD
MAGFILES=	$(.CURDIR)/magdir/[0-9a-z]*

#post-magic: $(MAGFILES)
#	for i in ${.ALLSRC:N*.orig}; do \
#		echo $$i; \
#	done|sort|xargs -n 1024 cat >$(.TARGET)

#magic: $(MAG1) post-magic
#	cat ${MAG1} post-magic >$(.TARGET)

#afterinstall:
#	${INSTALL} ${INSTALL_COPY} -o $(MAGICOWN) -g $(MAGICGRP) \
#		-m $(MAGICMODE) magic $(DESTDIR)$(MAGIC)

all: $(PROG)

$(PROG): $(OBJS)
	$(CC) $(OBJS) -o $(PROG) $(LDFLAGS)

clean:
	rm -f $(OBJS) $(PROG)

#syscall-linux.txt:
#	echo "#include <sys/syscall.h>" | cpp -dM | grep '^#define __NR_' | \
#	LC_ALL=C sed -r -n -e 's/^\#define[ \t]+__NR_([a-z0-9_]+)[ \t]+([0-9]+)(.*)/ [\2] = "\1",/p' >> $@ ;\
