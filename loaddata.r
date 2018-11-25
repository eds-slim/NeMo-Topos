asz<-86

labels<- read.table(paste('./labels', asz, '.txt', sep = ''))
labels<-labels$V1

clinical<-read.csv('./ClinicalData/clinicaldata.txt', header = T)

cortical<-read.csv(paste('./liste_right_', asz, '.txt', sep = ''), header = TRUE, sep = ' ')

tidyroiID<-function(s){
  s<-substr(s,8,nchar(s)-7)
  x<-strsplit(s,"-")
  if(x[[1]][1] %in% c("left","lh")){
    hemi<-"L"
  }else{
    hemi<-"R"
  };
  u<-paste(toupper(substring(x[[1]][2], 1, 1)), substring(x[[1]][2], 2), sep = "", collapse = " ");
  return(paste(u,hemi,sep = "_"));
} 


cortical$roi.ID <- as.factor(unlist(lapply(as.character(cortical$roi.ID),tidyroiID)))
  
ChaCo <- read.csv(paste('ChaCo', asz, '_right.txt', sep = ""), header = T)
ChaCo$Region <- as.factor(labels[ChaCo$Region])
ChaCo<-droplevels(ChaCo[!ChaCo$Region %in% c('Cerebellum_Cortex_L', 'Cerebellum_Cortex_R', 'Accumbens_area_L', 'Accumbens_area_R', 'Hypothalamus_L', 'Hypothalamus_R'),])

names(cortical)[c(1,2)]<-names(ChaCo)[c(1,2)]
  

data<-merge(clinical, cortical)
data<-merge(data, ChaCo)

last<-function(s){return(substr(s, nchar(s),nchar(s)))}

d<-data[last(as.character(data$Region)) != "L",]
require(ggplot2)
ggplot(d, aes(x=ChaCo_mean, y=volOverlap, color=Region))+
  geom_point()+
  geom_smooth(method="lm", se=F)+
  guides(color=F)
# facet_wrap(.~Region, scales = "free")

require(ggeffects)
fit<-lm(NIHSS~volume+(ChaCo_mean+quotient)*Region, data=d)
anova(fit)
plot(ggpredict(fit, terms = c("ChaCo_mean","Region")), facets = T, rawdata = T, scales="free")+
  scale_colour_grey()

require(nlme)
fit<-lme(ChaCo_mean~volume+quotient-1, random=~quotient-1|Region, data=d, control=lmeControl(opt="optim",singular.ok=TRUE, returnObject=TRUE))
summary(fit)
plot(ggpredict(fit, facets = T, rawdata = T))
intervals(fit)
plot(ranef(fit))


lm.full<-lme(lighttouch~ChaCo_mean+log(volume)+quotient, random=~1|Region, data=d, control=lmeControl(opt="optim",singular.ok=TRUE, returnObject=TRUE), method = "ML")
lm.null<-lme(lighttouch~log(volume)+quotient, random=~1|Region, data=d, control=lmeControl(opt="optim",singular.ok=TRUE, returnObject=TRUE), method = "ML")
anova(lm.full, lm.null)

plot(lm.full)
