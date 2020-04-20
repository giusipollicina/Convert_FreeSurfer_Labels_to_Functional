#!/bin/sh



OUTPUT_LOG_DIR=/MRIWork/MRIWork10/pv/giusi_pollicina/Sounds_analysis/freesurfer/convert_fs_label_to_volume_mask_logs

mkdir -p $OUTPUT_LOG_DIR

script_folder=$(pwd)

for subject_number in $subject

do
	qsub	-l h_rss=8G \
		-o ${OUTPUT_LOG_DIR}/conversion_${subject_number}.out \
		-e ${OUTPUT_LOG_DIR}/conversion_${subject_number}.err \
		$script_folder/convert_fs_label_to_volume_mask.sh $subject;

done
