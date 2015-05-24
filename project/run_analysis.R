setwd("~/GitHub/getting-n-cleaning-data/project")

# ---------------------------
# read generic data
features <- read.table("./UCI HAR Dataset/features.txt")
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
names(activities) <- c("V1", "Activity")

#read test data
test_set <- read.table("./UCI HAR Dataset/test/X_test.txt")
#assign descriptive names to columns
names(test_set) <- features$V2
test_subject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
names(test_subject) <- "Subject"
test_labels <- read.table("./UCI HAR Dataset/test/y_test.txt")
#combine activities with test entries
test_merge <- merge(activities, test_labels, by="V1")
names(test_merge) <- c("Index", "Activity")
test_merge <- cbind(test_merge, test_subject, test_set)

# print(names(test_merge))

#read train data
train_set <- read.table("./UCI HAR Dataset/train/X_train.txt")
#assign descriptive names to columns
names(train_set) <- features$V2
train_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
names(train_subject) <- "Subject"
train_labels <- read.table("./UCI HAR Dataset/train/y_train.txt")
#combine activities with train entries
train_merge <- merge(activities, train_labels, by="V1")
names(train_merge) <- c("Index", "Activity")
train_merge <- cbind(train_merge, train_subject, train_set)

# print(names(train_merge))

test_rbind <- rbind(train_merge, test_merge)
# ---------------------------

# identify descriptive columns that have mean or std in the name
vars <- features$V2[grepl("mean|std", features$V2)]
# melt the data frame
dataMelt <- melt(test_rbind,id=c("Index", "Activity", "Subject"),measure.vars=vars)
# cast it back out for activity & subject, calculating the mean
dataCast <- dcast(dataMelt, Activity + Subject ~ variable, mean)
print(dataCast)
testCast <- dcast(dataMelt, Activity + Subject ~ "tBodyAcc-mean()-X", mean)
testCast2 <- dcast(dataMelt,  Subject + Activity ~ "tBodyAcc-mean()-X", mean)


write.table(dataCast, file="./output.txt", row.name=FALSE) 
