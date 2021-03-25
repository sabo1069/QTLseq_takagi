#!/usr/bin/perl

use strict;
use warnings;
my $Public_fa_fai = $ARGV[0];
my $sort_bam = $ARGV[1];
my $public_reference_fasta=$ARGV[2];
my $samtools_PATH=$ARGV[3];


my $Public_fa_fai_rename=$Public_fa_fai;
$Public_fa_fai_rename=~s/\S+\///;
my $Public_fa_fai_rename1="ex_for_pileup_".$Public_fa_fai_rename;
my $Public_fa_fai_rename2="ex_for_bam_devi_".$Public_fa_fai_rename;
my $Public_fa_fai_rename3="ex_for_cat_pileup_".$Public_fa_fai_rename;
open OUTPUT0, ">$Public_fa_fai_rename2\n" or die "cannnot open output";
open OUTPUT1, ">$Public_fa_fai_rename1\n" or die "cannnot open output";
open OUTPUT2, ">$Public_fa_fai_rename3\n" or die "cannnot open output";
open (FILE1, $Public_fa_fai) or die "cannot open file1";

###########################################################
my $read_count=0;
while (my $file = <FILE1>) {
    chomp $file;

    $read_count=$read_count+1;
    my @colom1 = split (/\s+/, $file);
    my $out_bam_file = $colom1[0]."_sort.bam";
    my $out_pileup_file = $colom1[0]."_sort.pileup";
    print OUTPUT0 "$samtools_PATH view -b input.bam $colom1[0] > out_bam_file\n";
    print OUTPUT1 "perl ../script/snp_index_calc_from_pileup_without_index_multi.pl $out_bam_file ${public_reference_fasta} $samtools_PATH\n";
    print OUTPUT1 "perl ../script/snp_index_calc_from_pileup_without_index_multi.pl $out_bam_file ${public_reference_fasta} $samtools_PATH\n";

    if ($read_count==1){

        print OUTPUT2 "cat $out_pileup_file";

    }else{
        print OUTPUT2 "\t$out_pileup_file";
    }

}
close (FILE1);

my $sort_bam_name=$sort_bam;
$sort_bam_name=~s/\S+\///;
$sort_bam_name=~s/.bam/.pileup/;
print OUTPUT2 ">$sort_bam_name";


#############################################################
