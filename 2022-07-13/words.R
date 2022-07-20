# クリア用関数の読み込み ********************************
setwd("/Users/wakatsukisho/Desktop/STC/ThirdGrade/FirstHalf/DataMining") # 作業用ディレクトリの設定
.myfunc.env = new.env()
sys.source( "myFunctions.R", envir = .myfunc.env )
attach(.myfunc.env )

# パッケージのインストール ******************************
install.packages("dplyr")
install.packages("stringr")
install.packages("koRpus.lang.en")
install.packages("readr")

# 作業用設定 ********************************************
setwd("/Users/wakatsukisho/Desktop/STC/ThirdGrade/FirstHalf/DataMining/2022-07-13/EN") # 作業用ディレクトリの設定
options(max.print=100000) # 最大出力行

# 使用パッケージ ****************************************
library(RMeCab)　# R用Mecab(形態要素解析エンジン)
library(dplyr) # 表型データの操作
library(stringr)　# 文字列操作
library(koRpus)　# TreeTagger(英語用の形態素解析ツール)をRで利用するためのパッケージ
library(koRpus.lang.en)

folder_name1 <- "./" #テキストファイル保存場所を指定(現在のディレクトリを指定)
csv_list <- list.files(pattern = "*.txt")
dir.create("tmp")                      #加工中データの書き出し先ディレクトリを作成
dir.create("result") 
folder_name2 <- "tmp"

#削除ワード(記号類)を指定する
delete_word1 <- c("[\\-,.!?_…・×、。「」]")      #不要な記号類
delete_word2 <- c("\\'s|\\'m|\\'re|\\'t|\\'ll") #MeCabがうまく扱えなかったもの


for (i in csv_list){
  i
  file_path1   <- paste(folder_name1, i, sep = "/") #入力用
  file_path2 <- paste(folder_name2, i, sep = "/") #加工中のテキストの入出力用
  #記号類をテキストから消す
  tmp1 <- scan(file_path1, what = "char", sep = "\n")
  tmp2 <- gsub("\\(.*?\\)|≪.*?≫", "", tmp1)    #括弧を中身ごと削除
  tmp3 <- tmp2 %>% 
    str_to_lower() %>%                     #アルファベットを全て小文字化
    str_replace_all(delete_word1, " ") %>% #空白に置き換える
    str_replace_all(delete_word2, " ") %>% 
    str_squish()                           #連続した空白を1つだけにする
  write(tmp3, file_path2)                        #MeCabにかける為に一旦書き出す
  tmp1
  tmp3
  #MeCabで解析する
  mixed_text1 <- RMeCabText(file_path2)
  mixed_text1[[1]][8]
  
  #英文を抜き出す
  mixed_df    <- as.data.frame(mixed_text1) %>% t()              #リストからデータフレームに変換後、列操作するために転置
  token_lemma <- data.frame(token = unname(mixed_df[, 1]), 
                            lemma = unname(mixed_df[, 8]))       #文中の単語列(token)と原形に直された単語列(lemma)からなるデータフレームを作成
  token       <- token_lemma$token[token_lemma$lemma == "*"] %>% 
    as.character()                                  #原形(lemma列)が"*"なのを英単語と判断してtoken列から文字列ベクトルを作成
  english_text1 <- paste(token, collapse = " ")                  #単語間をくっつけて文章形式にする
  english_text1[english_text1 == ""] <- "からっぽ"               #オブジェクトがc("")なら何かしら入れて、taggedText()のエラー回避
  english_text1
  
  kRp.env <- set.kRp.env(TT.cmd = "/Applications/TreeTagger/bin/tree-tagger", lang = "en") #TreeTaggerを使うための設定
  english_text2 <- taggedText(treetag(english_text1, treetagger = "manual", format = "obj", lang = "en", 
                                      TT.options = list(path = "/Applications/TreeTagger/", preset = "en"))) #TreeTaggerによる形態素解析
  english_text2
  typeof(english_text2[3,3])
  
  colnames(english_text2)[2] <- "単語"
  colnames(english_text2)[3] <- "品詞名"
  colnames(english_text2)[5] <- "文字数"
  colnames(english_text2)[11] <- "出現数"

  
  # txtファイルに結果を書き出す
  name <- paste("res_",i,sep="")
  path <- paste("result", name, sep = "/")
  write.csv( english_text2,path)
  
}

  