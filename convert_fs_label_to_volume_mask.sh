#!/bin/bash

#######
#This is a Template script. DOn't use the commands blindly without changing the parameters 
#because they might affect Giusi's Analysis
#######

### change to the corresponding subject folder
source /usr/local/apps/psycapps/config/freesurfer_bash_update /MRIWork/MRIWork10/pv/giusi_pollicina/Sounds_analysis/freesurfer

### use fsl
source /usr/local/apps/psycapps/config/fsl_bash

### input argument
subject_list=$1

for subject in "${subject_list[@]}"; do

    ### Convert Freeesurfer Brain to volumetric brain (.mgz to .nii.gz)
    ### The nifti output of the previous step results in a volume image of 256x256x256. If you want to change the size use -- cropsize flag
    mri_convert --out_orientation RAS Sounds_analysis/freesurfer/$subject/mri/brain.mgz Sounds_analysis/$subject/freesurfer_brain.nii.gz


    ### if you want to merge multiple labels use the following command
    # mri_mergelabels -i label1.label -i label2.label -o generated_label.label

    ### Convert Label to volume 

    mri_label2vol --label Sounds_analysis/freesurfer/$subject/label/lh.V1_exvivo.thresh.label \
                  --identity \
                  --temp Sounds_analysis/freesurfer/$subject/mri/brain.mgz \
	          --fillthresh 0.0  \
	          --proj frac 0 1 .1 \
	          --subject $subject --hemi lh \
	          --o Sounds_analysis/$subject/masks/lh_V1.nii.gz
	      
	      
    ### Fix the orientation of the mask
    mri_convert --out_orientation RAS Sounds_analysis/$subject/masks/lh_V1.nii.gz Sounds_analysis/$subject/masks/lh_V1.nii.gz

    ### Create mean of your functional scans using fslmaths
    fslmaths /MRIWork/MRIWork10/pv/giusi_pollicina/Sounds_BIDS/$subject/ses-mri/func/$subject_ses-mri_task-sound_run-01_bold.nii.gz -Tmean /MRIWork/MRIWork10/pv/giusi_pollicina/Sounds_analysis/$subject/$subject_ses-mri_task-sound_run-01_meants.nii.gz

    fslmaths /MRIWork/MRIWork10/pv/giusi_pollicina/Sounds_BIDS/$subject/ses-mri/func/$subject_ses-mri_task-sound_run-02_bold.nii.gz -Tmean /MRIWork/MRIWork10/pv/giusi_pollicina/Sounds_analysis/$subject/$subject_ses-mri_task-sound_run-02_meants.nii.gz
  
    fslmaths /MRIWork/MRIWork10/pv/giusi_pollicina/Sounds_BIDS/$subject/ses-mri/func/$subject_ses-mri_task-sound_run-03_bold.nii.gz -Tmean /MRIWork/MRIWork10/pv/giusi_pollicina/Sounds_analysis/$subject/$subject_ses-mri_task-sound_run-03_meants.nii.gz
    
    fslmaths /MRIWork/MRIWork10/pv/giusi_pollicina/Sounds_BIDS/$subject/ses-mri/func/$subject_ses-mri_task-sound_run-04_bold.nii.gz -Tmean /MRIWork/MRIWork10/pv/giusi_pollicina/Sounds_analysis/$subject/$subject_ses-mri_task-sound_run-04_meants.nii.gz

    ### Coregister Mean TS with freesurfer brain
    /usr/local/apps/psycapps/fsl/fsl-latest/bin/flirt \
	-in /MRIWork/MRIWork10/pv/giusi_pollicina/Sounds_analysis/$subject/$subject_ses-mri_task-sound_run-01_meants.nii.gz \
	-ref /MRIWork/MRIWork10/pv/giusi_pollicina/Sounds_analysis/$subject/freesurfer_brain.nii.gz \
	-out /MRIWork/MRIWork10/pv/giusi_pollicina/Sounds_analysis/$subject/$subject_ses-mri_task-sound_run-01_bold2fs.nii.gz \
	-omat /MRIWork/MRIWork10/pv/giusi_pollicina/Sounds_analysis/$subject/$subject_ses-mri_task-sound_run-01_bold2fs.mat \
	-bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear
	
    ### Invert the transformation matrix
    /usr/local/apps/psycapps/fsl/fsl-latest/bin/convert_xfm \
	-omat /MRIWork/MRIWork10/pv/giusi_pollicina/Sounds_analysis/sub-03/sub-03_ses-mri_task-sound_run-01_fs2bold.mat \
	-inverse /MRIWork/MRIWork10/pv/giusi_pollicina/Sounds_analysis/sub-03/sub-03_ses-mri_task-sound_run-01_bold2fs.mat

    ### Apply the tranformation matrix

    /usr/local/apps/psycapps/fsl/fsl-latest/bin/flirt \
	-in /MRIWork/MRIWork10/pv/giusi_pollicina/Sounds_analysis/sub-03/masks/lh_V1.nii.gz \
	-applyxfm -init /MRIWork/MRIWork10/pv/giusi_pollicina/Sounds_analysis/sub-03/sub-03_ses-mri_task-sound_run-01_fs2bold.mat \
	-out /MRIWork/MRIWork10/pv/giusi_pollicina/Sounds_analysis/sub-03/masks/lh_V1_bold.nii.gz \
	-paddingsize 0.0 -interp trilinear \
	-ref /MRIWork/MRIWork10/pv/giusi_pollicina/Sounds_analysis/sub-03/sub-03_ses-mri_task-sound_run-01_meants.nii.gz

done

