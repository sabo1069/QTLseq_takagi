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

mkdir A_bulk_to_P1_alignment
cd A_bulk_to_P1_alignment
perl ../script/making_bwa_format_for_A_bulk.pl ${work_dir}/read_information/A_bulk_reads.txt ${P1_ref} ${bwa_PATH} ${samtools_PATH}
chmod +x -R $work_dir/*

cat ex_for_alignment_A_bulk_reads.txt|xargs -P ${used_cpu} -I % sh -c %
cat ex_for_sam_development_A_bulk_reads.txt|xargs -P${used_cpu} -I % sh -c %
rm *temp*.sai
cat ex_for_bam_development_A_bulk_reads.txt|xargs -P${used_cpu} -I % sh -c %
rm *temp*.sam



A_bulk_bam_file=`ls A_bulk_*.bam`
A_bulk_bam_file_alley=(`ls A_bulk_*.bam`)
num_of_A_bulk_bam_file_alley=`echo ${#A_bulk_bam_file_alley[*]}`
if test 1 -eq ${num_of_A_bulk_bam_file_alley} ; then
  cp ${A_bulk_bam_file} A_bulk_all_temp.bam
else
  $samtools_PATH merge A_bulk_all_temp.bam ${A_bulk_bam_file}
fi

perl ../script/bam_filter.pl A_bulk_all_temp.bam ${filtered_mapping_score_in_bam} $samtools_PATH

rm A_bulk_temp*.bam
$samtools_PATH sort -T A_bulk_temp -@ ${used_cpu} f_A_bulk_all_temp.bam -o A_bulk_all_merge.bam
rm A_bulk_all_temp.bam

$samtools_PATH rmdup A_bulk_all_merge.bam A_bulk_all_merge_rmdup.bam


$samtools_PATH view -b -f 4 A_bulk_all_merge_rmdup.bam > A_bulk_all_unmapped.bam
$samtools_PATH view -b -F 4 A_bulk_all_merge_rmdup.bam > A_bulk_all_mapped.bam
$samtools_PATH sort -T A_bulk_temp -@ ${used_cpu} A_bulk_all_mapped.bam -o A_bulk_all_mapped_sort_temp.bam
rm A_bulk_all_mapped.bam
# ../original_scripts/Coval-1.4/coval refine A_bulk_all_mapped_sort_temp.bam -r ${P1_ref} -pref A_bulk_all_mapped_sort
mv A_bulk_all_mapped_sort_temp.bam A_bulk_all_mapped_sort.bam
# rm A_bulk_all_mapped_sort_temp.bam
$samtools_PATH index A_bulk_all_mapped_sort.bam
perl ../script/depth_calc_from_bam.pl A_bulk_all_mapped_sort.bam $samtools_PATH
perl ../script/cover_ratio_from_bam.pl A_bulk_all_mapped_sort.bam $samtools_PATH