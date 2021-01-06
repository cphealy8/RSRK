dat <- read.csv("Compiled Platelet Data.csv")
library(ggplot2)

g1 <- ggplot(dat,aes(x=Age,y=MPV))+
  geom_jitter(width=0.5)+
  facet_grid(.~sex)+
  geom_smooth(method='lm')
print(g1)

g2 <- ggplot(dat,aes(x=Age,y=PLT))+
  geom_jitter(width=0.5)+
  facet_grid(.~sex)+
  geom_smooth(method='lm')

print(g2)


#RSQ data
dat.lm = lm(Age~PLT,data=dat);

RSS <- c(crossprod(dat.lm$residuals))
MSE <- RSS/ length(dat.lm$residuals)
RMSE <- sqrt(MSE)

RSQ <-summary(dat.lm)$r.squared 

