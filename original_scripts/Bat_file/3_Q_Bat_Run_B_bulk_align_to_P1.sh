#! /bin/sh	
#$ -S /bin/sh
#$ -cwd

# qsub -N log_file -pe def_slot 2 -l s_vmem=15G -l mem_req=15G -l month ./Q_Bat_Run.sh
used_cpu=
samtools_PATH=
bwa_PATH=
filtered_depth=
filtered_snp_index=0
filtered_mapping_score_in_bam=

work_dir=`pwd`
chmod +x -R $work_dir/*


P1_ref=${work_dir}/P1_ref_seq_development/P1_ref.fa
P1_self_bam=${work_dir}/P1_self_alignment/P1_all_mapped_sort.bam

mkdir B_bulk_to_P1_alignment
cd B_bulk_to_P1_alignment
perl ../script/making_bwa_format_for_B_bulk.pl ${work_dir}/read_information/B_bulk_reads.txt ${P1_ref} ${bwa_PATH} ${samtools_PATH}
chmod +x -R $work_dir/*

cat ex_for_alignment_B_bulk_reads.txt|xargs -P ${used_cpu} -I % sh -c %
cat ex_for_sam_development_B_bulk_reads.txt|xargs -P${used_cpu} -I % sh -c %
rm *temp*.sai
cat ex_for_bam_development_B_bulk_reads.txt|xargs -P${used_cpu} -I % sh -c %
rm *temp*.sam



B_bulk_bam_file=`ls B_bulk_*.bam`
B_bulk_bam_file_alley=(`ls B_bulk_*.bam`)
num_of_B_bulk_bam_file_alley=`echo ${#B_bulk_bam_file_alley[*]}`
if test 1 -eq ${num_of_B_bulk_bam_file_alley} ; then
  cp ${B_bulk_bam_file} B_bulk_all_temp.bam
else
  $samtools_PATH merge B_bulk_all_temp.bam ${B_bulk_bam_file}
fi

perl ../script/bam_filter.pl B_bulk_all_temp.bam ${filtered_mapping_score_in_bam} $samtools_PATH

rm B_bulk_temp*.bam
$samtools_PATH sort -T B_bulk_temp -@ ${used_cpu} f_B_bulk_all_temp.bam -o B_bulk_all_merge.bam
rm B_bulk_all_temp.bam

$samtools_PATH rmdup B_bulk_all_merge.bam B_bulk_all_merge_rmdup.bam


$samtools_PATH view -b -f 4 B_bulk_all_merge_rmdup.bam > B_bulk_all_unmapped.bam
$samtools_PATH view -b -F 4 B_bulk_all_merge_rmdup.bam > B_bulk_all_mapped.bam
$samtools_PATH sort -T B_bulk_temp -@ ${used_cpu} B_bulk_all_mapped.bam -o B_bulk_all_mapped_sort_temp.bam
rm B_bulk_all_mapped.bam
# ../original_scripts/Coval-1.4/coval refine B_bulk_all_mapped_sort_temp.bam -r ${P1_ref} -pref B_bulk_all_mapped_sort
mv B_bulk_all_mapped_sort_temp.bam B_bulk_all_mapped_sort.bam
# rm B_bulk_all_mapped_sort_temp.bam
$samtools_PATH index B_bulk_all_mapped_sort.bam
perl ../script/depth_calc_from_bam.pl B_bulk_all_mapped_sort.bam $samtools_PATH
perl ../script/cover_ratio_from_bam.pl B_bulk_all_mapped_sort.bam $samtools_PATH