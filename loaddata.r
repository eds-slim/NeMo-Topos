asz<-86

labels<- read.table(paste('./labels', asz, '.txt', sep = ''))
labels<-labels$V1


data<-read.csv(paste('./liste_right_', asz, '.txt', sep = ''), header = TRUE, sep = ' ')
