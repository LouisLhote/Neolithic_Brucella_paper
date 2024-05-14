args = commandArgs(trailingOnly=TRUE)

sample<-read.table(args[1])

colnames(sample)<-c("CHROM","POS","REF","OBSERVED")

lineages<-read.table(args[2],header=T,sep=" ")

colnames(lineages)<-c("CHROM", "POS", "REF.lin", "ALT.lin","LIN")

merged<-merge(sample, lineages)

nrow(merged[merged$OBSERVED == merged$LIN,])

nrow(merged[merged$OBSERVED != merged$LIN,])
