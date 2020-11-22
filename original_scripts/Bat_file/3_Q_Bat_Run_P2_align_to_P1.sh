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


mkdir P2_to_P1_alignment
cd P2_to_P1_alignment
perl ../script/making_bwa_format_for_P2.pl ${work_dir}/read_information/P2_reads.txt ${P1_ref} ${bwa_PATH} ${samtools_PATH}
chmod +x -R $work_dir/*

cat ex_for_alignment_P2_reads.txt|xargs -P ${used_cpu} -I % sh -c %
cat ex_for_sam_development_P2_reads.txt|xargs -P${used_cpu} -I % sh -c %
rm *temp*.sai
cat ex_for_bam_development_P2_reads.txt|xargs -P${used_cpu} -I % sh -c %
rm *temp*.sam



P2_bam_file=`ls P2_*.bam`
P2_bam_file_alley=(`ls P2_*.bam`)
num_of_P2_bam_file_alley=`echo ${#P2_bam_file_alley[*]}`
if test 1 -eq ${num_of_P2_bam_file_alley} ; then
  cp ${P2_bam_file} P2_all_temp.bam
else
  $samtools_PATH merge P2_all_temp.bam ${P2_bam_file}
fi

perl ../script/bam_filter.pl P2_all_temp.bam ${filtered_mapping_score_in_bam} $samtools_PATH

rm P2_temp*.bam
$samtools_PATH sort -T P2_temp -@ ${used_cpu} f_P2_all_temp.bam -o P2_all_merge.bam
rm P2_all_temp.bam

$samtools_PATH rmdup P2_all_merge.bam P2_all_merge_rmdup.bam
$samtools_PATH view -b -f 4 P2_all_merge_rmdup.bam > P2_all_unmapped.bam
$samtools_PATH view -b -F 4 P2_all_merge_rmdup.bam > P2_all_mapped.bam
$samtools_PATH sort -T P2_temp -@ ${used_cpu} P2_all_mapped.bam -o P2_all_mapped_sort.bam
$samtools_PATH index P2_all_mapped_sort.bam

perl ../script/depth_calc_from_bam.pl P2_all_mapped_sort.bam $samtools_PATH
perl ../script/cover_ratio_from_bam.pl P2_all_mapped_sort.bam $samtools_PATH

P1_self_bam=${work_dir}/P1_self_alignment/P1_all_mapped_sort.bam

perl ../script/4_select_pileup_file_without_indel.pl ${P1_self_bam} P2_all_mapped_sort.bam ${P1_ref} $samtools_PATH ${filtered_depth}
perl ../script/5_select_pileup_file.pl P1_vs_P2.pileup ${filtered_depth} 1
