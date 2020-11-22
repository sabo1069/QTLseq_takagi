#! /bin/sh	
#$ -S /bin/sh
#$ -cwd
#/usr/local/bin/samtools Version: 1.3.1 (using htslib 1.3.1)
#BWA Version: 0.7.12-r1039
#Please confirm the read information files
public_reference_fasta=
used_cpu=
samtools_PATH=
bwa_PATH=
filtered_mapping_score_in_bam=

#developing P1 ref
filtered_depth=
the_snp_index_threshold_for_exchanging_with_public_ref=

#--------------------------------------------------------------------------------------------------------


work_dir=`pwd`
chmod +x -R $work_dir/*


#developing pubulic fasta index################################################
public_reference_fasta_name=`echo ${public_reference_fasta}|sed -e "s/.*\\///"`
mkdir public_fasta
cd public_fasta
ln -s ${public_reference_fasta}
public_reference=${public_reference_fasta_name}
${bwa_PATH} index -p ${public_reference} -a is ${public_reference}
cd ../
#-----------------------------------------------------------------------


mkdir P1_ref_seq_development
cd P1_ref_seq_development
perl ../script/making_bwa_format_for_parental_line.pl ${work_dir}/read_information/P1_reads.txt ${work_dir}/public_fasta/${public_reference} ${bwa_PATH} ${samtools_PATH}

chmod +x *
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

$samtools_PATH sort -T P1_temp -@ ${used_cpu} f_P1_all_temp.bam -o P1_all_merge.bam
rm P1_temp*.bam
rm P1_all_temp.bam

$samtools_PATH rmdup P1_all_merge.bam P1_all_merge_rmdup.bam
$samtools_PATH view -b -f 4 P1_all_merge_rmdup.bam > P1_all_unmapped.bam
$samtools_PATH view -b -F 4 P1_all_merge_rmdup.bam > P1_all_mapped.bam
$samtools_PATH sort -T P1_temp -@ ${used_cpu} P1_all_mapped.bam -o P1_all_mapped_sort.bam
$samtools_PATH index P1_all_mapped_sort.bam

perl ../script/snp_index_calc_from_pileup_without_index.pl P1_all_mapped_sort.bam ${public_reference_fasta} $samtools_PATH
perl ../script/select_pileup_file.pl P1_all_mapped_sort.pileup ${filtered_depth} ${the_snp_index_threshold_for_exchanging_with_public_ref}
perl ../script/make_consensus.pl -ref ${public_reference_fasta} m_P1_all_mapped_sort.pileup >P1_ref.fa

${bwa_PATH} index -p P1_ref.fa -a is P1_ref.fa

cd $work_dir
mkdir all_log_files
mv log_file* all_log_files
