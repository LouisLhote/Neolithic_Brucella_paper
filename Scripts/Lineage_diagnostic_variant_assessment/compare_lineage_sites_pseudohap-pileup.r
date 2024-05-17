args = commandArgs(trailingOnly=TRUE)

sample<-read.table(args[1])

colnames(sample)<-c("CHROM","POS","REF","OBSERVED")

lineages<-read.table(args[2],header=T,sep=" ")

colnames(lineages)<-c("CHROM", "POS", "REF.lin", "ALT.lin","LIN")

merged<-merge(sample, lineages)

print("Matching:")

nrow(merged[merged$OBSERVED == merged$LIN,])

print("Not matching:")

nrow(merged[merged$OBSERVED != merged$LIN,])
