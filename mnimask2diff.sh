#!/bin/bash
# This script registers a ROI file (in std space) to the native space (diffusion).
# Requirements: DWI file, std_mask (same DWI file name as a prefix) and you ROI (filename ROI)

data_directory=/Users/arturmarquespaulo/Documents/sample_DTI/

for identifier in $(cat /Users/arturmarquespaulo/Documents/sample_DTI/subjectlist.txt);
        do
        directory=${data_directory}${identifier}
        echo Running ${identifier}...;
        
        
                        for sdtMaskFile in /Users/arturmarquespaulo/Documents/sample_DTI/MaskROIs/*.nii.gz
                        do
                     
                        maskfile=$(basename ${sdtMaskFile})
                        echo Running ${maskfile}...
                        
                        flirt -ref ${directory}/nodif_brain -in ${sdtMaskFile} -applyxfm -init ${directory}.bedpostX/xfms/standard2diff  -out ${directory}.bedpostX/${maskfile}
        
                        echo Applywarp ${maskfile} ok, binarizing mask...
                        
                        fslmaths ${directory}.bedpostX/${maskfile} -thr 0.5 ${directory}.bedpostX/${maskfile}_bin0.5
        
                        done
done
