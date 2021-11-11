#!/bin/bash

#Defining paths for acqparams & index.txt

# Path for GPU
acqparams='/home/adm_comp_neuro/EM_YOGA/DTI/acqparams.txt';
index='/home/adm_comp_neuro/DTI/index.txt';


# Running in local computer
acqparams='/Volumes/shares/INCE/Project_EM_YOGA/DTI/acqparams.txt';
index='/Volumes/shares/INCE/Project_EM_YOGA/DTI/index.txt';

cat subjectList| while read i
do
cd ${i}
    echo Running ${i}...;

    #Defining filenames

data=$(find . -name "*DTI_68dir*.nii.gz");
TOP_UP=$(find . -name "*TOP_UP_DTI_*.nii.gz");


# removing extndion nii.gz
data=${data%.nii.gz};
TOP_UP=${TOP_UP%.nii.gz};

echo ${data}

fslroi ${data} b0_AP 0 1;

echo Merging AP and PA files
fslmerge -t AP_PA_b0 b0_AP ${TOP_UP};
echo Running topup
topup --imain=AP_PA_b0 --datain=${acqparams} --config=b02b0_1.cnf --out=top_up_AP_PA_b0 --fout=myfield --iout=my_unwarped_images;


fslmaths my_unwarped_images -Tmean my_unwarped_images;
bet my_unwarped_images my_unwarped_images_brain -R -f 0.45 -g 0 -o -m;

echo Running EDDY
eddy --imain=${data} --mask=my_unwarped_images_brain_mask --acqp=${acqparams} --index=${index} --bvecs=${data}.bvec --bvals=${data}.bval --topup=top_up_AP_PA_b0 --estimate_move_by_susceptibility --out=eddy_unwarped_images;
cp eddy_unwarped_images.nii.gz data
cp ${data}.bval bvals
cp ${data}.bvec bvecs

echo Running dtifit
dtifit --data=eddy_unwarped_images --out=dti --mask=eddy_unwarped_images_brain_mask --bvecs=${data}.bvec --bvals=${data}.bval --wls --sse --save_tensor;


fslmaths dti_L2 -add dti_L3 -div 2 dti_RD;


  cd ..

 done
