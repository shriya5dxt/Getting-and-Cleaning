#Load dplyr and data table packages.
library(dplyr)
library(data.table)

#Loads features and activity labels
features<-read.table("features.txt",col.names = c("m","functions"))
activities<-read.table("activity_labels.txt",col.names = c("n","activity"))

#Load the test dataset
subjects<-rbind(read.table("subject_train.txt",col.names = "subject"),read.table("subject_test.txt",col.names = "subject"))
x1<-read.table("X_train.txt",col.names = features$m)
x2<-read.table("X_test.txt",col.names=features$m)

#merging training and test datasets
x<-rbind(x1,x2)
y1<-read.table("Y_train.txt",col.names = "n")
y2<-read.table("Y_test.txt",col.names = "n")

#merging training and test datasets
y<-rbind(y1,y2)
activities<-read.table("activity_labels.txt",col.names = c("n","activity"))
merged<-cbind(subjects,x,y)

#Adding column names to each variable 
names(x) <- as.character(transpose(features))
names(y) <- c("activity")
names(subjects) <- c("subject")

#Uses descriptive activity names to name the activities in the data set
tidy<-merged%>% select(subject,n,contains("mean"),contains("std"))
tidy$n<-activities[tidy$n,2]
tidy$n<-factor(tidy$n)
tidy$n<-activities[tidy$n,2]

#Appropriately label the dataset 
names(tidy)[2]<-"activity"
names(tidy) <- gsub("^t", "Time", names(tidy))
names(tidy) <- gsub("^f", "Frequency", names(tidy))
names(tidy) <- gsub("Acc", "Accelerometer", names(tidy))
names(tidy) <- gsub("Gyro", "Gyroscope", names(tidy))
names(tidy) <- gsub("Mag", "Magnitude", names(tidy))
names(tidy) <- gsub("-mean", "Mean", names(tidy))
names(tidy) <- gsub("-std", "STD", names(tidy))
names(tidy) <- gsub("BodyBody", "Body", names(tidy))

#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
merged <- merged %>% group_by(subject, n) %>% summarize_all(mean)
write.table(merged, "Data.txt", row.name=FALSE)

