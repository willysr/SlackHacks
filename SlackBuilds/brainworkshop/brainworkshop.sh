#!/bin/sh

BRW_CONFIGFILE=$HOME/.brainworkshop.ini
BRW_STATFILE=$HOME/.brainworkshop.stats
BRW_DATADIR=$HOME/brainworkshop

python2.7 /usr/share/brainworkshop/brainworkshop.pyw --configfile $BRW_CONFIGFILE --statsfile $BRW_STATFILE --datadir $BRW_DATADIR
