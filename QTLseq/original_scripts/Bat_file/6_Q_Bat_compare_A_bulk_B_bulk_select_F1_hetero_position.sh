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
#---------------------------------
filtered_both_false_snp_index=0

work_dir=`pwd`
chmod +x -R $work_dir/*


F1_hetero_pileup=${work_dir}/F1_to_P1_alignment/sim_Fishire_test_m_P1_vs_F1.pileup

filtered_bulk_pileup=${work_dir}/compare_A_bulk_B_bulk/P1_A_bulk_B_bulk.pileup


mkdir compare_A_bulk_B_bulk_select_F1_hetero_SNP
cd compare_A_bulk_B_bulk_select_F1_hetero_SNP

perl ../script/10_common_position_select.pl ${F1_hetero_pileup} ${filtered_bulk_pileup}
perl ../script/6_select_pileup_file.pl common_F1_hetero_snp_P1_A_bulk_B_bulk.pileup ${filtered_depth} ${filtered_both_false_snp_index}

perl ../script/6_s_add_simulation.pl m_common_F1_hetero_snp_P1_A_bulk_B_bulk.pileup ../simulation_result/${population_structure}_${individual_number}_individuals.txt
Rscript ../script/7_QTLseq_sliding_window_170321.R s_m_common_F1_hetero_snp_P1_A_bulk_B_bulk.pileup ${window_size_Mb}000000 ${step_size_kb}000 ${howmany_snp_number}
Rscript ../script/8_MutMap_graph_bulkA.R s_m_common_F1_hetero_snp_P1_A_bulk_B_bulk.pileup sliding_window_${window_size_Mb}_Mb_s_m_common_F1_hetero_snp_P1_A_bulk_B_bulk.pileup
Rscript ../script/8_MutMap_graph_bulkB.R s_m_common_F1_hetero_snp_P1_A_bulk_B_bulk.pileup sliding_window_${window_size_Mb}_Mb_s_m_common_F1_hetero_snp_P1_A_bulk_B_bulk.pileup
Rscript ../script/8_MutMap_graph_bulkD.R s_m_common_F1_hetero_snp_P1_A_bulk_B_bulk.pileup sliding_window_${window_size_Mb}_Mb_s_m_common_F1_hetero_snp_P1_A_bulk_B_bulk.pileup



cd ../



