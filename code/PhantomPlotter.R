library(readxl)
library(tibble)
library(ggplot2)

##### Associated Avoiding Random #####
data <- read_excel("D:/RSRK/RSRK/data/Phantoms/AssociatedAvoidingRandom.xlsx")
## Create Significance Group
data$SigLvl = "NS"
data$SigLvl[data$G>data$ups]="+*"
data$SigLvl[data$G>data$upss]="+**"
data$SigLvl[data$G<data$lows]="-*"
data$SigLvl[data$G<data$lowss]="-**"
data$SigLvl<-factor(data$SigLvl,levels=c("-**","-*","NS","+*","+**"))


## Graph
sz <- 7.4861/3
g2 <- ggplot(data,aes(x=r,y=G,color=SigLvl,shape=Group,group=Group))+
  annotate("segment",x=0,xend=50,y=0,yend=0,colour="black",size=1.0)+
  geom_point(size=1)+geom_line(size=0.5)+scale_y_continuous(limits=c(-10,3))+
  scale_color_brewer(palette="Set1",direction=-1)+
  theme_bw()+
  theme(text = element_text(size=8),legend.position=c(0.8,0.5),legend.title=element_text(size=6),legend.text=element_text(size=6))
g2

print(g2)
ggsave('../results/Phantoms/AssociatedAvoidingRandom.pdf',width=sz,height=sz,units="in")




##### Uniform #####
rm(data)
rm(g2)
data <- read_excel("D:/RSRK/RSRK/data/Phantoms/UniformCombined.xlsx")
## Create Significance Group
data$SigLvl = "NS"
data$SigLvl[data$G>data$ups]="+*"
data$SigLvl[data$G>data$upss]="+**"
data$SigLvl[data$G<data$lows]="-*"
data$SigLvl[data$G<data$lowss]="-**"
data$SigLvl<-factor(data$SigLvl,levels=c("-**","-*","NS","+*","+**"))
data$Disp <-as.factor(data$Disp)

## Graph
sz <- 7.4861/3
g2 <- ggplot(data,aes(x=r,y=G,color=SigLvl,shape=Disp,group=Disp))+
  annotate("segment",x=0,xend=50,y=0,yend=0,colour="black",size=1.0)+
  geom_point(size=1)+geom_line(size=0.5)+scale_y_continuous(limits=c(-12,3))+
  scale_color_brewer(palette="Set1",direction=-1)+
  theme_bw()+
  theme(text = element_text(size=8),legend.position=c(0.8,0.5),legend.title=element_text(size=6),legend.text=element_text(size=6))
g2

print(g2)
ggsave('../results/Phantoms/UniformTest.pdf',width=sz,height=sz,units="in")




##### SelfExpression&HigherPatterns #####
data <- read_excel("D:/RSRK/RSRK/data/Phantoms/SelfExpression&HigherPatterns.xlsx")
## Create Significance Group
data$SigLvl = "NS"
data$SigLvl[data$G>data$ups]="+*"
data$SigLvl[data$G>data$upss]="+**"
data$SigLvl[data$G<data$lows]="-*"
data$SigLvl[data$G<data$lowss]="-**"
data$SigLvl<-factor(data$SigLvl,levels=c("-**","-*","NS","+*","+**"))


## Graph
sz <- 7.4861/3
g2 <- ggplot(data,aes(x=r,y=G,color=SigLvl,shape=Group,group=Group))+
  annotate("segment",x=0,xend=50,y=0,yend=0,colour="black",size=1.0)+
  geom_point(size=1)+geom_line(size=0.5)+scale_y_continuous(limits=c(-0.75,2.5))+
  scale_color_brewer(palette="Set1",direction=-1)+
  theme_bw()+
  theme(text = element_text(size=8),legend.position=c(0.8,0.5),legend.title=element_text(size=6),legend.text=element_text(size=6))
g2

print(g2)
ggsave('../results/Phantoms/SelfExpression&HigherPatterns.pdf',width=sz,height=sz,units="in")




##### ClusterSize #####
rm(data)
rm(g2)
data <- read_excel("D:/RSRK/RSRK/data/Phantoms/ClusterSize.xlsx")
## Create Significance Group
data$SigLvl = "NS"
data$SigLvl[data$G>data$ups]="+*"
data$SigLvl[data$G>data$upss]="+**"
data$SigLvl[data$G<data$lows]="-*"
data$SigLvl[data$G<data$lowss]="-**"
data$SigLvl<-factor(data$SigLvl,levels=c("-**","-*","NS","+*","+**"))
data$Radius<-as.factor(data$Radius)

## Graph
sz <- 7.4861/3
g2 <- ggplot(data,aes(x=r,y=G,color=SigLvl,shape=Radius,group=Radius))+
  annotate("segment",x=0,xend=50,y=0,yend=0,colour="black",size=1.0)+
  geom_point(size=1)+geom_line(size=0.5)+scale_y_continuous(limits=c(0,4))+
  scale_color_brewer(palette="Set1",direction=-1)+
  theme_bw()+
  theme(text = element_text(size=8),legend.position=c(0.8,0.5),legend.title=element_text(size=6),legend.text=element_text(size=6))
g2

print(g2)
ggsave('../results/Phantoms/ClusterSize.pdf',width=sz,height=sz,units="in")




##### MaskedTest #####
rm(data)
rm(g2)
data <- read_excel("D:/RSRK/RSRK/data/Phantoms/MaskedTest.xlsx")
## Create Significance Group
data$SigLvl = "NS"
data$SigLvl[data$G>data$ups]="+*"
data$SigLvl[data$G>data$upss]="+**"
data$SigLvl[data$G<data$lows]="-*"
data$SigLvl[data$G<data$lowss]="-**"
data$SigLvl<-factor(data$SigLvl,levels=c("-**","-*","NS","+*","+**"))
data$grp <- paste(data$Group,data$Type)

## Graph
sz <- 7.4861/3
g2 <- ggplot(data,aes(x=r,y=G,color=SigLvl,shape=grp,group=grp))+
  annotate("segment",x=0,xend=50,y=0,yend=0,colour="black",size=1.0)+
  geom_point(size=1)+geom_line(size=0.5)+scale_y_continuous(limits=c(-13,1.5))+
  scale_color_brewer(palette="Set1",direction=-1)+
  theme_bw()+
  theme(text = element_text(size=8),legend.position=c(0.8,0.5),legend.title=element_text(size=6),legend.text=element_text(size=6))
g2

print(g2)
ggsave('../results/Phantoms/MaskedTest.pdf',width=sz,height=sz,units="in")




##### SensitivityTest #####
rm(data)
rm(g2)
data <- read_excel("D:/RSRK/RSRK/data/Phantoms/SensitivityCombined.xlsx")
## Create Significance Group
data$SigLvl = "NS"
data$SigLvl[data$G>data$ups]="+*"
data$SigLvl[data$G>data$upss]="+**"
data$SigLvl[data$G<data$lows]="-*"
data$SigLvl[data$G<data$lowss]="-**"
data$SigLvl<-factor(data$SigLvl,levels=c("-**","-*","NS","+*","+**"))
data$`Density A` <- as.factor(data$`Density A`)
data$`Density B` <- as.factor(data$`Density B`)
data$Group <- paste(data$`Density A`,data$`Density B`)

## Graph
sz <- 7.4861/3
g2 <- ggplot(data,aes(x=r,y=G,color=SigLvl,shape=Group,group=Group))+
  annotate("segment",x=0,xend=50,y=0,yend=0,colour="black",size=1.0)+
  geom_point(size=1)+geom_line(size=0.5)+scale_y_continuous(limits=c(-4,1))+
  scale_color_brewer(palette="Set1",direction=-1)+
  theme_bw()+
  theme(text = element_text(size=8),legend.position=c(0.8,0.5),legend.title=element_text(size=6),legend.text=element_text(size=6))
g2

print(g2)
ggsave('../results/Phantoms/SensitivityTest.pdf',width=sz,height=sz,units="in")
