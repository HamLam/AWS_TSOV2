#!/usr/bin/perl

use strict;
use warnings;

open (my $R1, "<", $ARGV[0]) or die "Can't open Full gene list file for reading: $!";; # file of: TSOV2 genes with chr listed
open (my $R2, "<", $ARGV[1]) or die "Can't open Ordered_genes_list.txt for reading: $!"; # ordered_genes.txt file
open(my $OUT, ">", "chr3_4_5_genes_file.txt") or die "Can't open >> chr1_2_genes_file.txt: $!"; #for writing

my @B;
my %hash=();

while(<$R1>){
 chomp;
 @B = split(' ',$_);
 $hash{$B[1]} = $B[0];
}

my $CHR;

while(<$R2>){
 chomp($_);
  $CHR = matching($_, \%hash); # match gene to chromosome number
   if($CHR eq "3"){
        print $OUT $_,"\n";
       }elsif ($CHR eq "4"){
        print $OUT $_, "\n";
       }elsif ($CHR eq "5"){
        print $OUT $_, "\n";
       }else{
        next;
      }
   }

sub matching{
 my ($gene, $hash_ref) = @_;
  if(defined $hash_ref ->{$gene}){
 #  print $gene,"\t", "chr: ", $hash_ref -> {$gene},"\n";
   return ($hash_ref -> {$gene});
  }else{
   print $gene, ": Not in chr3_4_5 group\n";
   #next;
  }
 # return ($hash_ref -> {$gene});
}

close($OUT);
close($R1);
close($R2);
