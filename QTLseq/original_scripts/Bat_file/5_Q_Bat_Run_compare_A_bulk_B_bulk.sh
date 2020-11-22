#! /bin/sh	
#$ -S /bin/sh
#$ -cwd

# qsub -N log_file -pe def_slot 2 -l s_vmem=15G -l mem_req=15G -l month ./Q_Bat_Run.sh
used_cpu=
samtools_PATH=
filtered_depth=

window_size_Mb=
step_size_kb=
howmany_snp_number=

individual_number=
population_structure=

#--------------------------------------------------
filtered_both_false_snp_index=0.2



work_dir=`pwd`
chmod +x -R $work_dir/*


P1_ref=${work_dir}/P1_ref_seq_development/P1_ref.fa
P1_self_bam=${work_dir}/P1_self_alignment/P1_all_mapped_sort.bam
mkdir compare_A_bulk_B_bulk
cd compare_A_bulk_B_bulk
perl ../script/snp_index_calc_from_A_B_pileup_without_indel.pl ${P1_self_bam} ../A_bulk_to_P1_alignment/A_bulk_all_mapped_sort.bam ../B_bulk_to_P1_alignment/B_bulk_all_mapped_sort.bam ${P1_ref} $samtools_PATH ${filtered_depth}
perl ../script/6_select_pileup_file.pl P1_A_bulk_B_bulk.pileup ${filtered_depth} ${filtered_both_false_snp_index}
perl ../script/6_s_add_simulation.pl m_P1_A_bulk_B_bulk.pileup ../simulation_result/${population_structure}_${individual_number}_individuals.txt
Rscript ../script/7_QTLseq_sliding_window_170321.R s_m_P1_A_bulk_B_bulk.pileup ${window_size_Mb}000000 ${step_size_kb}000 ${howmany_snp_number}
Rscript ../script/8_MutMap_graph_bulkA.R s_m_P1_A_bulk_B_bulk.pileup sliding_window_${window_size_Mb}_Mb_s_m_P1_A_bulk_B_bulk.pileup
Rscript ../script/8_MutMap_graph_bulkB.R s_m_P1_A_bulk_B_bulk.pileup sliding_window_${window_size_Mb}_Mb_s_m_P1_A_bulk_B_bulk.pileup
Rscript ../script/8_MutMap_graph_bulkD.R s_m_P1_A_bulk_B_bulk.pileup sliding_window_${window_size_Mb}_Mb_s_m_P1_A_bulk_B_bulk.pileup



cd ../

