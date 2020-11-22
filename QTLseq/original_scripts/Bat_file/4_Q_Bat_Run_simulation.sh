#! /bin/sh
#$ -S /bin/sh
#$ -cwd

# qsub -N log_file -pe def_slot 2 -l s_vmem=15G -l mem_req=15G -l month ./Q_Bat_Run.sh
used_cpu=

individual_number=
reprication=
filtered_depth=
population_structure=   #"RIL" or "F2"
#----------------------------------------------------------
filtered_both_false_snp_index=0


cd simulation_result

if [ -e ${population_structure}_${individual_number}_individuals.txt ]; then
    echo "${population_structure}_${individual_number}_individuals.txt OK"
else
    Rscript ../script/qtl_seq_sumilation_v5.R ${individual_number} ${reprication} ${filtered_both_false_snp_index} ${population_structure}
fi


cd ../
