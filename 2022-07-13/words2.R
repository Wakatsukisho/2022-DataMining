# 作業用設定 ********************************************
setwd("/Users/wakatsukisho/Desktop/STC/ThirdGrade/FirstHalf/DataMining/2022-07-13/EN") # 作業用ディレクトリの設定
options(max.print=100000) # 最大出力行
dir.create("formatted")
setwd("/Users/wakatsukisho/Desktop/STC/ThirdGrade/FirstHalf/DataMining/2022-07-13/EN/result") # 作業用ディレクトリの設定
txt_list <- list.files(pattern = "*.txt")


for(i in 1:length(txt_list)){
  j <- i
  n <- txt_list[j]
  p <- paste( "/Users/wakatsukisho/Desktop/STC/ThirdGrade/FirstHalf/DataMining/2022-07-13/EN/result",n,sep = "/")
  data <- read.csv(p,header = TRUE, sep=",")
  data
  data <- data[, c("単語","品詞名","文字数","出現数")]
  data
  
  path <- paste( "/Users/wakatsukisho/Desktop/STC/ThirdGrade/FirstHalf/DataMining/2022-07-13/EN/formatted/","formatted_",n,sep = "")
  write.csv(data,path)
  
}

