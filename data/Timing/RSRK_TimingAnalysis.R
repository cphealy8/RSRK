library(readxl)
library(ggplot2)

tdat <- read_excel('TimingData.xlsx')
tdat$nreps <- round((2/tdat$siglvl),1)
tdat$tpr <- tdat$runtime/(tdat$nreps)
tdat$ppframe <- tdat$npts/tdat$kframes
tdat$npix <- 10*tdat$rezx^2

fit <- lm(tpr ~ npts+kframes+rezx+nr,data=tdat)

layout(matrix(c(1,2,3,4),2,2)) # optional 4 graphs/page
plot(fit)

tdat$ptime <- predict.lm(fit,tdat)

#g1 <- ggplot(tdat,aes(x=ppframe/nr,y=runtime,color=nreps))+geom_point()
#print(g1)