#! /bin/sh	
#$ -S /bin/sh
#$ -cwd

# qsub -N log_file -pe def_slot 2 -l s_vmem=15G -l mem_req=15G -l month ./Q_Bat_Run.sh
used_cpu=
samtools_PATH=
bwa_PATH=
filtered_mapping_score_in_bam=


work_dir=`pwd`
chmod +x -R $work_dir/*


P1_ref=${work_dir}/P1_ref_seq_development/P1_ref.fa

mkdir P1_self_alignment
cd P1_self_alignment
perl ../script/making_bwa_format_for_P1.pl ${work_dir}/read_information/P1_reads.txt ${P1_ref} ${bwa_PATH} ${samtools_PATH}
chmod +x -R $work_dir/*

cat ex_for_alignment_P1_reads.txt|xargs -P ${used_cpu} -I % sh -c %
cat ex_for_sam_development_P1_reads.txt|xargs -P${used_cpu} -I % sh -c %
rm *temp*.sai
cat ex_for_bam_development_P1_reads.txt|xargs -P${used_cpu} -I % sh -c %
rm *temp*.sam



P1_bam_file=`ls P1_*.bam`
P1_bam_file_alley=(`ls P1_*.bam`)
num_of_P1_bam_file_alley=`echo ${#P1_bam_file_alley[*]}`
if test 1 -eq ${num_of_P1_bam_file_alley} ; then
  cp ${P1_bam_file} P1_all_temp.bam
else
  $samtools_PATH merge P1_all_temp.bam ${P1_bam_file}
fi


perl ../script/bam_filter.pl P1_all_temp.bam ${filtered_mapping_score_in_bam} $samtools_PATH


rm P1_temp*.bam
$samtools_PATH sort -T P1_temp -@ ${used_cpu} f_P1_all_temp.bam -o P1_all_merge.bam
rm P1_all_temp.bam


$samtools_PATH rmdup P1_all_merge.bam P1_all_merge_rmdup.bam


$samtools_PATH view -b -f 4 P1_all_merge_rmdup.bam > P1_all_unmapped.bam
$samtools_PATH view -b -F 4 P1_all_merge_rmdup.bam > P1_all_mapped.bam
$samtools_PATH sort -T P1_temp -@ ${used_cpu} P1_all_mapped.bam -o P1_all_mapped_sort_temp.bam
rm P1_all_mapped.bam
# ../original_scripts/Coval-1.4/coval refine P1_all_mapped_sort_temp.bam -r ${P1_ref} -pref P1_all_mapped_sort
mv P1_all_mapped_sort_temp.bam P1_all_mapped_sort.bam
# rm P1_all_mapped_sort_temp.bam

$samtools_PATH index P1_all_mapped_sort.bam
perl ../script/depth_calc_from_bam.pl P1_all_mapped_sort.bam $samtools_PATH
perl ../script/cover_ratio_from_bam.pl P1_all_mapped_sort.bam $samtools_PATH
