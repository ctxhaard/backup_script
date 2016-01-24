#!/bin/sh

BASEDIR=/media/$(whoami)

LOG=${BASEDIR}/BACKUP/last.log
ARCHIVEDIR=${BASEDIR}/BACKUP
ARCHIVE=backup-carlo.tar

#DIRECTORIES="PERSONALI/ DOCS/"
DIRECTORIES="PERSONALI ACCOUNTS"

#LOG=/tmp/backup/last.log
#ARCHIVEDIR=/tmp/backup
#ARCHIVE=backup-carlo.tar
#BASEDIR=/tmp
#DIRECTORIES="adir/ adir2/"

PREVDIR=`pwd`
cd $BASEDIR

# se cambio d'anno archivio in formato compresso il file dell'anno precedente
if [  `date +%Y` != `cat $LOG` ]; then
	echo "archiving last year compressed backup file"
	PREVARCHIVE=$ARCHIVEDIR/`cat $LOG`-$ARCHIVE
	mv $ARCHIVEDIR/$ARCHIVE $PREVARCHIVE
	gzip $PREVARCHIVE
	rm $PREVARCHIVE
fi

if [ -f /$ARCHIVEDIR/$ARCHIVE ]; then
	echo "performing partial backup"
	find $DIRECTORIES -newer $ARCHIVEDIR/$ARCHIVE -print0 | xargs -0 tar uvf $ARCHIVEDIR/$ARCHIVE --exclude '.*'
else
	echo "performing full backup"
	tar cvp -f $ARCHIVEDIR/$ARCHIVE --exclude '.*' $DIRECTORIES
	date +%Y > $LOG
fi

cd $PREVDIR
