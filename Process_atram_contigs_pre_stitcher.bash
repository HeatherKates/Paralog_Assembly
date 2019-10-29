#!/bin/bash
for i in {001..100}; do
for x in *Locus.atram2.fasta*Locus_$i*filtered_contigs.fasta; do
#put name and sequence on one line for easier processing
awk 'NR%2{printf "%s ",$0;next;}1' $x > $x.oneline
#print only lines with unique scores (assumes score is in the fourth field and the separator is a " "
sort -u -t " " -k4,4 $x.oneline > $x.dupscoresremoved
#if the length in the sequence header is greater than 60% ref length
reflength=`grep -A1 Locus_${i} Phylogenetic_loci.fasta|sed -n 2p|wc -c`; awk -v var="$reflength" -F "_" '{if ($5/var>0.60) print $0}' $x.dupscoresremoved > $x.shortremoved
#add the sample name to the fasta header
name=`echo $x|cut -c 1-9`;sed "s/>/>$name /g" $x.shortremoved > $x.named
#Make sample names in sequence headers unique
awk '{$1=$1"."++a[$1]}1' $x.named > $x.uniq
#Change appended number to two digit notation 
sed -i 's/\.\([0-9]\{1\}\) /.0\1 /g'  $x.uniq
#back on two lines
sed -i -r 's/(.*) /\1\n/' $x.uniq
#Move every two lines to a new file and name file based on first line
grep ">" $x.uniq > $x.uniqIDs
while read file; do grep -w -A1 `echo $file|cut -c 1-13` ${x}.uniq > `echo $file|cut -c 2-13`_contig_Locus_$i.fasta; done < $x.uniqIDs
#cleanup
rm $x.uniq
rm $x.uniqIDs
rm $x.dupscoresremoved
rm $x.shortremoved
rm $x.oneline
rm $x.named;
done;
done
