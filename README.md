# Neolithic_Brucella_paper

This is the repository of the Brucella paper, will be filled

# We define the name of the reference the core genome has been prepared against
# and provide the path to the reference
# in this example, we use the  Brucella melitensis reference

REFN=melitensis
REF=/path/to/GCF_000007505.1_ASM750v1_genomic.fna

# we then create a set of sites with discriminate our lineage of interest
# in this example we use the lineage target melitensis, but we can extend to suis, canis, inopinata
# we can also look at lineage including two species e.g. for TARGET in melitensis-abortus, and modify the grep pattern to “melitensis\|abortus”
#the script creates a bed file of sites and a .out file of the variants defining the lineage
# the example core vcf is core_melitensis-aligned.vcf, and example .bed.gz and .out files are also given (melitensis-lineage_melitensis-ref_example.bed.gz and melitensis-lineage_melitensis-ref_example.bed.gz)


for TARGET in melitensis; do I=""; grep -m1 "#C" core_${REFN}-aligned.vcf | sed -e "s/\t/\n/g" > samples.vcf; for i in $( grep -n "$TARGET" samples.vcf | cut -f1 -d':'); do I=`echo ${I},${i}`; done; I=`echo $I | sed -e "s/^,//g"`; python2 extract_lineage_sites.py core_${REFN}-aligned.vcf $I > ${TARGET}-lineage_${REFN}-ref.out; awk '{print $1"\t"$2-1"\t"$2}' ${TARGET}-lineage_${REFN}-ref.out > ${TARGET}-lineage_${REFN}-ref.bed && bgzip -f ${TARGET}-lineage_${REFN}-ref.bed && tabix -p bed ${TARGET}-lineage_${REFN}-ref.bed.gz; done

#we then create a pileup for our sample bam of interest, aligned to the same reference
# here we only look at melitensis-defining variants but again could expand to look at abortus, suis, canis-suis etc
#we call pseudohaploid genotypes from the pileup file, producing a .pseudohap (example: mentese6_melitensis-lineage_melitensis-ref_example.pseudohap)
# and then compare called variants to the .out file using the R script compare_lineage_sites_pseudohap-pileup.r - this will output the number of pseudohaploid genotypes matching or not matching the lineage-defining variants

for TARGET in melitensis; do samtools mpileup -q 30 -Q 20 -B -f $REF -l test_${TARGET}.bed.gz ${BAMPATH}${BAM}.bam > ${TARGET}-lineage_${REFN}-ref_${BAM}.pileup; python2 pseudohaploidize_pileup.py ${TARGET}-lineage_${REFN}-ref_${BAM}.pileup > ${TARGET}-lineage_${REFN}-ref_${BAM}.pseudohap; Rscript compare_lineage_sites_pseudohap-pileup.r ${TARGET}-lineage_${REFN}-ref_${BAM}.pseudohap ${TARGET}-lineage_${REFN}-ref.out;  done
