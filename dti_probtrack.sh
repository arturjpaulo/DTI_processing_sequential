#!/usr/bin/env bash

# Registration
echo 'Registering diffusion to standard space'


cat subjectList| while read i
do
cd ${i}
    echo Running ${i}...;


  fslroi ${i}.bedpostx/data nodif_brain 1 0;

	flirt -in /${i}.bedpostx/nodif_brain -ref /usr/local/fsl/data/standard/FMRIB58_FA_1mm.nii.gz -omat /${i}/diff2standard.mat -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12


	echo Flirt ok!;
	fnirt --in=/${i}/nodif_brain --aff=/${i}/diff2standard.mat --ref=/usr/local/fsl/data/standard/FMRIB58_FA_1mm.nii.gz --cout=${i}/diff2standard_warp
	echo FNIRT ok!;

	convert_xfm -omat /${i}/standard2diff.mat -inverse ${i}/diff2standard.mat
	echo diff2standard ok!;

	invwarp -w /${i}/diff2standard_warp -o /${i}/xfms/standard2diff_warp -r /usr/local/fsl/data/standard/FMRIB58_FA_1mm.nii.gz

	echo diff2standard_warp ok!;

  xtract -bpx ${i}.bedpostx -out ${i}/extract -species HUMAN
  
  echo extract ok!;

 done
