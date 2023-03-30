# Transform the type of data

rm(list =ls())

setwd("/home/share/overseas_life/1_North_America/1_Inforce/1_rawdata")

setwd("./~2022 1Q/ADD_RMA_20230308")
file_list <- list.files(pattern = "*.csv")

# 폴더에 있는 .csv 자료 합치기
merge_data <- function(file_list){
  a <- fread(paste0("./", file_list), header = FALSE)
  colnames(a) = tolower(a[a$V1 == "DataFileType",])
  a <- a %>% filter(grepl("RMA_", datafiletype))
  
  return(rbindlist(list(final, a)))
}

final <- NULL
final <- map_dfr(file_list, merge_data)

final[final == "NULL"] <- ""

inforce_rma <- final %>% mutate( 
  # convert date format into YYYY-MM-DD
  statementdate = dmy(statementdate),
  coverage_transactioneffectivedate = dmy(coverage_transactioneffectivedate),
  financialtransaction_premiumcalculationfromdate = dmy(financialtransaction_premiumcalculationfromdate),
  financialtransaction_premiumcalculationtodate = dmy(financialtransaction_premiumcalculationtodate),
  policy_originalpolicyissuedate = dmy(policy_originalpolicyissuedate),
  policy_currentpolicyissuedate = dmy(policy_currentpolicyissuedate),
  coverage_conversiondate = dmy(coverage_conversiondate),
  coverage_newbusinessdate = dmy(coverage_newbusinessdate),
  coverage_maturityexpirydate = dmy(coverage_maturityexpirydate),
  life_1_dateofbirth = dmy(life_1_dateofbirth), 
  life_2_dateofbirth = dmy(life_2_dateofbirth),
  
  # convert into integer
  coverage_expiryage = as.integer(coverage_expiryage),
  policy_currentpolicyduration = as.integer(policy_currentpolicyduration),
  policy_originalpolicyduration = as.integer(policy_originalpolicyduration),
  life_1_issueage = as.integer(life_1_issueage),
  life_1_temporaryflatextraduration = as.integer(life_1_temporaryflatextraduration),
  life_1_permanentflatextraduration = as.integer(life_1_permanentflatextraduration),
  life_1_calculatedissueage = as.integer(life_1_calculatedissueage),
  life_2_issueage = as.integer(life_2_issueage),
  life_2_temporaryflatextraduration = as.integer(life_2_temporaryflatextraduration),
  life_2_permanentflatextraduration = as.integer(life_2_permanentflatextraduration),
  life_2_calculatedissueage = as.integer(life_2_calculatedissueage),
  
  # convert into numeric
  coverage_faceamount = as.numeric(coverage_faceamount),
  coverage_cedednetamountrisk = as.numeric(coverage_cedednetamountrisk),
  coverage_cededamount = as.numeric(coverage_cededamount),
  financialtransaction_firstyeartemporaryflatextrapremium = as.numeric(financialtransaction_firstyeartemporaryflatextrapremium),
  financialtransaction_renewaltemporaryflatextrapremium = as.numeric(financialtransaction_renewaltemporaryflatextrapremium),
  financialtransaction_firstyearpermanentflatextrapremium = as.numeric(financialtransaction_firstyearpermanentflatextrapremium),
  financialtransaction_renewalpermanentflatextrapremium = as.numeric(financialtransaction_renewalpermanentflatextrapremium),
  financialtransaction_firstyearstandardpremium = as.numeric(financialtransaction_firstyearstandardpremium),
  financialtransaction_renewalstandardpremium = as.numeric(financialtransaction_renewalstandardpremium),
  financialtransaction_firstyearsubstandardpremium = as.numeric(financialtransaction_firstyearsubstandardpremium),
  financialtransaction_renewalsubstandardpremium = as.numeric(financialtransaction_renewalsubstandardpremium),
  financialtransaction_firstyeartemporaryflatextraallowance = as.numeric(financialtransaction_firstyeartemporaryflatextraallowance),
  financialtransaction_renewaltemporaryflatextraallowance = as.numeric(financialtransaction_renewaltemporaryflatextraallowance),
  financialtransaction_firstyearpermanentflatextraallowance = as.numeric(financialtransaction_firstyearpermanentflatextraallowance),
  financialtransaction_renewalpermanentflatextraallowance = as.numeric(financialtransaction_renewalpermanentflatextraallowance),
  financialtransaction_firstyearstandardallowance = as.numeric(financialtransaction_firstyearstandardallowance),
  financialtransaction_renewalstandardallowance = as.numeric(financialtransaction_renewalstandardallowance),
  financialtransaction_firstyearsubstandardallowance = as.numeric(financialtransaction_firstyearsubstandardallowance),
  financialtransaction_renewalsubstandardallowance = as.numeric(financialtransaction_renewalsubstandardallowance),
  financialtransaction_federalexcisetax = as.numeric(financialtransaction_federalexcisetax),
  life_1_mortalityrating = as.numeric(life_1_mortalityrating),
  life_1_temporaryflatextrarate = as.numeric(life_1_temporaryflatextrarate),
  life_1_permanentflatextrarate = as.numeric(life_1_permanentflatextrarate),
  life_1_calculatedmortalityrating = as.numeric(life_1_calculatedmortalityrating),
  life_2_mortalityrating = as.numeric(life_2_mortalityrating),
  life_2_temporaryflatextrarate = as.numeric(life_2_temporaryflatextrarate),
  life_2_permanentflatextrarate = as.numeric(life_2_permanentflatextrarate),
  life_2_calculatedmortalityrating = as.numeric(life_2_calculatedmortalityrating),
  
  # adjustments
  koreanre_report_date = ifelse(cedingcompany %in% c('Prudential','Pruco Life'),
                                format(statementdate %m+% months(2), "%Y%m"),  # 2 months reporting lag to Koreanre for Prudential
                                format(statementdate %m+% months(1), "%Y%m")), # 1 month reporting lag to Koreanre for the others
  premium = financialtransaction_firstyeartemporaryflatextrapremium 
  + financialtransaction_renewaltemporaryflatextrapremium													
  + financialtransaction_firstyearpermanentflatextrapremium 
  + financialtransaction_renewalpermanentflatextrapremium
  + financialtransaction_firstyearstandardpremium 
  + financialtransaction_renewalstandardpremium
  + financialtransaction_firstyearsubstandardpremium 
  + financialtransaction_renewalsubstandardpremium
  - financialtransaction_firstyeartemporaryflatextraallowance 
  - financialtransaction_renewaltemporaryflatextraallowance
  - financialtransaction_firstyearpermanentflatextraallowance 
  - financialtransaction_renewalpermanentflatextraallowance
  - financialtransaction_firstyearstandardallowance 
  - financialtransaction_renewalstandardallowance
  - financialtransaction_firstyearsubstandardallowance
  - financialtransaction_renewalsubstandardallowance,
  new_billing_id = ifelse(is.na(billingid) | billingid == "NULL" | billingid == "", 
                          rmatreatynumber,
                          billingid),
  treaty_number = substr(new_billing_id, 13, 16)
)

# read treaty_mapping_table
treaty_mapping_table <- read_csv("../../../5_parameter/treaty_mapping/treaty_mapping_table.csv")

inforce_rma <- inforce_rma %>% left_join(treaty_mapping_table, by = c("treaty_number" = "treaty")) # please do not add cedingcompany 

write.fst(inforce_rma, "./inforce_add_20230308.fst", compress = 100)

