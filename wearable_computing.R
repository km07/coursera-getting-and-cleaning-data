wearableComp<-function(){
        target_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        zip_localfile = "wearable_comp.zip"
        data_dir="UCI HAR Dataset"
        if (!file.exists(data_dir)) {
                download.file(target_url, zip_localfile) 
                library(tools)       # for md5 checksum
                sink("download_metadata.txt")
                print("Download date:")
                print(Sys.time() )
                print("Download URL:")
                print(target_url)
                print("Downloaded file Information")
                print(file.info(target_localfile))
                print("Downloaded file md5 Checksum")
                print(md5sum(target_localfile))
                sink()
                unzip(zip_localfile)
        }
                print("Data is ready")
        
        ##Read test & training data sets
        testD<-read.table("UCI HAR Dataset/test/X_test.txt")
        print("Test data is read")
        trainD<-read.table("UCI HAR Dataset/train/X_train.txt")
        print("Training data is read")
        
        ##Read meaningful column names as characters
        features<-read.table("UCI HAR Dataset/features.txt")
        col<-as.character(features[, 2])
                
        ##Apply meaningful column names do test & trainning data sets
        colnames(testD) <- col
        colnames(trainD) <- col
        print("Column names are changed")
        
        ##Keep only Column names for mean() and std() 
        mean_set<-subset(col, grepl("mean()",col))
        std_set<-subset(col, grepl("std()",col))
        my_set<-c(mean_set,std_set)
        testD<-testD[ ,my_set]
        trainD<-trainD[ ,my_set]
        print("Subsets of test & training data are created")
        
        ##read activities
        activities_labels<-read.table("UCI HAR Dataset/activity_labels.txt")
        activities_labels<-as.character(activities_labels$V2)
        print("Activity names are read")
        
        ##add activities column to test data set
        act<-read.table("UCI HAR Dataset/test/y_test.txt")
        activities<-activities_labels[act$V1]
        ##temporary name of the column is 'ax'
        testD$ax <- activities    
        testD$ax<-factor(testD$ax)
        print("Activities column is added to test data set as factors")
        
        ##add activities column to train data set
        act<-read.table("UCI HAR Dataset/train/y_train.txt")
        activities<-activities_labels[act$V1]
        ##temporary name of the column is 'ax'
        trainD$ax <- activities  
        trainD$ax<-factor(trainD$ax)
        print("Activities column is added to train data set as factors")
        
        ##add subject column to test data set
        subject<-read.table("UCI HAR Dataset/test/subject_test.txt")
        testD$subject<-subject$V1
        testD$subject <- factor(testD$subject)
        print("Subject column is added to test data set as factors")
        
        ##add subject column to train data set
        subject<-read.table("UCI HAR Dataset/train/subject_train.txt")
        trainD$subject<-subject$V1
        trainD$subject <- factor(trainD$subject)
        print("Subject column is added to train data set as factors")
        
        ##merge these two data sets
        print(dim(testD))
        print(dim(trainD))
        a<-rbind(testD,trainD)
        
        ##editing variables
        
        ##all letters to lower case
        colnames(a)<-tolower(names(a))
        
        ##update variables to be more descriptive
        
        ##first t update to time-
        colnames(a)<-sub("tbody","timebody",names(a))
        colnames(a)<-sub("tgravity","timegravity",names(a))
        
        ##first f update to frequency-
        colnames(a)<-sub("fbody","frequencybody",names(a))
        colnames(a)<-sub("fgravity","frequencygravity",names(a))
        
        ##eliminate double body name
        colnames(a)<-sub("bodybody","body",names(a))
        
        ##update acc to acceleration
        colnames(a)<-sub("acc","acceleration",names(a))
        
        ##update gyro to gyroscope
        colnames(a)<-sub("gyro","gyroscope",names(a))
        
        ##update mag to magnitude
        colnames(a)<-sub("mag","magnitude",names(a))
        
        ##change last column named 'ax' into 'activity'
        colnames(a)<-sub("ax","subjectactivity",names(a))
        
        ##eliminate "-" character
        colnames(a)<-sub("-","",names(a))
        
        ## create tidy data
        c<-aggregate( a, by=list(activity=a$subjectactivity, subject=a$subject),  FUN=mean,na.rm=TRUE )
        write.table(c, "tidy.txt", sep="\t")
}
