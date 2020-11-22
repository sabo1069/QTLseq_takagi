#! /bin/sh
#$ -S /bin/sh
#$ -cwd
used_cpu=20
samtools_PATH="/lustre7/home/lustre3/segawa-tenta/tools/bin/samtools-1.9/samtools"
bwa_PATH="/lustre7/home/lustre3/segawa-tenta/tools/bin/bwa-0.7.17/bwa"
P1_name="CHOY"
P2_name="Kohiki"
A_bulk_name="no_flowering"
B_bulk_name="early_flowering"

public_ref="/lustre7/home/lustre3/nori-iso/FASTA_file/Brassica_rapa_chr/BrapaV2.5_Chr.2.fa"
filtered_depth=10
individual_number=20
population_structure=F2 #F2 or RIL

window_size_Mb=2
step_size_kb=50
howmany_snp_number=10

#----------------------------------------
#———————————————————————————————————————————————
NIG_supercomputer=yes #yes or no
the_snp_index_threshold_for_exchanging_with_public_ref=1
reprication=10000
filtered_mapping_score_in_bam=10

for munber_name in ${P1_name} ${P2_name} ${A_bulk_name} ${B_bulk_name}
do
    if echo ${munber_name} | grep ^[0-9] ; then
      echo "Change sample name.　The use of numeric charactor must be avoided at the first character for sample name."
      exit
    fi
done

if echo ${P1_name} | grep -e 'P2' -e 'A_bulk' -e 'B_bulk' ; then
  echo "You need to change 'P1_name'. Remove the charactor 'P2' or 'A_bulk' or 'B_bulk' from P1_name."
  exit
fi

if echo ${P2_name} | grep -e 'A_bulk' -e 'B_bulk' ; then
  echo "You need to change 'P2_name'. Remove the charactor 'A_bulk' or 'B_bulk' from P2_name."
  exit
fi

if echo ${A_bulk_name} | grep 'B_bulk' ; then
  echo "You need to change 'A_bulk_name'. Remove the charactor 'B_bulk' from A_bulk_name."
  exit
fi

#———————————————————————————————————————————————


work_dir=`pwd`

perl original_scripts/script/fasta_size_check.pl ${public_ref}
fata_name=`echo ${public_ref}|sed -e "s/.*\\///"`
fasta_length=${work_dir}/${fata_name}_length.txt
test_length=`cat ${fasta_length} |awk 'END{print}'|sed -e "s/Total://"`

bwa_option1=is
if test ${test_length} -gt 300000000 ; then
  bwa_option1=bwtsw
fi


Bat_files=`ls original_scripts/Bat_file`
for each_Bat_files in $Bat_files
do
     echo $each_Bat_files
     perl original_scripts/devloping_all_program_files/0_rename_bat_file.pl original_scripts/Bat_file/$each_Bat_files ${work_dir} $P1_name $P2_name $A_bulk_name $B_bulk_name $public_ref $used_cpu $samtools_PATH $filtered_depth $the_snp_index_threshold_for_exchanging_with_public_ref $bwa_option1 $bwa_PATH $individual_number $reprication $population_structure $window_size_Mb $step_size_kb $howmany_snp_number $filtered_mapping_score_in_bam
done


mkdir script

script_files=`ls original_scripts/script`
for each_script_files in $script_files
do
     echo $each_script_files
     perl original_scripts/devloping_all_program_files/0_rename_file.pl original_scripts/script/$each_script_files ${work_dir}/script $P1_name $P2_name $A_bulk_name $B_bulk_name $public_ref $used_cpu $samtools_PATH $filtered_depth $the_snp_index_threshold_for_exchanging_with_public_ref $bwa_option1 $bwa_PATH
done

mkdir read_information
perl original_scripts/devloping_all_program_files/0_developing_read_information.pl read_PATH.txt ${work_dir}/read_information $P1_name $P2_name $A_bulk_name $B_bulk_name


#--------------------------------------------------------------------------------------
if test ${NIG_supercomputer} = "yes" ; then
	txt7=$(ls 7_Q_Bat_compare_*.sh)
	mv ${txt7} __${txt7}
	perl ./original_scripts/script/NIG_format.pl __${txt7}

	txt6=$(ls 6_Q_Bat_compare_*.sh)
	mv ${txt6} __${txt6}
	perl ./original_scripts/script/NIG_format.pl __${txt6}

	txt5=$(ls 5_Q_Bat_Run_compare_*.sh)
	mv ${txt5} __${txt5}
	perl ./original_scripts/script/NIG_format.pl __${txt5}

	txt3=$(ls 3_Q_Bat_Run_F1_align_to_*.sh)
	mv ${txt3} __${txt3}
	perl ./original_scripts/script/NIG_format.pl __${txt3}

	mv 4_Q_Bat_Run_simulation.sh __4_Q_Bat_Run_simulation.sh
	perl ./original_scripts/script/NIG_format.pl __4_Q_Bat_Run_simulation.sh

	rm __*
fi


chmod +x *.sh
