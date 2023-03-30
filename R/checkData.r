# Check the data by check lists

## ----------------------------------------------------------------------------------------
# premium/inforce data check - northen america accoumulated premium/inforce data 

## ----------------------------------------------------------------------------------------
# Key fields to be considered

## ----------------------------------------------------------------------------------------
# premium/inforce data checklist
# 1. high level overview - by count, amount
# 2. missing fields - statementdate, billingid, policynumber, UW method, dob, sm status, uw class, etc.
# 3. reasonableness - eligible age?, period of statementdate

## ----------------------------------------------------------------------------------------
# clean up the environment
rm(list =ls())

# set-up initial working directory
setwd("/home/share/overseas_life/1_North_America/1_Inforce/1_rawdata")

setwd("./2022 4Q")

# read premium & inforce data
# data_check <- read.fst("./2_Premium/2_rawdata/취합/premium_rma_formatted_F_20220907.fst")
data_check <- read.fst("inforce_rma_2022Q4_20230330.fst")

## Data checkslist
# 1. NULL checks
check <- data_check %>% mutate(
  
  # identifier
  billingid_null = ifelse( is.na(new_billing_id)| new_billing_id %in% c("NULL",""), 1, 0),
  policynumber_null = ifelse( is.na(policy_policynumber)| policy_policynumber %in% c("NULL",""), 1, 0),
  coveragenumber_null = ifelse( is.na(coverage_coveragenumber)| coverage_coveragenumber %in% c("NULL", ""), 1, 0),
  # cov_ren_period_null = ifelse( is.na(coverage_renewableperiod)| coverage_renewableperiod %in% c("NULL",""), 1, 0),
  cov_ren_period_null = ifelse( is.na(gsub("RMA_RENEWABLE_PERIOD_","",coverage_renewableperiod))| gsub("RMA_RENEWABLE_PERIOD_","",coverage_renewableperiod) %in% c("NULL",""), 
                                ifelse( str_detect(coverage_planridertype, "PRODUCT") & coverage_planridertype != "RMA_LIFE_PRODUCT_TYPE_TERM", 0, 1), 0),
  pr_mode_null = ifelse( is.na(financialtransaction_premiummode)| financialtransaction_premiummode %in% c("NULL",""), 1, 0),
  agebasis_null = ifelse( is.na(coverage_agebasis)| coverage_agebasis %in% c("NULL",""), 1, 0),
  exp_age_null = ifelse( is.na(coverage_expiryage)| coverage_expiryage %in% c("NULL",""), 
                         ifelse( str_detect(coverage_planridertype, "PRODUCT") & coverage_planridertype != "RMA_LIFE_PRODUCT_TYPE_TERM", 0, 1), 0),
  curr_null = ifelse( is.na(coverage_currency)| coverage_currency %in% c("NULL",""), 1, 0),
  cov_planridertype_null = ifelse( is.na(coverage_planridertype)| coverage_planridertype %in% c("NULL", ""), 1, 0),
  issueage_null = ifelse( is.na(life_1_issueage), 1, 0),
  calc_issueage_null = ifelse( is.na(life_1_calculatedissueage), 1, 0),
  stand_rating_null = ifelse( is.na(life_1_mortalityrating), 1, 0),
  
  # dates
  statementdate_null = ifelse( is.na(statementdate), 1, 0),
  cov_trans_effdate_null = ifelse( is.na(coverage_transactioneffectivedate), 1, 0),
  org_issuedate_null = ifelse( is.na(policy_originalpolicyissuedate), 1, 0),
  cur_issuedate_null = ifelse( is.na(policy_currentpolicyissuedate), 1, 0),
  dob_null = ifelse( is.na(life_1_dateofbirth), 1, 0),
  
  # amount
  fa_null = ifelse( is.na(coverage_faceamount), 1, 0),
  nar_null = ifelse( is.na(coverage_cedednetamountrisk), 1, 0),
  
  # risk factor
  cov_uw_method_null = ifelse( is.na(coverage_underwritingmethod)| coverage_underwritingmethod %in% c("NULL",""), 1, 0),
  smoking_null = ifelse( is.na(life_1_smokingstatus)| life_1_smokingstatus %in% c("NULL",""), 1, 0), 
  uw_class_null = ifelse( is.na(life_1_underwritingclass)| life_1_underwritingclass %in% c("NULL",""), 1, 0), 
  gender_null = ifelse( is.na(life_1_gender)| life_1_gender %in% c("NULL",""), 1, 0)
)

# 2. Reasonablness checks
check <- check %>% 
  mutate( 
    # unreasonable face amount
    unreasonable_fa = ifelse( coverage_faceamount <= 0, 1, 0),
    # unreasonable NAR
    unreasonable_nar = ifelse( coverage_cedednetamountrisk <= 0, 1, 0),
    # unreasonable date of birth
    unreasonable_dob = ifelse( !(is.na(life_1_dateofbirth)) & max(unique(statementdate)) <= life_1_dateofbirth &
                                 abs(ifelse(coverage_agebasis == "RMA_AGE_BASIS_LAST", 
                                            trunc(time_length(difftime(policy_originalpolicyissuedate, life_1_dateofbirth - years(100)), "years"), 0), 
                                            round(time_length(difftime(policy_originalpolicyissuedate, life_1_dateofbirth - years(100)), "years"), 0)) - life_1_calculatedissueage) > 1, 1, 0),
    # Smoking Status == Smoking Status in UW Class
    unreasonable_smokingstatus = ifelse(life_1_smokingstatus != 
                                          ifelse(str_sub(life_1_underwritingclass,-3,-2)=="NS","RMA_SMOKING_STATUS_NON-SMOKER",
                                                 ifelse(str_sub(life_1_underwritingclass,-3,-1) == "AGG", "RMA_SMOKING_STATUS_UNISMOKE", "RMA_SMOKING_STATUS_SMOKER")), 1, 0),
    # original issue data > current issue date
    unreasonable_issuedate = ifelse( policy_originalpolicyissuedate > policy_currentpolicyissuedate, 1, 0)
  )

check_result <- check %>% group_by(cedingcompany.x, statementdate) %>% 
  summarise(counts = n(),
            statementdate_n = sum(statementdate_null), 
            billingid_n = sum(billingid_null), 
            trans_effdate_n = sum(cov_trans_effdate_null),
            pono_n = sum(policynumber_null), 
            coveragenumber_n = sum(coveragenumber_null),
            uw_method_n = sum(cov_uw_method_null), 
            ren_preiod_n = sum(cov_ren_period_null),
            pr_mode_n = sum(pr_mode_null), 
            exp_age_n = sum(exp_age_null), 
            curr_n = sum(curr_null),
            cov_planridertype_n = sum(cov_planridertype_null),
            issueage_n = sum(issueage_null),
            calc_issueage_n = sum(calc_issueage_null),
            stand_rating_n = sum(stand_rating_null),
            agebasis_n = sum(agebasis_null),
            org_issdate_n = sum(org_issuedate_null), 
            cur_issdate_n = sum(cur_issuedate_null), 
            fa_n = sum(fa_null), 
            nar_n = sum(nar_null),
            dob_n = sum(dob_null), 
            smoking_n = sum(smoking_null), 
            uw_class_n = sum(uw_class_null), 
            gender_n = sum(gender_null),
            unreasonable_fa_n = sum(unreasonable_fa),
            unreasonable_nar_n = sum(unreasonable_nar),
            unreasonable_dob_n = sum(unreasonable_dob),
            unreasonable_smokingstatus_n = sum(unreasonable_smokingstatus),
            unreasonable_issuedate_n = sum(unreasonable_issuedate))

# check_result %>% View()

to_be_checked <- check %>% 
  mutate(check_flag = rowSums(across(billingid_null:unreasonable_issuedate))) %>% 
  filter(check_flag > 0)

write.xlsx(check_result, "./_checks/inforce_ck_20230308.xlsx", overwrite = TRUE)
write.xlsx(to_be_checked, "./_checks/inforce_to_be_checked_20230330.xlsx", overwrite = TRUE)


# 
# ################ premium summary by treatyname and koreanre report date ################
# group_premium <- premium_rma %>% group_by(new_report_date, treatyname_solomon) %>% 
#   summarise(netpremium = sum(premium))
# 
# group_premium <- premium_rma %>% group_by(new_report_date, treatyname_solomon, 
#                                           coverage_transactiontype, life_1_gender, 
#                                           life_1_smokingstatus) %>% 
#   summarise(counts = n(),
#             netpremium = sum(premium))
# 
# write.csv(group_premium, "../3_datacheck/premium_summary_20220905.csv")
# 
# ############### the affected rows vs the provided rows ##############
# 
# # set up working directory
# setwd("/home")
# setwd("/home/share/overseas_life/1_North_America/2_Premium/2_rawdata/")
# 
# # company folder list
# file_list_cpy <- list.files() # list of ceding company
# remove <- c("취합")
# file_list_cpy <- setdiff(file_list_cpy, remove)
# 
# # please use the copmany parameter one by one from the list of company name
# premium_rownumber_check <- function(company){
#   
#   # premium file directory
#   data_dir <- paste0("./",company) # data directory for each ceding company
#   file_list <- list.files(data_dir, pattern="*.csv") # csv file list in each ceding company folder
#   
#   # build a empty dataframe
#   rownumber_check <- matrix(nrow = length(file_list), ncol = 4)
#   colnames(rownumber_check) <- c("cpy", "data_name", "rows_affected", "row_counts")
#   
#   # fill a empty dataframe with the rows affected vs actual row acounts
#   for (i in 1:length(file_list)){
#     temp_df <- read_csv(paste0(data_dir,"/", file_list[i]), col_names = FALSE)                  # read csv file
#     rownumber_check[i,1] <- company
#     rownumber_check[i,2] <- file_list[i]                                                        # name of premium file
#     rownumber_check[i,3] <- temp_df[temp_df$X1 %like% "rows affected",][1,1] %>% as.character() # rows affected provided by agent
#     rownumber_check[i,4] <- sum(grepl("RMA",temp_df$X1))                                        # remove invalid rows
#   }
#   
#   return(rownumber_check)
# }
# 
# # row bind 
# prem_rows_reconciliation <- map_dfr(file_list_cpy, premium_rownumber_check) 
# 
# prem_rows_reconciliation <- as_tibble(prem_rows_reconciliation)
# write.csv(prem_rows_reconciliation, "../3_datacheck/rows_affected_vs_actual.csv")
# 
# 
# 
# #-- 부분 확인 #################
# # company folder list
# file_list_cpy <- list.files() # list of ceding company
# remove <- c("취합")
# file_list_cpy <- setdiff(file_list_cpy, remove)
# 
# new_UAT_files <- paste0("Korean Re - Primerica_UAT_", c(7:15), " (70,83) Transactions From Inception (Feb2016-May2016).csv")
# 
# # spot check - primerica
# cpy <- "PFS Primerica (70,83)"
# #file_list_sub <- list.files(paste0("./",cpy), pattern = ".csv")
# 
# read.fst( paste0("./", cpy, "/", file_list_sub[1]))
# 
# # function to read
# rbind_df <- function(cpy, file_list){
#   temp_df <- read.csv( paste0("./",cpy, "/" , file_list), header =FALSE)
#   temp_df <- temp_df %>% filter(grepl("RMA_", datafiletype))
#   
#   return(temp_df)
# }
# 
# test <- read.csv( paste0("./",cpy, "/" , "Korean Re - Primerica_UAT_7 (70,83) Transactions From Inception (Apr2015-Aug2015).csv" ), header =FALSE)
# 
# arg_cpy <- rep(cpy, length(file_list_sub))
# arg_list <- list(arg_cpy, file_list_sub)
# 
# sub_prem <- pmap_dfr( arg_list, rbind_df)
# 
# 
# #start_time <- Sys.time()
# sub_prem <- sub_prem %>% 
#   mutate( financialtransaction_firstyeartemporaryflatextrapremium = as.numeric(financialtransaction_firstyeartemporaryflatextrapremium),
#           financialtransaction_renewaltemporaryflatextrapremium = as.numeric(financialtransaction_renewaltemporaryflatextrapremium),
#           financialtransaction_firstyearpermanentflatextrapremium = as.numeric(financialtransaction_firstyearpermanentflatextrapremium),
#           financialtransaction_renewalpermanentflatextrapremium = as.numeric(financialtransaction_renewalpermanentflatextrapremium),
#           financialtransaction_firstyearstandardpremium = as.numeric(financialtransaction_firstyearstandardpremium),
#           financialtransaction_renewalstandardpremium = as.numeric(financialtransaction_renewalstandardpremium),
#           financialtransaction_firstyearsubstandardpremium = as.numeric(financialtransaction_firstyearsubstandardpremium),
#           financialtransaction_renewalsubstandardpremium = as.numeric(financialtransaction_renewalsubstandardpremium),
#           financialtransaction_firstyeartemporaryflatextraallowance = as.numeric(financialtransaction_firstyeartemporaryflatextraallowance),
#           financialtransaction_renewaltemporaryflatextraallowance = as.numeric(financialtransaction_renewaltemporaryflatextraallowance),
#           financialtransaction_firstyearpermanentflatextraallowance = as.numeric(financialtransaction_firstyearpermanentflatextraallowance),
#           financialtransaction_renewalpermanentflatextraallowance = as.numeric(financialtransaction_renewalpermanentflatextraallowance),
#           financialtransaction_firstyearstandardallowance = as.numeric(financialtransaction_firstyearstandardallowance),
#           financialtransaction_renewalstandardallowance = as.numeric(financialtransaction_renewalstandardallowance),
#           financialtransaction_firstyearsubstandardallowance = as.numeric(financialtransaction_firstyearsubstandardallowance),
#           financialtransaction_renewalsubstandardallowance = as.numeric(financialtransaction_renewalsubstandardallowance)
#   )
# 
# 
# #start_time <- Sys.time()
# sub_prem <- sub_prem %>% mutate( new_report_date = ifelse(cedingcompany %in% c('Prudential','Pruco Life'),
#                                                           format(dmy(sub_prem$statementdate) %m+% months(2), "%Y%m"),
#                                                           format(dmy(sub_prem$statementdate) %m+% months(1), "%Y%m")),
#                                  premium = financialtransaction_firstyeartemporaryflatextrapremium 
#                                  + financialtransaction_renewaltemporaryflatextrapremium													
#                                  + financialtransaction_firstyearpermanentflatextrapremium 
#                                  + financialtransaction_renewalpermanentflatextrapremium
#                                  + financialtransaction_firstyearstandardpremium 
#                                  + financialtransaction_renewalstandardpremium
#                                  + financialtransaction_firstyearsubstandardpremium 
#                                  + financialtransaction_renewalsubstandardpremium
#                                  - financialtransaction_firstyeartemporaryflatextraallowance 
#                                  - financialtransaction_renewaltemporaryflatextraallowance
#                                  - financialtransaction_firstyearpermanentflatextraallowance 
#                                  - financialtransaction_renewalpermanentflatextraallowance
#                                  - financialtransaction_firstyearstandardallowance 
#                                  - financialtransaction_renewalstandardallowance
#                                  - financialtransaction_firstyearsubstandardallowance
#                                  - financialtransaction_renewalsubstandardallowance,
#                                  new_billing_id = ifelse(is.na(billingid) | billingid == "NULL" | billingid == "", 
#                                                          rmatreatynumber,
#                                                          billingid),
#                                  treaty_number = substr(new_billing_id, 13, 16)
#                                  #inforce_flag =  ifelse( coverage_transactiontype %in% c("RMA_TRANSACTION_TYPE_NEW",
#                                  #                                                        "RMA_TRANSACTION_TYPE_REI",
#                                  #                                                        "RMA_TRANSACTION_TYPE_REN") &
#                                  #                        policy_originalpolicyissuedate != "NULL" &
#                                  #                        !(is.na(policy_originalpolicyissuedate)) &
#                                  #                        policy_originalpolicyissuedate != "",
#                                  #                        "inforce",
#                                  #                        "not_inforce")
# )
# 
# 
# # read treaty_mapping_table
# treaty_mapping_table <- read_csv("../../5_parameter/treaty_mapping/treaty_mapping_table.csv")
# 
# sub_prem <- sub_prem %>% left_join(treaty_mapping_table, by = c("treaty_number" = "treaty_number"))
# 
# group_premium <- sub_prem %>% group_by(new_report_date, treatyname_solomon) %>% 
#   summarise(netpremium = sum(premium))
