# Neolithic_Brucella_paper

This is the repository of the Brucella paper, will be filled

# Contents
# Overview
# System Requirements


# Lineage/diagnostic variant assessment section, how to use the codes

First, we need to define the name of the reference the core genome has been prepared against. And provide the path of the reference. In this example the reference is Brucella melitensis reference 

```
REFN=melitensis
REF=/path/to/GCF_000007505.1_ASM750v1_genomic.fna
```

We then create a set of sites with discriminate our lineage of interest. In this example we use the lineage target melitensis, but we can extend to suis, canis, inopinata. We can also look at lineage including two species e.g. for TARGET in melitensis-abortus, and modify the grep pattern to “melitensis\|abortus”. 
The script creates a bed file of sites and a .out file of the variants defining the lineage. The example core vcf is core_melitensis-aligned.vcf, and example .bed.gz and .out files are also given (melitensis-lineage_melitensis-ref_example.bed.gz and melitensis-lineage_melitensis-ref_example.bed.gz in Examples_data section)
```
for TARGET in melitensis; do I=""; grep -m1 "#C" core_${REFN}-aligned.vcf | sed -e "s/\t/\n/g" > samples.vcf; for i in $( grep -n "$TARGET" samples.vcf | cut -f1 -d':'); do I=`echo ${I},${i}`; done; I=`echo $I | sed -e "s/^,//g"`; python2 extract_lineage_sites.py core_${REFN}-aligned.vcf $I > ${TARGET}-lineage_${REFN}-ref.out; awk '{print $1"\t"$2-1"\t"$2}' ${TARGET}-lineage_${REFN}-ref.out > ${TARGET}-lineage_${REFN}-ref.bed && bgzip -f ${TARGET}-lineage_${REFN}-ref.bed && tabix -p bed ${TARGET}-lineage_${REFN}-ref.bed.gz; done
```

