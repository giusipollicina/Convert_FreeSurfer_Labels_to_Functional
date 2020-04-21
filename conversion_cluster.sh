#!/bin/sh

subject_list=$1

OUTPUT_LOG_DIR=/MRIWork/MRIWork10/pv/giusi_pollicina/Sounds_analysis/freesurfer/convert_fs_label_to_volume_mask_logs

mkdir -p $OUTPUT_LOG_DIR

script_folder=/MRIWork/MRIWork10/pv/giusi_pollicina/Convert_FreeSurfer_Labels_to_Functional

IFS=', ' read -a subject_list <<< "$subject_list"

for subject in "${subject_list[@]}"; 

do
	qsub	-l h_rss=8G \
		-o ${OUTPUT_LOG_DIR}/conversion_${subject_number}.out \
		-e ${OUTPUT_LOG_DIR}/conversion_${subject_number}.err \
		$script_folder/convert_fs_label_to_volume_mask.sh $subject;

done
