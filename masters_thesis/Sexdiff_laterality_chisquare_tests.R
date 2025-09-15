#create a table and then plot the table contents
#sex differences
library(ggplot2)
mytab <- table(mydata$sex,mydata$avg_responder_status)
mytab

mydata$responder_status <- factor(mydata$avg_responder_status)
chisq.test(mytab)#chisq test of independence
fisher.test(mytab)#with low sample sizes chisq is only an estimate so running fisher's test helps to give additional certainty
myplot<-- barplot(mytab,beside = TRUE,col=c("pink","lightblue"),
                  ylab = "Count", cex.lab = 2, font = 1.5,
                  legend.text = FALSE) #args.legend = list(x = "topright",inset = c(0, -1)))

myplot +
  scale_x_discrete(limits = desired_order)#doesn't work

#median split responder groups
mytab2 <- table(mydata$sex,mydata$median_split)
mytab2
mydata$median_split <- factor(mydata$median_split,levels = c("NR", "R"))

mydata$median_split <- factor(mydata$median_split,levels = c("NR", "R"))
chisq.test(mytab2)#chisq test of independence
fisher.test(mytab2)#with low sample sizes chisq is only an estimate so running fisher's test helps to give additional certainty

myplot<-- barplot(mytab2,beside = TRUE,col=c("red","darkblue"), ylab = "Count",
                  legend.text = TRUE,args.legend = list(x = "topright",
                                                        inset = c(0, -1)))
myplot +
  scale_x_discrete(limits = c("NR", "R"))





#laterality effect
laterality<- table(mydata$stim_hemisphere, mydata$responder_status)
laterality
chisq.test(laterality)
fisher.test(laterality)
myplot<-- barplot(laterality, beside = TRUE,  ylab = "Count",
        col=c("purple","lightblue", "darkblue"),
        legend.text = TRUE, args.legend = list(x = "topright",
                 inset = c(0, -1)))
myplot +
        scale_x_discrete(limits = c("anti-responder", "non-responder", 'moderate responder', 'strong responder'))
