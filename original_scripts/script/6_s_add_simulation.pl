#!/usr/bin/perl -w
use strict;

my $genome_file = $ARGV[0];
my $simulation_file=$ARGV[1];


$genome_file=~s/\.\.\///;
print $genome_file,"\n";
$genome_file=~s/\S+\///;
my$name_SNP="./s_".$genome_file;


open OUTPUT1, ">$name_SNP\n" or die "cannot open file";



open (FILE2, $simulation_file) or die "cannot open file";
my %depth=();
my %depth_A_bulk=();
my %depth_B_bulk=();
while (my $genome = <FILE2>) {
    chomp $genome;
    my @colom = split (/\t+/, $genome);
    my $depht=$colom[0];
    
    my @delta_colom = splice (@colom, 1,4);
    my @delta_colom_A_bulk = splice (@colom, 1,4);
    my @delta_colom_B_bulk = splice (@colom, 1,4);
    
    my $delta_colom_all =join("\t",@delta_colom);
    my $delta_colom_A_bulk =join("\t",@delta_colom_A_bulk);
    my $delta_colom_B_bulk =join("\t",@delta_colom_B_bulk);
    
    $depth{$depht}=$delta_colom_all;
    $depth_A_bulk{$depht}=$delta_colom_A_bulk;
    $depth_B_bulk{$depht}=$delta_colom_B_bulk;
}


my $line=1;

open (FILE, $genome_file) or die "cannot open file";
while (my $genome = <FILE>) {
    chomp $genome;
    my @colom = split (/\t+/, $genome);

    if($line==1){
        my $colom_all =join("\t",@colom);
        $line=2
    }else{
        my $caluclate=$colom[3]-$colom[5];
        my $depth=0;
        if($caluclate>0){
             $depth=$colom[5]
        }else{
            $depth=$colom[3]
        }
        my $colom_all =join("\t",@colom);
        print OUTPUT1   "$colom_all\t$depth{$depth}\t$depth_A_bulk{$colom[3]}\t$depth_B_bulk{$colom[5]}\t$depth{$depth}\n"; 
    }
}

close(OUTPUT1);
close(FILE);
 
