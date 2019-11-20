TOP=../../..
RUNIT_DIR=`pwd`
INST_PATH=`dirname ${RUNIT_DIR}`
PKG_PATH=`dirname ${INST_PATH}`

RCMD=${RCMD:-'R'}

all: install test

install:
	cd ${TOP}; \
	${RCMD} CMD INSTALL --clean ${PKG_PATH} && \
	cd ${RUNIT_DIR}

test:
	${RCMD} --slave < runalltests.R

%.R: FORCE
	./runfile.sh $@

FORCE:
