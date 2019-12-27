## ----------------------------------- ASSIGNMENT --------------------------------------------- 
setwd("~/Data_Science_Course") #para setear el directorio de trabajo
getwd() #para ver cual es el directorio de trabajo fijado

#Loading Train Data
xtrain<-read.table("./Data/UCI HAR Dataset/train/X_train.txt")
ytrain<-read.table("./Data/UCI HAR Dataset/train/y_train.txt")
idtrain<-read.table("./Data/UCI HAR Dataset/train/subject_train.txt")
#Change y_train and subject_train names variables
names(ytrain)<-"id_activity"
names(idtrain)<-"id_subject"
#Merging y_train, subject_train and x_train (in that order) 
train_data<-cbind(idtrain,ytrain,xtrain)

#Loading Test Data
xtest<-read.table("./Data/UCI HAR Dataset/test/X_test.txt")
ytest<-read.table("./Data/UCI HAR Dataset/test/y_test.txt")
idtest<-read.table("./Data/UCI HAR Dataset/test/subject_test.txt")
names(ytest)<-"id_activity"
names(idtest)<-"id_subject"
#Merging y_test, subject_test and x_test (in that order) 
test_data<-cbind(idtest,ytest,xtest)

##1. Merging training data and test data
data_tt<-rbind(train_data,test_data)

##2. Extracting measurements on the mean and standard deviation
features<-read.table("./Data/UCI HAR Dataset/features.txt")
names(features)<-c("number","feature")
#Searching for using "grep"
msr<-grep("mean()|std()",features$feature)
msr_names<-grep("mean()|std()",features$feature,value = TRUE)
msr_freq<-grep("Freq",msr_names)
#Subsetting msr vector according to msr_freq values
msr<-msr[c(1:46,50:55,59:64,68:69,71:72,74:75,77:78)]

#Subsetting data according to msr values
msr<-msr+2 #adding 2 to adjust dimensions
data_tt<-data_tt[,c(1,2,msr)]

#3. Aplying descriptive activity names
activity<-read.table("./Data/UCI HAR Dataset/activity_labels.txt")
names(activity)<-c("id_activity","desc_activity")
data_tt<-merge(data_tt,activity,by.x = "id_activity",by.y = "id_activity")
data_tt<-data_tt[,c(1:2,69,3:68)]

#4. Aplying descriptive variable names
msr_names<-msr_names[c(1:46,50:55,59:64,68:69,71:72,74:75,77:78)]
msr_names<-gsub("-","_",msr_names)
msr_names<-gsub("\\()","",msr_names)
names(data_tt)[4:69]<-msr_names

#5. Creating independent tidy data set using aggregate function
data_mean<-aggregate(.~id_subject+id_activity+desc_activity, FUN="mean", data=data_tt)

write.table(data_tt,file = "tidy_data.txt", sep=" ")
write.table(data_mean,file = "tidy_data_mean.txt", sep=" ")
