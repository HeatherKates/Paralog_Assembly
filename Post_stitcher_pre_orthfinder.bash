#Use phyx to translate DNA to AA
module load gcc/8.2.0
module load phyx
for i in *fasta; do pxtlate -s $i > $i.AA.fasta; done
#Add locus names to headers (with 100 loci)
for i in {001..100}; do sed -i.bak "s/>/>Locus_${i}_/g" Test1.Locus_${i}.stitched_exons.fasta.AA.fasta.bak; done
#Separate by sample instead of locus
#create a list of samples from the taxon list used for exon stitching
awk -F "." '{print $1}' TaxonList.txt|sort|uniq > OrthFinderTaxonList.txt
#loop through loci and each sample and print each contig for a sample to a sample.AA.fasta file
for i in {001..100}; do while read file; do grep -A1 $file Test1.Locus_${i}*AA.fasta >> $file.AA.fasta; done < OrthoFinderTaxonList.txt ; done
