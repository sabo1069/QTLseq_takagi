##############################################################
Arg<-commandArgs(TRUE)
data_snp<- c(Arg[1])
data_sliding<- c(Arg[2])
##############################################################
SNP_INDEX<-read.table(data_snp,header=F, as.is=TRUE, quote="", comment.char="", sep="\t")
WINDOW_AVE<-read.table(data_sliding,header=F, quote="", comment.char="", sep="\t")


chr<-unique(WINDOW_AVE$V1)
max_x_axis<-max(SNP_INDEX$V2/1000000)
number_colom_for_graph<-ceiling(length(chr)/5)
out_put_A=paste("./graph_bulkB_",data_sliding,".pdf",sep="")
pdf(file=out_put_A,width=150,height=150)
par(mfcol=c(5, number_colom_for_graph))
par(lwd=15,bty="l",tck = -0.02)
par(xaxs="i", yaxs="i")
par(mar = c(30, 30,15, 10));
par(mgp = c(18,18,10))
for (chr_number in chr){
	
		key_a<-WINDOW_AVE[WINDOW_AVE$V1==chr_number,]
		key_b<-SNP_INDEX[SNP_INDEX$V1==chr_number,]		
		
		plot (key_b$V2/1000000,key_b$V7,xlim=c(0, max_x_axis),ylim=c(0,1.01),xaxt="n",yaxt="n",cex=8,type="p", pch=20,ps=5,col="goldenrod2",xlab="",ylab="")
		abline(h=0.5, lty=3,lwd=10)
		
		
		par(new=T)		
		
		plot (key_a$V2/1000000,key_a$V14,type="l",lwd=20,col="gray63",xlim=c(0, max_x_axis),ylim=c(0,1.01),xaxt="n",yaxt="n",xlab="",ylab="")
		par(new=T)		
		plot (key_a$V2/1000000,key_a$V15,type="l",lwd=20,col="gray63",xlim=c(0, max_x_axis),ylim=c(0,1.01),xaxt="n",yaxt="n",xlab="",ylab="")




		#par(new=T)		
		#plot (key_a$V2/1000000,key_a$V16,type="l",lwd=7,col="darkgoldenrod2",xlim=c(0, max_x_axis),ylim=c(0,1), cex.axis = 1,cex.lab=1,xlab="chr position (Mb)",ylab="SNP index",mgp=c(4,1.5,0),xaxt="n",yaxt="n",)
		#par(new=T)		
		#plot (key_a$V2/1000000,key_a$V17,type="l",lwd=7,col="darkgoldenrod2",xlim=c(0, max_x_axis),ylim=c(0,1), cex.axis = 1,cex.lab=1,xlab="chr position (Mb)",ylab="SNP index",mgp=c(4,1.5,0),xaxt="n",yaxt="n",)
		
		par(new=T)
	
		plot (key_a$V2/1000000,key_a$V4,type="l",lwd=20,col="red",xlim=c(0, max_x_axis),ylim=c(0,1.01),cex.lab=10,main=print(chr_number),cex.main =12,xlab="chr position (Mb)",ylab="SNP index",xaxt="n",yaxt="n",)
		axis(2, lwd=15,mgp=c(5,8,0),yaxp=c(0,1,4), cex.axis = 8)
     	axis(1, lwd=15,mgp=c(6,10,0), cex.axis = 8)		
		

}
warnings()
dev.off()

