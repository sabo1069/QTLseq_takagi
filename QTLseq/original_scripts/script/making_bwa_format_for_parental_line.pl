#!/usr/bin/perl

use strict;
use warnings;
my $P1_reads_txt = $ARGV[0];
my $ref_fasta = $ARGV[1];
my $bwa_path = $ARGV[2];
my $samtools_path = $ARGV[3];
my $P1_reads_txt_rename=$P1_reads_txt;
$P1_reads_txt_rename=~s/\S+\///;
my $P1_reads_txt_rename1="ex_for_alignment_".$P1_reads_txt_rename;
my $P1_reads_txt_rename2="ex_for_sam_development_".$P1_reads_txt_rename;
my $P1_reads_txt_rename3="ex_for_bam_development_".$P1_reads_txt_rename;
open OUTPUT1, ">$P1_reads_txt_rename1\n" or die "cannnot open output";
open OUTPUT2, ">$P1_reads_txt_rename2\n" or die "cannnot open output";
open OUTPUT3, ">$P1_reads_txt_rename3\n" or die "cannnot open output";
open (FILE1, $P1_reads_txt) or die "cannot open file1";

###########################################################
my $read_count=0;
while (my $file = <FILE1>) {
    chomp $file;

    if ($file =~ /^#/){
        
    }else{
        $read_count=$read_count+1;
        my @colom1 = split (/\s+/, $file);
        print OUTPUT1 "$bwa_path aln $ref_fasta $colom1[0] >P1_temp_${read_count}_1.sai\n";
        print OUTPUT1 "$bwa_path aln $ref_fasta $colom1[1] >P1_temp_${read_count}_2.sai\n";
        print OUTPUT2 "$bwa_path sampe ${ref_fasta} P1_temp_${read_count}_1.sai P1_temp_${read_count}_2.sai $colom1[0] $colom1[1]>P1_temp_${read_count}.sam\n";
        print OUTPUT3 "$samtools_path view -bS P1_temp_${read_count}.sam> P1_temp_${read_count}.bam\n";
    }
}
close (FILE1);
#############################################################


