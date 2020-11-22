#!/usr/bin/perl

use strict;
use warnings;
my $file = $ARGV[0]; #read_PATH.txt

my $work_dir = $ARGV[1];
$work_dir=~s/\/$//;
my $P1=$ARGV[2];
my $P2=$ARGV[3];
my $A_bulk=$ARGV[4];
my $B_bulk=$ARGV[5];
my $F1="F1";

my $file_name="_reads.txt";
my $file_name_P1=$work_dir."\/".$P1.$file_name;
my $file_name_P2=$work_dir."\/".$P2.$file_name;
my $file_name_A_bulk=$work_dir."\/".$A_bulk.$file_name;
my $file_name_B_bulk=$work_dir."\/".$B_bulk.$file_name;
my $file_name_F1=$work_dir."\/".$F1.$file_name;


open (FILE1, $file) or die "cannot open file1";

###########################################################
open OUTPUT_P1, ">$file_name_P1\n" or die "cannnot open output";
open OUTPUT_P2, ">$file_name_P2\n" or die "cannnot open output";
open OUTPUT_A_bulk, ">$file_name_A_bulk\n" or die "cannnot open output";
open OUTPUT_B_bulk, ">$file_name_B_bulk\n" or die "cannnot open output";
open OUTPUT_F1, ">$file_name_F1\n" or die "cannnot open output";


my $on_off_P1=0;
my $on_off_P2=0;
my $on_off_A_bulk=0;
my $on_off_B_bulk=0;
my $on_off_F1=0;


while (<FILE1>){
    chomp;
    
    if($_=~/^In put/){
            $on_off_P1=0;
            $on_off_P2=0;
            $on_off_A_bulk=0;
            $on_off_B_bulk=0;
            $on_off_F1=0;
    }
    
    if($on_off_P1==1){
        print OUTPUT_P1 "$_\n"; 
    }
    if($on_off_P2==1){
        print OUTPUT_P2 "$_\n"; 
    }
    if($on_off_A_bulk==1){
        print OUTPUT_A_bulk "$_\n"; 
    }
    if($on_off_B_bulk==1){
        print OUTPUT_B_bulk "$_\n"; 
    }
    
    if($on_off_F1==1){
        print OUTPUT_F1 "$_\n"; 
    }    
    
    
    if($_=~/^In put P1/){
        $on_off_P1=1;
    }

    if($_=~/^In put P2/){
        $on_off_P2=1;
    }

    if($_=~/^In put A_bulk/){
        $on_off_A_bulk=1;
    }
    
    if($_=~/^In put B_bulk/){
        $on_off_B_bulk=1;
    }  
    
    if($_=~/^In put F1/){
        $on_off_F1=1;
    }

    
}
close (FILE1);
#############################################################


