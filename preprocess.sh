#!/bin/bash

#. /usr/share/fsl/5.0/etc/fslconf/fsl.sh

BASEDIR=/mnt/data/WakeUpNemo_demo/

for VISIT in V0 V3; do

	LESIONDIR=$BASEDIR/$VISIT
	cd $LESIONDIR
	DIR=$LESIONDIR/86

	mkdir -p $DIR
	cp -r ./original_masks/* $DIR

	for f in $(ls -d $DIR/*); do
		gunzip $f
 		g=$(basename $f)
 		g=${g%.*} # *.nii
 		g=${g%.*}
 		mkdir $DIR/$g
 		mv $DIR/${g}.nii $DIR/$g/

 		fslroi "$DIR/${g}/${g}.nii" "$DIR/${g}/${g}_cropped.nii" 6 181 6 217 2 181
 		gunzip "$DIR/${g}/${g}_cropped.nii"
	done

	cp -r $DIR $LESIONDIR/116

done

exit
