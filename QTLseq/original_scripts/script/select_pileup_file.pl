#!/usr/bin/perl -w
use strict;

my $genome_file = $ARGV[0];
my $threshold_depht=$ARGV[1];
my $threshold_snp_index=$ARGV[2];
open (FILE, $genome_file) or die "cannot open file";

$genome_file=~s/\.\.\///;
print $genome_file,"\n";
$genome_file=~s/\S+\///;


my$name_SNP1="./m_".$genome_file;
open OUTPUT1, ">$name_SNP1\n" or die "cannot open file";


while (my $genome = <FILE>) {
    chomp $genome;
    my @colom = split (/\t+/, $genome);
    my $colom_all =join("\t",@colom);

    if ($colom[4]>=$threshold_depht and $colom[-1]>=$threshold_snp_index){
        print OUTPUT1  $colom_all, "\n"; 

    }
}

close(OUTPUT1);
close(FILE);
 