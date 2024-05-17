# Neolithic_Brucella_paper

This is the repository of the Brucella paper, will be filled

# Contents
- [Overview](#overview)
- [System Requirements](#System_Requirements)
- [Lineage/diagnostic variant assessment section, how to use the codes](#Lineage/diagnostic_variant_assessment_section,_how_to_use_the_scripts)

# Overview

# System Requirements

* python2    

* R 4.3.0  

* samtools 1.19.2

# Lineage/diagnostic variant assessment section, how to use the scripts

## Define reference
First, we need to define the name of the reference the core genome has been prepared against. And provide the path of the reference. In this example the reference is Brucella melitensis reference 

```
REFN=melitensis
REF=/path/to/GCF_000007505.1_ASM750v1_genomic.fna
```

## Create a set of discriminating sites
We then create a set of sites with discriminate our lineage of interest. In this example we use the lineage target melitensis, but we can extend to suis, canis, inopinata. We can also look at lineage including two species e.g. for TARGET in melitensis-abortus, and modify the grep pattern to “melitensis\|abortus”. 
The script creates a bed file of sites and a .out file of the variants defining the lineage. The example core vcf is core_melitensis-aligned.vcf.gz, and example .bed.gz and .out files are also given (melitensis-lineage_melitensis-ref_example.bed.gz and melitensis-lineage_melitensis-ref_example.bed.gz in Examples_data section)

```
for TARGET in melitensis; do I=""; grep -m1 "#C" core_${REFN}-aligned.vcf | sed -e "s/\t/\n/g" > samples.vcf; for i in $( grep -n "$TARGET" samples.vcf | cut -f1 -d':'); do I=`echo ${I},${i}`; done; I=`echo $I | sed -e "s/^,//g"`; python2 extract_lineage_sites.py core_${REFN}-aligned.vcf $I > ${TARGET}-lineage_${REFN}-ref.out; awk '{print $1"\t"$2-1"\t"$2}' ${TARGET}-lineage_${REFN}-ref.out > ${TARGET}-lineage_${REFN}-ref.bed && bgzip -f ${TARGET}-lineage_${REFN}-ref.bed && tabix -p bed ${TARGET}-lineage_${REFN}-ref.bed.gz; done
```


## Extract pseudohaploid genotypes matching or not matching the lineage-defining variants
We then create a pileup for our sample bam of interest, aligned to the same reference. Here we only look at melitensis-defining variants but again could expand to look at abortus, suis, canis-suis etc. We call pseudohaploid genotypes from the pileup file, producing a .pseudohap (Example: mentese6_melitensis-lineage_melitensis-ref_example.pseudohap), and then compare called variants to the .out file using the R script compare_lineage_sites_pseudohap-pileup.r - this will output the number of pseudohaploid genotypes matching or not matching the lineage-defining variants

```
for TARGET in melitensis; do samtools mpileup -q 30 -Q 20 -B -f $REF -l test_${TARGET}.bed.gz ${BAMPATH}${BAM}.bam > ${TARGET}-lineage_${REFN}-ref_${BAM}.pileup; python2 pseudohaploidize_pileup.py ${TARGET}-lineage_${REFN}-ref_${BAM}.pileup > ${TARGET}-lineage_${REFN}-ref_${BAM}.pseudohap; Rscript compare_lineage_sites_pseudohap-pileup.r ${TARGET}-lineage_${REFN}-ref_${BAM}.pseudohap ${TARGET}-lineage_${REFN}-ref.out;  done
```




