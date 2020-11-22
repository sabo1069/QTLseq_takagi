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
defined_p_value=0.05
work_dir=`pwd`
chmod +x -R $work_dir/*


P1_ref=${work_dir}/P1_ref_seq_development/P1_ref.fa


mkdir F1_to_P1_alignment
cd F1_to_P1_alignment
perl ../script/making_bwa_format_for_F1.pl ${work_dir}/read_information/F1_reads.txt ${P1_ref} ${bwa_PATH} ${samtools_PATH}
chmod +x -R $work_dir/*

cat ex_for_alignment_F1_reads.txt|xargs -P ${used_cpu} -I % sh -c %
cat ex_for_sam_development_F1_reads.txt|xargs -P${used_cpu} -I % sh -c %
rm *temp*.sai
cat ex_for_bam_development_F1_reads.txt|xargs -P${used_cpu} -I % sh -c %
rm *temp*.sam



F1_bam_file=`ls F1_*.bam`
F1_bam_file_alley=(`ls F1_*.bam`)
num_of_F1_bam_file_alley=`echo ${#F1_bam_file_alley[*]}`
if test 1 -eq ${num_of_F1_bam_file_alley} ; then
  cp ${F1_bam_file} F1_all_temp.bam
else
  $samtools_PATH merge F1_all_temp.bam ${F1_bam_file}
fi

perl ../script/bam_filter.pl F1_all_temp.bam ${filtered_mapping_score_in_bam} $samtools_PATH

rm F1_temp*.bam
$samtools_PATH sort -T F1_temp -@ ${used_cpu} f_F1_all_temp.bam -o F1_all_merge.bam
rm F1_all_temp.bam

$samtools_PATH rmdup F1_all_merge.bam F1_all_merge_rmdup.bam


$samtools_PATH view -b -f 4 F1_all_merge_rmdup.bam > F1_all_unmapped.bam
$samtools_PATH view -b -F 4 F1_all_merge_rmdup.bam > F1_all_mapped.bam
$samtools_PATH sort -T F1_temp -@ ${used_cpu} F1_all_mapped.bam -o F1_all_mapped_sort_temp.bam
rm F1_all_mapped.bam
# ../original_scripts/Coval-1.4/coval refine F1_all_mapped_sort_temp.bam -r ${P1_ref} -pref F1_all_mapped_sort
mv F1_all_mapped_sort_temp.bam F1_all_mapped_sort.bam
#rm F1_all_mapped_sort_temp.bam
$samtools_PATH index F1_all_mapped_sort.bam
perl ../script/depth_calc_from_bam.pl F1_all_mapped_sort.bam $samtools_PATH
perl ../script/cover_ratio_from_bam.pl F1_all_mapped_sort.bam $samtools_PATH

P1_self_bam=${work_dir}/P1_self_alignment/P1_all_mapped_sort.bam

perl ../script/4_select_pileup_file_without_indel.pl ${P1_self_bam} F1_all_mapped_sort.bam ${P1_ref} $samtools_PATH ${filtered_depth}
perl ../script/5_select_pileup_file_for_F1.pl P1_vs_F1.pileup ${filtered_depth} ${filtered_snp_index}
line_nuber=`cat m_P1_vs_F1.pileup|wc -l`
Rscript ../script/Fisher_test_for_F1_pileup_v2.R m_P1_vs_F1.pileup ${line_nuber} ${defined_p_value}
perl  ../script/common_F1_simulation.pl ../simulation_result/F1_individuals.txt Fishire_test_m_P1_vs_F1.pileup