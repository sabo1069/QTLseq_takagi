#!/usr/bin/perl

use strict;
use warnings;
my $file = $ARGV[0];

my $work_dir = $ARGV[1];
$work_dir=~s/\/$//;
my $P1=$ARGV[2];
my $P2=$ARGV[3];
my $A_bulk=$ARGV[4];
my $B_bulk=$ARGV[5];
my $public_ref=$ARGV[6];
my $used_cpu=$ARGV[7];
my $samtools_PATH=$ARGV[8];
my $filtered_depth=$ARGV[9];
my $the_snp_index_threshold_for_exchanging_with_public_ref=$ARGV[10];
my $bwa_option=$ARGV[11];
my $bwa_PATH=$ARGV[12];
my $individual_number=$ARGV[13];
my $reprication=$ARGV[14];
my $population_structure=$ARGV[15];
my $window_size_Mb=$ARGV[16];
my $step_size_kb=$ARGV[17];
my $howmany_snp_number=$ARGV[18];
my $filtered_mapping_score_in_bam=$ARGV[19];


my $fasta_name = $file;
$fasta_name=~s/\S+\///;
$fasta_name=~s/P1/$P1/g;
$fasta_name=~s/P2/$P2/g;
$fasta_name=~s/A_bulk/$A_bulk/g;
$fasta_name=~s/B_bulk/$B_bulk/g; 
my $file_name=$work_dir."\/".$fasta_name;

open OUTPUT, ">$file_name\n" or die "cannnot open output";


open (FILE1, $file) or die "cannot open file1";

###########################################################

while (<FILE1>){
    chomp;

    $_=~s/P1/$P1/g;
    $_=~s/P2/$P2/g;
    $_=~s/A_bulk/$A_bulk/g;
    $_=~s/B_bulk/$B_bulk/g;
    $_=~s/^public_reference_fasta=/public_reference_fasta=$public_ref/g; 
    $_=~s/^used_cpu=/used_cpu=$used_cpu/g;
    $_=~s/^samtools_PATH=/samtools_PATH=$samtools_PATH/g;
    $_=~s/^filtered_depth=/filtered_depth=$filtered_depth/g;
    $_=~s/^the_snp_index_threshold_for_exchanging_with_public_ref=/the_snp_index_threshold_for_exchanging_with_public_ref=$the_snp_index_threshold_for_exchanging_with_public_ref/g;
    $_=~s/-a is/-a $bwa_option/g;
    $_=~s/^bwa_PATH=/bwa_PATH=$bwa_PATH/g;
    $_=~s/^individual_number=/individual_number=$individual_number/g;
    $_=~s/^reprication=/reprication=$reprication/g;
    $_=~s/^population_structure=/population_structure=$population_structure/g;
    $_=~s/^window_size_Mb=/window_size_Mb=$window_size_Mb/g;
    $_=~s/^step_size_kb=/step_size_kb=$step_size_kb/g;
    $_=~s/^howmany_snp_number=/howmany_snp_number=$howmany_snp_number/g;
    $_=~s/^filtered_mapping_score_in_bam=/filtered_mapping_score_in_bam=$filtered_mapping_score_in_bam/g;

    print OUTPUT "$_\n"; 
}
close (FILE1);
#############################################################


