#!/usr/bin/perl

use strict;
use warnings;
my $A_bulk_reads_txt = $ARGV[0];
my $ref_fasta = $ARGV[1];
my $bwa_path = $ARGV[2];
my $samtools_path = $ARGV[3];
my $A_bulk_reads_txt_rename=$A_bulk_reads_txt;
$A_bulk_reads_txt_rename=~s/\S+\///;
my $A_bulk_reads_txt_rename1="ex_for_alignment_".$A_bulk_reads_txt_rename;
my $A_bulk_reads_txt_rename2="ex_for_sam_development_".$A_bulk_reads_txt_rename;
my $A_bulk_reads_txt_rename3="ex_for_bam_development_".$A_bulk_reads_txt_rename;
open OUTPUT1, ">$A_bulk_reads_txt_rename1\n" or die "cannnot open output";
open OUTPUT2, ">$A_bulk_reads_txt_rename2\n" or die "cannnot open output";
open OUTPUT3, ">$A_bulk_reads_txt_rename3\n" or die "cannnot open output";
open (FILE1, $A_bulk_reads_txt) or die "cannot open file1";

###########################################################
my $read_count=0;
while (my $file = <FILE1>) {
    chomp $file;

    if ($file =~ /^#/){
        
    }else{
        $read_count=$read_count+1;
        my @colom1 = split (/\s+/, $file);
        print OUTPUT1 "$bwa_path aln $ref_fasta $colom1[0] >A_bulk_temp_${read_count}_1.sai\n";
        print OUTPUT1 "$bwa_path aln $ref_fasta $colom1[1] >A_bulk_temp_${read_count}_2.sai\n";
        print OUTPUT2 "$bwa_path sampe ${ref_fasta} A_bulk_temp_${read_count}_1.sai A_bulk_temp_${read_count}_2.sai $colom1[0] $colom1[1]>A_bulk_temp_${read_count}.sam\n";
        print OUTPUT3 "$samtools_path view -bS A_bulk_temp_${read_count}.sam> A_bulk_temp_${read_count}.bam\n";
    }
}
close (FILE1);
#############################################################


