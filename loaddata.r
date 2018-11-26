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
  
ChaCo <- read.csv(paste('ChaCoNew', asz, '.txt', sep = ""), header = T)
ChaCo$Region <- as.factor(labels[ChaCo$Region])
ChaCo<-droplevels(ChaCo[!ChaCo$Region %in% c('Cerebellum_Cortex_L', 'Cerebellum_Cortex_R', 'Accumbens_area_L', 'Accumbens_area_R', 'Hypothalamus_L', 'Hypothalamus_R'),])

names(cortical)[c(1,2)]<-names(ChaCo)[c(1,2)]
  

data<-merge(clinical, cortical)
data<-merge(data, ChaCo)

last<-function(s){return(substr(s, nchar(s),nchar(s)))}

rois<-unique(data$Region[last(as.character(data$Region)) != "L"])
d<-data[data$Region %in% rois,]
require(ggplot2)
ggplot(d, aes(x=ChaCo_mean, y=quotient, color=Region))+
  geom_point()+
  geom_smooth(method="lm", se=F)+
  guides(color=F)
# facet_wrap(.~Region, scales = "free")

require(ggeffects)
fit<-lm(NIHSS~volume+(ChaCo_mean+quotient)*Region, data=d)
anova(fit)
plot(ggpredict(fit, terms = c("ChaCo_mean","Region")), facets = T, rawdata = T)+

require(nlme)
fit<-lme(ChaCo_mean~volume+quotient-1, random=~quotient-1|Region, data=d, control=lmeControl(opt="optim",singular.ok=TRUE, returnObject=TRUE))
summary(fit)
plot(ggpredict(fit, facets = T, rawdata = T))
intervals(fit)
plot(ranef(fit))


lm.full<-lme(lighttouch~ChaCo_mean+log(volume)+quotient, random=~1+ChaCo_mean+quotient|Region, data=d, control=lmeControl(opt="optim",singular.ok=TRUE, returnObject=TRUE), method = "ML")
lm.null<-lme(lighttouch~log(volume)+quotient, random=~1+quotient|Region, data=d, control=lmeControl(opt="optim",singular.ok=TRUE, returnObject=TRUE), method = "ML")
anova(lm.full, lm.null)
summary(lm.full)
intervals(lm.full, which = "all")
plot(lm.full)
qqnorm(resid(lm.full))

require(car)
for(roi in rois){
  d<-subset(data,Region==roi)
  d<-d[!duplicated(d),]
  if(max(d$quotient)==0){next()}
  m<-lm(lighttouch~log(volume)+ChaCo_mean+quotient, data=d)
  s<-summary(m)
  p<-s$coefficients['ChaCo_mean','Pr(>|t|)']
  if(p<0.05){
    print(roi);
    print(s);
    avPlots(m)
  }
}


require(ridge)
lr<-linearRidge(lighttouch~log(volume)+ChaCo_mean+quotient, data=d)
summary(lr)
plot(lr)


require(pls)
pcr_model <- pcr(NIHSS~log(volume)+ChaCo_mean+quotient, data=d, scale = TRUE, validation = "CV")
summary(pcr_model)
dev.off()
validationplot(pcr_model)
validationplot(pcr_model, val.type="MSEP")
validationplot(pcr_model, val.type="R2")
predplot(pcr_model)
