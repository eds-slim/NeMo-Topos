#!/bin/bash

#. /usr/share/fsl/5.0/etc/fslconf/fsl.sh

BASEDIR=/mnt/data/ToposNemo



	
	cd $BASEDIR
	DIR=$BASEDIR/86

	mkdir -p $DIR
	cp -r ./lesionmasks/* $DIR

	for f in $(ls -d $DIR/*); do
		# gunzip $f
 		g=$(basename $f)
 		g=${g%.*} # *.nii
 		g=${g%.*}
 		mkdir $DIR/$g
 		mv $DIR/${g}.nii $DIR/$g/

 		fslroi "$DIR/${g}/${g}.nii" "$DIR/${g}/${g}_cropped.nii" 0 181 0 217 0 181
 		gunzip "$DIR/${g}/${g}_cropped.nii"
	done

	cp -r $DIR $BASEDIR/116


exit
