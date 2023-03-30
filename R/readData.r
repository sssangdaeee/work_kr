## TODO
# colname conversion
# select key fields
# fields to be added - statementdate, cedingcompany, 
# data type conversion - date, numeric with decimal points 
# mapping where needed -- create mapping parameter file
# reconciliation

## preview of the prudential inforce data
library(readxl)

rm(list=ls())
setwd("/home/share/overseas_life/1_North_America/6_project/client_data_sample_checks")
datadir <- "/home/share/overseas_life/1_North_America/6_project/client_data_sample_checks/0.data/primerica/claim/KOR CAN/"

field_param <- read_excel("/home/share/overseas_life/1_North_America/6_project/client_data_sample_checks/5.parameter/primerica_claim_param.xlsx")
treaty_mapping <- read.csv("../../5_parameter/treaty_mapping/treaty_mapping_table_claim_client.csv")
column_n <- c('pfs_operating_co',	'claimnumber',	'claim_version',	'bill_version',	'policynumber',	'deceased_name',	'insured_name',	'birthdate',	'gender',	'relation_to_primary',	
              'notifydate',	'date_of_death',	'claim_status',	'rein_code',	'rating_present',	'contest_code',	'death_code',	'bill_date',	'issue_date',	'treaty_code',	
              'total_coverage',	'total_benefit_paid',	'total_interet_paid',	'insured_issue_state',	'total_benefit',	'total_state_interest',	'total_legal_investing',	'ceded_total_amount',	'ceded_base_coverage',	'ceded_rider_amount',	
              'ceded_state_interest',	'ceded_investing_expense',	'ceded_legal_expense',	'paid_status', 'last4', 'company')


# Find all .txt files
files <- dir(datadir, recursive=TRUE, full.names=FALSE, pattern="\\.txt$")

# Convert the type
convert <- function(df){
  
  if(length(df) <= 1){
      return(NULL)
  } else {
    df <- df %>% mutate(across(c(2, 5, 6, 7, 9, 14, 15, 16, 17, 24, 35, 36), as.character),
                        across(c(1, 3, 4, 10, 13, 20), as.integer),
                        across(c(21, 22, 23, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34), as.numeric),
                        across(c(8, 11, 12, 18, 19), ifelse(grepl("/", .[8]), mdy, ymd)))
  }
}

split_df <- function(file_name){
  # df1 == \t 로 분리되는 테이블, df2는 탭으로 분리되지 않아 위치로 분리해야함.
  df <- readLines(paste0(datadir, file_name), skipNul = TRUE)
  df <- gsub("\u00A0", " ", df)
  df <- df %>% gsub("\"", "", .) %>% trimws(.) %>% .[which(str_detect(.[], ";") == FALSE)]
  df <- df %>% ifelse(nchar(.) == 386, str_pad(., width = 400, side = "right"), .)
  
  if(str_detect(df[[1]][], "\t") == FALSE){
    # First filter
    df_outlier <- as.data.frame(do.call("rbind", strsplit(df[which(nchar(df) != 400)], "\t")), stringsAsFactors = FALSE)
    if(nrow(df_outlier) >= 1 & ncol(df_outlier) >= 1){df_outlier <- df_outlier %>% filter(str_detect(df_outlier[[1]][], ";") == "FALSE")} else {df_outlier <- data.frame()}
    
    # df_outlier_F <- rbindlist(list(df_outlier_F, df_outlier))
    df <- df[which(nchar(df) == 400)]
    df <- as.data.frame(do.call("rbind", strsplit(df, "\t")), stringsAsFactors = FALSE)
    df <- df %>% filter(str_detect(.[[1]][], ";") == "FALSE")
    
  } else {
    df <- as.data.frame(do.call("rbind", strsplit(df, "\t")), stringsAsFactors = FALSE)
    df <- df %>% filter(str_detect(.[[1]][], ";") == "FALSE")
    
    df_outlier <- data.frame()
  }
  
  if(nrow(df) >= 1 & ncol(df) == 1){
    for (i in 1:nrow(field_param)){
      field_names <- field_param$field_mapping[i]
      start <- field_param$start[i]
      end <- field_param$end[i]
      df[[field_names]] <- str_sub(df$V1, start, end)
    }
    df <- df %>% mutate(last4 = paste0(clientid, place_of_death, frozen_indicator, claim_type)) %>% select(-c("V1", "clientid", "place_of_death", "frozen_indicator", "claim_type"))
  }
  
  df <- df %>% mutate_if(is.character, str_trim)
  df <- df %>% mutate(company = str_sub(file_name, 1, 3))
  
  df <- convert(df)
  if(length(df) >= 1){colnames(df) <- column_n}
  
  return(list(df, df_outlier))
}

df_outlier = list()
# Combind the data
# df <- map_dfr(files, split_df, .id = "id")

df <- map_dfr(files, split_df, .id = "id")

# Classify the outliers
df_outlier <- df %>% filter(!is.na(V1)) %>% select(V1)
df <- df %>% select(-c("V1")) %>% .[!is.na(policynumber),]

df <- df %>% mutate_at(vars(c(22, 23, 24, 26, 27, 28, 29, 30, 31, 32, 33, 34)), ~./100)

# Mapping the treaty info.
treaty_mapping <- treaty_mapping %>% mutate(key_mapping = paste0(comp_number, "_", company))
df <- df %>% mutate(key = paste0(pfs_operating_co, "_", company)) %>%
          left_join(treaty_mapping, by = c("key" = "key_mapping"))

df <- df %>% select(-c("key", "comp_number", "company.y", "id"))

# write.csv(df, "./99.checks/_SD/client_claim_add_20230328.csv")
write.fst(df, "./99.checks/_SD/client_claim_add_20230328.fst")
# write.csv(df_outlier, "./99.checks/_SD/outlier.csv")


# 중복되는 것이 있는지 확인
texts <- lapply(paste0(datadir, files), readLines)

# Compare each pair of files
for(i in 1:(length(files)-1)) {
  for(j in (i+1):length(files)) {
    if(identical(texts[[i]], texts[[j]])) {
      cat("Files\n", files[i], "and\n", files[j], "are identical\n")
    }
  }
}

# 1 건씩 돌려보는 코드
error_dir_3 <- paste0(datadir, files[1220])

df <- readLines(error_dir_3, skipNul = TRUE)
df <- gsub("\u00A0", " ", df)
df <- df %>% gsub("\"", "", .) %>% trimws(.) %>% .[which(str_detect(.[], ";") == FALSE)]
df <- df %>% ifelse(nchar(.) == 386, str_pad(., width = 400, side = "right"), .)


if(str_detect(df[[1]][], "\t") == FALSE){
  # First filter
  df_outlier <- as.data.frame(do.call("rbind", strsplit(df[which(nchar(df) != 400)], "\t")), stringsAsFactors = FALSE)
  if(nrow(df_outlier) >= 1 & ncol(df_outlier) >= 1){df_outlier <- df_outlier %>% filter(str_detect(df_outlier[[1]][], ";") == "FALSE")}
  
  # df_outlier_F <- rbindlist(list(df_outlier_F, df_outlier))
  df <- df[which(nchar(df) == 400)]
  df <- as.data.frame(do.call("rbind", strsplit(df, "\t")), stringsAsFactors = FALSE)
  df <- df %>% filter(str_detect(.[[1]][], ";") == "FALSE")
  
} else {
  df <- as.data.frame(do.call("rbind", strsplit(df, "\t")), stringsAsFactors = FALSE)
  df <- df %>% filter(str_detect(.[[1]][], ";") == "FALSE")
  
  df_outlier <- data.frame()
}

if(nrow(df) >= 1 & ncol(df) == 1){
  for (i in 1:nrow(field_param)){
    field_names <- field_param$field_mapping[i]
    start <- field_param$start[i]
    end <- field_param$end[i]
    df[[field_names]] <- str_sub(df$V1, start, end)
  }
  
  df <- df %>% mutate(last4 = paste0(clientid, place_of_death, frozen_indicator, claim_type)) %>% select(-c("V1", "clientid", "place_of_death", "frozen_indicator", "claim_type"))
}

df <- df %>% mutate_if(is.character, str_trim)
df_outlier <- df %>% filter(!is.na(V1)) %>% select(V1)
df <- df %>% select(-c("V1")) %>% na.omit(.)

df <- convert(df)
if(length(df) >= 1){colnames(df) <- column_n}

df <- df %>% mutate_at(vars(c(22, 23, 24, 26, 27, 28, 29, 30, 31, 32, 33, 34)), ~./100)

# Mapping the treaty info.
treaty_mapping <- treaty_mapping %>% mutate(key_mapping = paste0(comp_number, "_", company))
df <- df %>% mutate(key = paste0(pfs_operating_co, "_", company)) %>%
  left_join(treaty_mapping, by = c("key" = "key_mapping"))

df <- df %>% select(-c("key", "comp_number", "company.y", "id"))

# tryCatch({
#   # Attempt to read in the file
#   full_result <- map_dfr(files[510:511], split_df)
# },
# error = function(e) {
#   # Handle the error gracefully
#   message("An error occurred while reading the file: ", e$message)
#   # Optionally, return a default value or execute other code
# })


# Old version
# split_df <- function(file_name){
#   # df1 == \t 로 분리되는 테이블, df2는 탭으로 분리되지 않아 위치로 분리해야함.
#   df1 <- read.table(paste0(datadir, file_name), sep = "\t", header = FALSE, stringsAsFactors = FALSE, fill = TRUE) %>% filter(str_detect(.[[1]][], ";") == "FALSE", length(colnames(.)) != 1)
#   df2 <- read.table(paste0(datadir, file_name), sep = "\t", header = FALSE, stringsAsFactors = FALSE, fill = TRUE) %>% filter(str_detect(.[[1]][], ";") == "FALSE", length(colnames(.)) == 1)
#   if(nrow(df2) >= 1){
#     for (i in 1:nrow(field_param)){
#       field_names <- field_param$field_mapping[i]
#       start <- field_param$start[i]
#       end <- field_param$end[i]
#       df2[[field_names]] <- str_sub(df2$V1, start, end)
#     }
#   
#     df2 <- df2 %>% mutate(last4 = paste0(clientid, place_of_death, frozen_indicator, claim_type)) %>% select(-c("V1", "clientid", "place_of_death", "frozen_indicator", "claim_type"))
#   }
#   
#   df1 <- df1 %>% mutate_if(is.character, str_trim)
#   df2 <- df2 %>% mutate_if(is.character, str_trim)
#   
#   df <- lapply(list(df1, df2), convert)
#   df <- lapply(df, function(df) {
#     if (length(df) < 1){
#       return(df)
#     } else {
#       colnames(df) <- column_n
#       return(df)
#     }
#   })
#   
#   return(rbindlist(df))
# }
# 
# 
# df <- lapply(list(df1, df2), convert)
# df <- lapply(df, function(df) {
#   if (length(df) < 1){
#     return(df)
#   } else {
#     colnames(df) <- column_n
#     return(df)
#   }
# })
# 
# rbindlist(df)

# Practice
# test_dir_all <- "/home/share/overseas_life/1_North_America/6_project/client_data_sample_checks/0.data/primerica/claim/sample.txt"
# test_dir_notab <- "/home/share/overseas_life/1_North_America/6_project/client_data_sample_checks/0.data/primerica/claim/sample_no_tab.txt"
# test_dir_yestab <- "/home/share/overseas_life/1_North_America/6_project/client_data_sample_checks/0.data/primerica/claim/sample_yes_tab.txt"
# 
# col_names <- c('pfs_operating_co',
#                'claimnumber',
#                'claim_version',
#                'bill_version',
#                'policynumber',
#                'deceased_name',
#                'insured_name',
#                'birthdate',
#                'gender',
#                'relation_to_primary',
#                'notifydate',
#                'date_of_death',
#                'claim_status',
#                'rein_code',
#                'rating_present',
#                'contest_code',
#                'death_code',
#                'bill_date',
#                'issue_date',
#                'treaty_code',
#                'total_coverage',
#                'total_benefit_paid',
#                'total_interet_paid',
#                'insured_issue_state',
#                'total_benefit',
#                'total_state_interest',
#                'total_legal_investing',
#                'ceded_total_amount',
#                'ceded_base_coverage',
#                'ceded_rider_amount',
#                'ceded_state_interest',
#                'ceded_investing_expense',
#                'ceded_legal_expense',
#                'paid_status',
#                'clientid',
#                'place_of_death',
#                'frozen_indicator',
#                'claim_type')

# replace spaces by "_" in the column names
colnames(full_inforce) <- str_replace_all(colnames(full_inforce), " ", "_") 

# convert the upper to lowercase in the column names
colnames(full_inforce) <- tolower(colnames(full_inforce))

#full_inforce <- full_inforce %>% mutate(cedingcompany = ifelse(ceding_company %in% c("PAZ", "PNJ"), "pruco",
#                                                               ifelse(ceding_company %in% c("PRJ", "PRU", "PRZ"), "prudential", "check")))
