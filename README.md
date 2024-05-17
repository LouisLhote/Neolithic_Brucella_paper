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

# we then create a set of sites with discriminate our lineage of interest
# in this example we use the lineage target melitensis, but we can extend to suis, canis, inopinata
# we can also look at lineage including two species e.g. for TARGET in melitensis-abortus, and modify the grep pattern to “melitensis\|abortus”
#the script creates a bed file of sites and a .out file of the variants defining the lineage
# the example core vcf is core_melitensis-aligned.vcf, and example .bed.gz and .out files are also given (melitensis-lineage_melitensis-ref_example.bed.gz and melitensis-lineage_melitensis-ref_example.bed.gz)


