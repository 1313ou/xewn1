#!/bin/bash

DBTAG="$1"
if [ -z "${DBTAG}" ]; then
	echo "Missing tag"
	exit 1
fi

# C O L O R S

R='\u001b[31m'
G='\u001b[32m'
B='\u001b[34m'
Y='\u001b[33m'
M='\u001b[35m'
C='\u001b[36m'
Z='\u001b[0m'

# D I R S

DATADIR=/opt/data/nlp/wordnet/WordNet-${DBTAG}

# in
INDIR=$DATADIR/git_forked/english-wordnet/wndb
XTRAINDIR=$DATADIR/dict_extras

# out
OUTDIR=$DATADIR/dict

# M A I N

echo -e "${Y}W N D B${Z}"

echo -e "${M}* Cleanup${Z}"
pushd $OUTDIR > /dev/null
rm -f data.*
rm -f index.*
rm -f *.exc
rm -f sents.vrb
rm -f sentidx.vrb
rm -f cntlist
rm -f cntlist.rev
rm -f cousin.exc
rm -f frames.vrb
rm -f lexnames
rm -f verb.Framestext
popd > /dev/null

echo -e "${M}* Copy files${Z}"
cp -p $INDIR/data.* $OUTDIR
cp -p $INDIR/index.* $OUTDIR
cp -p $INDIR/index.sense $OUTDIR
cp -p $INDIR/*.exc $OUTDIR
cp -p $INDIR/sents.vrb $OUTDIR
cp -p $INDIR/sentidx.vrb $OUTDIR
cp -p $INDIR/build $OUTDIR

echo -e "${M}* Add extra support files${Z}"
for f in $XTRAINDIR/* ; do
	echo $f; 
	f2="$(readlink -m $f)"
	pushd $OUTDIR > /dev/null
	cp -pf $f2 .
	popd > /dev/null
done
