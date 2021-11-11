
This code extract tensors (FA,AD,RD,MD) from Diffusion MRI data from multiple subjects using bash language and FSL libraries. It includes Eddycurrent correction and topup
For processing, data from each subject must be in a separeta folder containing DTI data (DTI_68dir), top up (TOP_UP_DTI), bvals, bvecs.
You should create a vector in a txt editor containing all subjects ID (with no extension) and you need to set the path of acqparams and index file.
For more information on how to find acqparams and index file, acess:
http://ftp.nmr.mgh.harvard.edu/pub/dist/freesurfer/tutorial_packages/centos6/fsl_507/doc/wiki/eddy(2f)Faq.html#How_do_I_know_what_to_put_into_my_--acqp_file



Created by AJM Paulo