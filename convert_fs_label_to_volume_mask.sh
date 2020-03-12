#!/bin/bash

#######
#This is a Template script. DOn't use the commands blindly without changing the parameters 
#because they might affect Giusi's Analysis
#######

### change to the corresponding subject folder
source /usr/local/apps/psycapps/config/freesurfer_bash_update /MRIWork/MRIWork10/pv/giusi_pollicina/Sounds_analysis/freesurfer


### Convert Freeesurfer Brain to volumetric brain (.mgz to .nii.gz)
### The nifti output of the previous step results in a volume image of 256x256x256. If you want to change the size use -- cropsize flag
mri_convert --out_orientation RAS Sounds_analysis/freesurfer/sub-03/mri/brain.mgz Sounds_analysis/sub-03/freesurfer_brain.nii.gz


