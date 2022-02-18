※ 필요한 package 설치

install.packages("data.table")
install.packages("tidyverse")
install.packages("bit64")
install.packages("stringr")
install.packages("readxl")
install.packages("writexl")
install.packages("lubridate")

library(data.table)
library(tidyverse)
library(bit64)
library(stringr)
library(readxl)
library(writexl)
library(lubridate)

※ 파일이 저장된 폴더 지정 및 파일 불러오기

setwd("C:/koreanre/북미data/01.RMA거래사/02.보험료/1Q19 - 1Q21 Korean Re Transaction Files")
getwd()

prem_data_191Q = fread('1Q19 Korean Re Transaction Files.csv', data.table='FALSE')
prem_data_192Q = fread('2Q19 Korean Re Transaction Files.csv', data.table='FALSE')
prem_data_193Q = fread('3Q19 Korean Re Transaction Files.csv', data.table='FALSE')
prem_data_194Q = fread('4Q19 Korean Re Transaction Files.csv', data.table='FALSE')
prem_data_201Q = fread('1Q20 Korean Re Transaction Files.csv', data.table='FALSE')
prem_data_202Q = fread('2Q20 Korean Re Transaction Files.csv', data.table='FALSE')
prem_data_203Q = fread('3Q20 Korean Re Transaction Files.csv', data.table='FALSE')
prem_data_204Q = fread('4Q20 Korean Re Transaction Files.csv', data.table='FALSE')
prem_data_211Q = fread('1Q21 Korean Re Transaction Files.csv', data.table='FALSE')

※ 파일내 데이터 구조 파악

str(prem_data_191Q)



※ 유니크한 값 추출하기

stored_data1 %>% 
  dplyr::distinct(CedingCompany)

setwd("C:/koreanre/북미data/01.RMA거래사/02.보험료/202106_RMA_보험료/202106 Korean Transaction Files")
getwd()

prem_data_212Q_1 = fread('202106 Korean Transaction File - Other PFS.csv', data.table='FALSE')
RMA_inforce_data_212Q_2 = fread('202106 Korean Inforce File - PFS_KOR_2.csv', data.table='FALSE')
RMA_inforce_data_212Q_3 = fread('202106 Korean Inforce File - PFS_KOR_3.csv', data.table='FALSE')
RMA_inforce_data_212Q_4 = fread('202106 Korean Inforce File - PFS_KOR_4.csv', data.table='FALSE')
RMA_inforce_data_212Q_5 = fread('202106 Korean Inforce File - PFS_KRC.csv', data.table='FALSE')
RMA_inforce_data_212Q_6 = fread('202106 Korean Inforce File - PFS_KRS, PFS_KRP.csv', data.table='FALSE')
RMA_inforce_data_212Q_7 = fread('202106 Korean Inforce File - PRU, NYL, PFSC, Lincoln, Principal.csv', data.table='FALSE')

str(RMA_inforce_data_212Q_1)

RMA_inforce_data_212Q_7 %>% 
  dplyr::distinct(Policy_PolicyNumber)

setwd("C:/koreanre/북미data/01.RMA거래사/01.Inforce/01.RMA거래사_inforce")
getwd()

RMA_inforce_date_211Q = fread('1Q21 Korean Re Inforce Files.csv', data.table='FALSE')
RMA_inforce_date_212Q = fread('2Q21 Korean Re Inforce Files.csv', data.table='FALSE')
RMA_inforce_date_203Q = fread('3Q20 Korean Re Inforce Files.csv', data.table='FALSE')
RMA_inforce_date_204Q = fread('4Q20 Korean Re Inforce Files.csv', data.table='FALSE')

Sys.setlocale('LC_ALL', 'English')

zoo::as.Date("30-Sep-2020", format = "%d-%b-%Y")

setwd("C:/koreanre/북미data/01.Inforce/202009/3Q20 Korean Re Inforce Files REVISED")
getwd()

stored_data1 = fread('202009 Korean Re Inforce File - PFS-KOR-1.csv', data.table='FALSE')

str(stored_data1)
str(stored_data7)

stored_data1 %>% 
  dplyr::select(-c(Life_1_LastName, Life_1_FirstName, Life_1_MiddleName, 
                   Life_1_DateOfBirth, Life_1_IssueAge, Life_1_SmokingStatus, 
                   Life_1_UnderwritingClass, Life_1_Gender, Life_1_MortalityRating, 
                   Life_1_TemporaryFlatExtraRate, Life_1_PermanentFlatExtraRate)) -> stored_data12

str(stored_data12)

stored_data2 = fread('202009 Korean Re Inforce File - PFS-KOR-2.csv', data.table='FALSE')
stored_data3 = fread('202009 Korean Re Inforce File - PFS-KOR-3.csv', data.table='FALSE')
stored_data4 = fread('202009 Korean Re Inforce File - PFS-KOR-4.csv', data.table='FALSE')
stored_data5 = fread('202009 Korean Re Inforce File - PFS-KRC.csv', data.table='FALSE')
stored_data6 = fread('202009 Korean Re Inforce File - PFS-KRS, PFS-KRP.csv', data.table='FALSE')
stored_data7 = fread('202009 Korean Re Inforce File - PRU, NYL, PFS Canada.csv', data.table='FALSE')

# stored_data7$Policy_PolicyNumber <- as.integer(stored_data7$Policy_PolicyNumber)
# stored_data7$Coverage_IssueAge   <- as.integer(stored_data7$Coverage_IssueAge)
# stored_data7$Coverage_ClientReportedStatReserve   <- as.double(stored_data7$Coverage_ClientReportedStatReserve)

stored_data_1 <- head(stored_data1, n = 5)
stored_data_2 <- head(stored_data2, n = 5)
stored_data_3 <- head(stored_data3, n = 5)
stored_data_4 <- head(stored_data4, n = 5)
stored_data_5 <- head(stored_data5, n = 5)
stored_data_6 <- head(stored_data6, n = 5)
stored_data_7 <- head(stored_data7, n = 5)

dplyr::bind_rows(stored_data_1, stored_data_2, stored_data_3, stored_data_4,
                 stored_data_5, stored_data_6) -> data_all

str(data_all)
str(stored_data_7)

stored_data_7 %>% 
  dplyr::select(-c(Life_1_LastName, Life_1_FirstName, Life_1_MiddleName, 
                   Life_1_DateOfBirth, Life_1_IssueAge, Life_1_SmokingStatus, 
                   Life_1_UnderwritingClass, Life_1_Gender, Life_1_MortalityRating, 
                   Life_1_TemporaryFlatExtraRate, Life_1_PermanentFlatExtraRate)) -> stored_data72

str(stored_data72)


#inforce

setwd("C:/koreanre/북미data/01.RMA거래사/01.Inforce")
getwd()

setwd("C:/koreanre/북미data/01.RMA거래사/01.Inforce/202009")
getwd()

setwd("C:/koreanre/북미data/01.RMA거래사/01.Inforce/202106/202106 Korean Inforce File")
getwd()

stored_data1 = fread('202106 Korean Inforce File - PFS_KOR_1.csv', data.table='FALSE')
stored_data2 = fread('202106 Korean Inforce File - PFS_KOR_2.csv', data.table='FALSE')
stored_data3 = fread('202106 Korean Inforce File - PFS_KOR_3.csv', data.table='FALSE')
stored_data4 = fread('202106 Korean Inforce File - PFS_KOR_4.csv', data.table='FALSE')
stored_data5 = fread('202106 Korean Inforce File - PFS_KRC.csv', data.table='FALSE')
stored_data6 = fread('202106 Korean Inforce File - PFS_KRS, PFS_KRP.csv', data.table='FALSE')
stored_data7 = fread('202106 Korean Inforce File - PRU, NYL, PFSC, Lincoln, Principal.csv', data.table='FALSE')

str(stored_data1)

setwd("C:/koreanre/북미data/01.RMA거래사/02.보험료/202106_RMA_보험료/202106 Korean Transaction Files")
getwd()

stored_data8 = fread('202106 Korean Transaction File - Other PFS.csv', data.table='FALSE')
stored_data9 = fread('202106 Korean Transaction File - PFS_KOR_1.csv', data.table='FALSE')
stored_data10 = fread('202106 Korean Transaction File - PFS_KOR_2.csv', data.table='FALSE')
stored_data11 = fread('202106 Korean Transaction File - PRU, NYL, PLI, LNL.csv', data.table='FALSE')

str(stored_data8)

stored_data12 = fread('202012 Korean Inforce File - PFS_KRC.csv', data.table='FALSE')
stored_data13 = fread('202012 Korean Inforce File - PFS_KRS, PFS_KRP.csv', data.table='FALSE')
stored_data14 = fread('202012 Korean Inforce File - PRU, NYL, PFC, Lincoln, Principal.csv', data.table='FALSE')
stored_data15 = fread('202103 Korean Inforce File - PFS_KOR_1.csv', data.table='FALSE')
stored_data16 = fread('202103 Korean Inforce File - PFS_KOR_2.csv', data.table='FALSE')
stored_data17 = fread('202103 Korean Inforce File - PFS_KOR_3.csv', data.table='FALSE')
stored_data18 = fread('202103 Korean Inforce File - PFS_KOR_4.csv', data.table='FALSE')
stored_data19 = fread('202103 Korean Inforce File - PFS_KRC.csv', data.table='FALSE')
stored_data20 = fread('202103 Korean Inforce File - PFS_KRS, PFS_KRP.csv', data.table='FALSE')
stored_data21 = fread('202103 Korean Inforce File - PRU, NYL, PFSC, Lin, Prin.csv', data.table='FALSE')


stored_data1 = fread('202009 Korean Re Inforce File - PFS-KOR-1_null삭제.csv', data.table='FALSE')
stored_data2 = fread('202009 Korean Re Inforce File - PFS-KOR-2_null삭제.csv', data.table='FALSE')
stored_data3 = fread('202009 Korean Re Inforce File - PFS-KOR-3_null삭제.csv', data.table='FALSE')
stored_data4 = fread('202009 Korean Re Inforce File - PFS-KOR-4_null삭제.csv', data.table='FALSE')
stored_data5 = fread('202009 Korean Re Inforce File - PFS-KRC_null삭제.csv', data.table='FALSE')
stored_data6 = fread('202009 Korean Re Inforce File - PFS-KRS, PFS-KRP_null삭제.csv', data.table='FALSE')
stored_data7 = fread('202009 Korean Re Inforce File - PRU, NYL, PFS Canada_null삭제.csv', data.table='FALSE')
stored_data8 = fread('202012 Korean Inforce File - PFS_KOR_1_null삭제.csv', data.table='FALSE')
stored_data9 = fread('202012 Korean Inforce File - PFS_KOR_2_null삭제.csv', data.table='FALSE')
stored_data10 = fread('202012 Korean Inforce File - PFS_KOR_3_null삭제.csv', data.table='FALSE')
stored_data11 = fread('202012 Korean Inforce File - PFS_KOR_4_null삭제.csv', data.table='FALSE')
stored_data12 = fread('202012 Korean Inforce File - PFS_KRC_null삭제.csv', data.table='FALSE')
stored_data13 = fread('202012 Korean Inforce File - PFS_KRS, PFS_KRP_null삭제.csv', data.table='FALSE')
stored_data14 = fread('202012 Korean Inforce File - PRU, NYL, PFC, Lincoln, Principal_null삭제.csv', data.table='FALSE')
stored_data15 = fread('202103 Korean Inforce File - PFS_KOR_1_null삭제.csv', data.table='FALSE')
stored_data16 = fread('202103 Korean Inforce File - PFS_KOR_2_null삭제.csv', data.table='FALSE')
stored_data17 = fread('202103 Korean Inforce File - PFS_KOR_3_null삭제.csv', data.table='FALSE')
stored_data18 = fread('202103 Korean Inforce File - PFS_KOR_4_null삭제.csv', data.table='FALSE')
stored_data19 = fread('202103 Korean Inforce File - PFS_KRC_null삭제.csv', data.table='FALSE')
stored_data20 = fread('202103 Korean Inforce File - PFS_KRS, PFS_KRP_null삭제.csv', data.table='FALSE')
stored_data21 = fread('202103 Korean Inforce File - PRU, NYL, PFSC, Lin, Prin_null삭제.csv', data.table='FALSE')

stored_data13 %>% 
  dplyr::distinct(StatementDate)

stored_data14 %>% 
  dplyr::distinct(StatementDate)

Coverage_IssueAge

help(ifelse)

stored_data_15 <- head(stored_data15, n = 10)

str(stored_data_15)

is.null(stored_data_15)

# 각 변수에서 null을 공란으로 대체하기
# is.na(xxx) -> na는 인식하는데 null은 인식하지못함.


# 202009 Koreanre Re inforce file - PFS_KOR_1

stored_data1$DataFileType <- gsub("NULL", "", stored_data1$DataFileType)
stored_data1$StatementDate <- gsub("NULL", "", stored_data1$StatementDate)
stored_data1$RmaTreatyNumber <- gsub("NULL", "", stored_data1$RmaTreatyNumber)
stored_data1$CedingCompany <- gsub("NULL", "", stored_data1$CedingCompany)
stored_data1$Policy_PolicyNumber <- gsub("NULL", "", stored_data1$Policy_PolicyNumber)
stored_data1$UniqueCoverageKey <- gsub("NULL", "", stored_data1$UniqueCoverageKey)
stored_data1$Policy_LineOfBusiness <- gsub("NULL", "", stored_data1$Policy_LineOfBusiness)
stored_data1$Coverage_UWReferenceNumber <- gsub("NULL", "", stored_data1$Coverage_UWReferenceNumber)
stored_data1$Coverage_UnderwritingMethod <- gsub("NULL", "", stored_data1$Coverage_UnderwritingMethod)
stored_data1$Policy_OriginalPolicyNumber <- gsub("NULL", "", stored_data1$Policy_OriginalPolicyNumber)

stored_data1$Coverage_CoverageNumber <- gsub("NULL", "", stored_data1$Coverage_CoverageNumber)
stored_data1$Policy_OriginalPolicyIssueDate <- gsub("NULL", "", stored_data1$Policy_OriginalPolicyIssueDate)
stored_data1$Policy_CurrentPolicyIssueDate <- gsub("NULL", "", stored_data1$Policy_CurrentPolicyIssueDate)
stored_data1$Policy_CurrentPolicyDuration <- gsub("NULL", "", stored_data1$Policy_CurrentPolicyDuration)
stored_data1$Coverage_CompanyCode <- gsub("NULL", "", stored_data1$Coverage_CompanyCode)
stored_data1$Coverage_PlanRiderType <- gsub("NULL", "", stored_data1$Coverage_PlanRiderType)
stored_data1$Coverage_CedantBasePlanName <- gsub("NULL", "", stored_data1$Coverage_CedantBasePlanName)
stored_data1$Coverage_ConversionDate <- gsub("NULL", "", stored_data1$Coverage_ConversionDate)
stored_data1$Coverage_NewBusinessDate <- gsub("NULL", "", stored_data1$Coverage_NewBusinessDate)
stored_data1$Coverage_MaturityExpiryDate <- gsub("NULL", "", stored_data1$Coverage_MaturityExpiryDate)

stored_data1$Coverage_ExpiryAge <- gsub("NULL", "", stored_data1$Coverage_ExpiryAge)
stored_data1$Coverage_AgeBasis <- gsub("NULL", "", stored_data1$Coverage_AgeBasis)
stored_data1$Coverage_Currency <- gsub("NULL", "", stored_data1$Coverage_Currency)
stored_data1$Coverage_RmaIBNR <- gsub("NULL", "", stored_data1$Coverage_RmaIBNR)
stored_data1$Coverage_RmaUPR <- gsub("NULL", "", stored_data1$Coverage_RmaUPR)
stored_data1$Coverage_RmaStatReserve <- gsub("NULL", "", stored_data1$Coverage_RmaStatReserve)
stored_data1$Life_2_CalculatedMortalityRating <- gsub("NULL", "", stored_data1$Life_2_CalculatedMortalityRating)
stored_data1$Coverage_ClaimIndicator <- gsub("NULL", "", stored_data1$Coverage_ClaimIndicator)
stored_data1$Coverage_ClaimNumber <- gsub("NULL", "", stored_data1$Coverage_ClaimNumber)
stored_data1$Coverage_RetroIndicator <- gsub("NULL", "", stored_data1$Coverage_RetroIndicator)

stored_data1$Coverage_TransactionType <- gsub("NULL", "", stored_data1$Coverage_TransactionType)
stored_data1$Coverage_TransactionEffectiveDate <- gsub("NULL", "", stored_data1$Coverage_TransactionEffectiveDate)
stored_data1$FinancialTransaction_PremiumCalculationFromDate <- gsub("NULL", "", stored_data1$FinancialTransaction_PremiumCalculationFromDate)
stored_data1$FinancialTransaction_FirstYearTemporaryFlatExtraPremium <- gsub("NULL", "", stored_data1$FinancialTransaction_FirstYearTemporaryFlatExtraPremium)
stored_data1$FinancialTransaction_RenewalTemporaryFlatExtraPremium <- gsub("NULL", "", stored_data1$FinancialTransaction_RenewalTemporaryFlatExtraPremium)
stored_data1$FinancialTransaction_FirstYearPermanentFlatExtraAllowance <- gsub("NULL", "", stored_data1$FinancialTransaction_FirstYearPermanentFlatExtraAllowance)
stored_data1$FinancialTransaction_RenewalPermanentFlatExtraAllowance <- gsub("NULL", "", stored_data1$FinancialTransaction_RenewalPermanentFlatExtraAllowance)
stored_data1$FinancialTransaction_FirstYearTemporaryFlatExtraAllowance <- gsub("NULL", "", stored_data1$FinancialTransaction_FirstYearTemporaryFlatExtraAllowance)
stored_data1$FinancialTransaction_RenewalTemporaryFlatExtraAllowance <- gsub("NULL", "", stored_data1$FinancialTransaction_RenewalTemporaryFlatExtraAllowance)
stored_data1$FinancialTransaction_FirstYearSubstandardAllowance <- gsub("NULL", "", stored_data1$FinancialTransaction_FirstYearSubstandardAllowance)

stored_data1$FinancialTransaction_RenewalSubstandardAllowance <- gsub("NULL", "", stored_data1$FinancialTransaction_RenewalSubstandardAllowance)
stored_data1$FinancialTransaction_FirstYearPermanentFlatExtraPremium <- gsub("NULL", "", stored_data1$FinancialTransaction_FirstYearPermanentFlatExtraPremium)
stored_data1$FinancialTransaction_RenewalPermanentFlatExtraPremium <- gsub("NULL", "", stored_data1$FinancialTransaction_RenewalPermanentFlatExtraPremium)
stored_data1$FinancialTransaction_FirstYearStandardPremium <- gsub("NULL", "", stored_data1$FinancialTransaction_FirstYearStandardPremium)
stored_data1$FinancialTransaction_RenewalStandardPremium <- gsub("NULL", "", stored_data1$FinancialTransaction_RenewalStandardPremium)
stored_data1$FinancialTransaction_FirstYearStandardAllowance <- gsub("NULL", "", stored_data1$FinancialTransaction_FirstYearStandardAllowance)
stored_data1$FinancialTransaction_RenewalStandardAllowance <- gsub("NULL", "", stored_data1$FinancialTransaction_RenewalStandardAllowance)
stored_data1$FinancialTransaction_FirstYearSubstandardPremium <- gsub("NULL", "", stored_data1$FinancialTransaction_FirstYearSubstandardPremium)
stored_data1$FinancialTransaction_RenewalSubstandardPremium <- gsub("NULL", "", stored_data1$FinancialTransaction_RenewalSubstandardPremium)
stored_data1$Life_1_CalculatedMortalityRating <- gsub("NULL", "", stored_data1$Life_1_CalculatedMortalityRating)

stored_data1$Life_1_LastName <- gsub("NULL", "", stored_data1$Life_1_LastName)
stored_data1$Life_1_FirstName <- gsub("NULL", "", stored_data1$Life_1_FirstName)
stored_data1$Life_1_MiddleName <- gsub("NULL", "", stored_data1$Life_1_MiddleName)
stored_data1$Life_1_DateOfBirth <- gsub("NULL", "", stored_data1$Life_1_DateOfBirth)
stored_data1$Life_1_IssueAge <- gsub("NULL", "", stored_data1$Life_1_IssueAge)
stored_data1$Life_1_SmokingStatus <- gsub("NULL", "", stored_data1$Life_1_SmokingStatus)
stored_data1$Life_1_UnderwritingClass <- gsub("NULL", "", stored_data1$Life_1_UnderwritingClass)
stored_data1$Life_1_Gender <- gsub("NULL", "", stored_data1$Life_1_Gender)
stored_data1$Life_1_MortalityRating <- gsub("NULL", "", stored_data1$Life_1_MortalityRating)
stored_data1$Life_1_TemporaryFlatExtraRate <- gsub("NULL", "", stored_data1$Life_1_TemporaryFlatExtraRate)

stored_data1$Life_1_PermanentFlatExtraRate <- gsub("NULL", "", stored_data1$Life_1_PermanentFlatExtraRate)
stored_data1$Life_1_TemporaryFlatExtraDuration <- gsub("NULL", "", stored_data1$Life_1_TemporaryFlatExtraDuration)
stored_data1$Life_1_PermanentFlatExtraDuration <- gsub("NULL", "", stored_data1$Life_1_PermanentFlatExtraDuration)
stored_data1$Life_1_LifeStatus <- gsub("NULL", "", stored_data1$Life_1_LifeStatus)
stored_data1$Life_1_IssueResidence <- gsub("NULL", "", stored_data1$Life_1_IssueResidence)
stored_data1$Life_1_CurrentResidence <- gsub("NULL", "", stored_data1$Life_1_CurrentResidence)
stored_data1$Life_2_LastName <- gsub("NULL", "", stored_data1$Life_2_LastName)
stored_data1$Life_2_FirstName <- gsub("NULL", "", stored_data1$Life_2_FirstName)
stored_data1$Life_2_MiddleName <- gsub("NULL", "", stored_data1$Life_2_MiddleName)
stored_data1$Life_2_DateOfBirth <- gsub("NULL", "", stored_data1$Life_2_DateOfBirth)

stored_data1$Life_2_IssueAge <- gsub("NULL", "", stored_data1$Life_2_IssueAge)
stored_data1$Life_2_SmokingStatus <- gsub("NULL", "", stored_data1$Life_2_SmokingStatus)
stored_data1$Life_2_UnderwritingClass <- gsub("NULL", "", stored_data1$Life_2_UnderwritingClass)
stored_data1$Life_2_Gender <- gsub("NULL", "", stored_data1$Life_2_Gender)
stored_data1$Life_2_MortalityRating <- gsub("NULL", "", stored_data1$Life_2_MortalityRating)
stored_data1$Life_2_TemporaryFlatExtraRate <- gsub("NULL", "", stored_data1$Life_2_TemporaryFlatExtraRate)
stored_data1$Life_2_PermanentFlatExtraRate <- gsub("NULL", "", stored_data1$Life_2_PermanentFlatExtraRate)
stored_data1$Life_2_TemporaryFlatExtraDuration <- gsub("NULL", "", stored_data1$Life_2_TemporaryFlatExtraDuration)
stored_data1$Life_2_PermanentFlatExtraDuration <- gsub("NULL", "", stored_data1$Life_2_PermanentFlatExtraDuration)
stored_data1$Life_2_LifeStatus <- gsub("NULL", "", stored_data1$Life_2_LifeStatus)

stored_data1$Life_2_IssueResidence <- gsub("NULL", "", stored_data1$Life_2_IssueResidence)
stored_data1$Life_2_CurrentResidence <- gsub("NULL", "", stored_data1$Life_2_CurrentResidence)
stored_data1$Coverage_CedantRiderName <- gsub("NULL", "", stored_data1$Coverage_CedantRiderName)
stored_data1$Coverage_DeathBenefitOption <- gsub("NULL", "", stored_data1$Coverage_DeathBenefitOption)
stored_data1$Life_1_CalculatedIssueAge <- gsub("NULL", "", stored_data1$Life_1_CalculatedIssueAge)
stored_data1$Coverage_OriginalCoverageNumber <- gsub("NULL", "", stored_data1$Coverage_OriginalCoverageNumber)
stored_data1$Coverage_AutoFacIndicator <- gsub("NULL", "", stored_data1$Coverage_AutoFacIndicator)
stored_data1$Coverage_IssueAge <- gsub("NULL", "", stored_data1$Coverage_IssueAge)
stored_data1$Coverage_ReinsuranceMethod <- gsub("NULL", "", stored_data1$Coverage_ReinsuranceMethod)
stored_data1$Coverage_CededNetAmountRisk <- gsub("NULL", "", stored_data1$Coverage_CededNetAmountRisk)

stored_data1$Life_2_CalculatedIssueAge <- gsub("NULL", "", stored_data1$Life_2_CalculatedIssueAge)
stored_data1$Coverage_FaceAmount <- gsub("NULL", "", stored_data1$Coverage_FaceAmount)
stored_data1$Coverage_CededAmount <- gsub("NULL", "", stored_data1$Coverage_CededAmount)
stored_data1$Coverage_Comment <- gsub("NULL", "", stored_data1$Coverage_Comment)
stored_data1$Coverage_CoverageType <- gsub("NULL", "", stored_data1$Coverage_CoverageType)
stored_data1$Coverage_Message <- gsub("NULL", "", stored_data1$Coverage_Message)
stored_data1$Coverage_CoverageStatus <- gsub("NULL", "", stored_data1$Coverage_CoverageStatus)
stored_data1$Coverage_RenewablePeriod <- gsub("NULL", "", stored_data1$Coverage_RenewablePeriod)
stored_data1$FinancialTransaction_PremiumMode <- gsub("NULL", "", stored_data1$FinancialTransaction_PremiumMode)
stored_data1$Policy_OriginalPolicyDuration <- gsub("NULL", "", stored_data1$Policy_OriginalPolicyDuration)

stored_data1$Coverage_Reverse_Indicator <- gsub("NULL", "", stored_data1$Coverage_Reverse_Indicator)
stored_data1$Coverage_ClientReportedStatReserve <- gsub("NULL", "", stored_data1$Coverage_ClientReportedStatReserve)
stored_data1$Coverage_PoolName <- gsub("NULL", "", stored_data1$Coverage_PoolName)
stored_data1$BlockBusiness <- gsub("NULL", "", stored_data1$BlockBusiness)
stored_data1$Coverage_RiderFlag <- gsub("NULL", "", stored_data1$Coverage_RiderFlag)
stored_data1$FinancialTransaction_PremiumCalculationToDate <- gsub("NULL", "", stored_data1$FinancialTransaction_PremiumCalculationToDate)
stored_data1$FinancialTransaction_FederalExciseTax <- gsub("NULL", "", stored_data1$FinancialTransaction_FederalExciseTax)
stored_data1$Life_1_Comment <- gsub("NULL", "", stored_data1$Life_1_Comment)
stored_data1$Life_2_Comment <- gsub("NULL", "", stored_data1$Life_2_Comment)

write_csv(stored_data1,
          file = '202009 Korean Re Inforce File - PFS-KOR-1_null삭제.csv')

stored_data_15 %>% 
  dplyr::mutate(StatementDate = as.Date(StatementDate, "%d-%b-%y")) %>% 
  dplyr::mutate(Policy_OriginalPolicyIssueDate = as.Date(Policy_OriginalPolicyIssueDate, "%d-%b-%y")) %>% 
  dplyr::mutate(Policy_CurrentPolicyIssueDate = as.Date(Policy_CurrentPolicyIssueDate, "%d-%b-%y")) %>% 
  dplyr::mutate(Coverage_TransactionEffectiveDate = as.Date(Coverage_TransactionEffectiveDate, "%d-%b-%y")) -> stored_data_15_1


write_csv(stored_data_15,
          file  = "RMA_202103.csv")

write_csv(stored_data_15_1,
          file  = "RMA_202103_re.csv")

writexl::write_xlsx(stored_data_15_1,
                    path  = "RMA_202103_re.csv",
                    col_names = TRUE)

stored_data_21 %>% 
  dplyr::select(c(DataFileType, StatementDate, RmaTreatyNumber)) -> stored_data_22
                  


# character를 숫자 형태로 변환
stored_data_22 %>% 
  dplyr::mutate(StatementDate2 = as.Date(StatementDate, "%d-%b-%y")) -> stored_data_23

stored_data_22 %>% 
  dplyr::mutate(StatementDate2 = dmy(StatementDate)) -> stored_data_24

# 숫자 형태로 완전히 변환
stored_data_22 %>% 
  dplyr::mutate(StatementDate = dmy(StatementDate)) -> stored_data_22


as.Date("31-09-2021", format = "%d-%m-%Y")

lubridate::dmy("31-Mar-21")
lubridate::dmy("stored_data_22$StatementDate")

dim(stored_data15)

str(stored_data7)

stored_data7 %>% 
  dplyr::distinct(StatementDate)

stored_data15 %>% 
  dplyr::distinct(Life_2_Comment)
stored_data16 %>% 
  dplyr::distinct(Life_2_Comment)
stored_data17 %>%
  dplyr::distinct(Life_2_Comment)
stored_data18 %>% 
  dplyr::distinct(Life_2_Comment)
stored_data19 %>% 
  dplyr::distinct(Life_2_Comment)
stored_data20 %>% 
  dplyr::distinct(Life_2_Comment)
stored_data21 %>% 
  dplyr::distinct(Life_2_Comment)

stored_data15 %>% 
  dplyr::distinct(FinancialTransaction_FederalExciseTax)
stored_data16 %>%
  dplyr::distinct(FinancialTransaction_FederalExciseTax)
stored_data17 %>% 
  dplyr::distinct(FinancialTransaction_FederalExciseTax)
stored_data18 %>% 
  dplyr::distinct(FinancialTransaction_FederalExciseTax)
stored_data19 %>% 
  dplyr::distinct(FinancialTransaction_FederalExciseTax)
stored_data20 %>%
  dplyr::distinct(FinancialTransaction_FederalExciseTax)
stored_data21 %>% 
  dplyr::distinct(FinancialTransaction_FederalExciseTax)

stored_data15 %>% 
  dplyr::distinct(CedingCompany)

stored_data15 %>% 
  dplyr::distinct(Coverage_CedantRiderName)


str(stored_data_21)

stored_data21 %>% 
  dplyr::distinct(CedingCompany)

stored_data21 %>% 
  dplyr::filter(CedingCompany == "Prudential") -> stored_data22

writexl::write_xlsx(stored_data22,
                    path  = "prudential_202103.xlsx",
                    col_names = TRUE)


stored_data_1 <- head(stored_data1, n = 5)
stored_data_2 <- head(stored_data2, n = 5)
stored_data_3 <- head(stored_data3, n = 5)
stored_data_4 <- head(stored_data4, n = 5)
stored_data_5 <- head(stored_data5, n = 5)
stored_data_6 <- head(stored_data6, n = 5)
stored_data_7 <- head(stored_data7, n = 5)
stored_data_8 <- head(stored_data8, n = 5)
stored_data_9 <- head(stored_data9, n = 5)
stored_data_10 <- head(stored_data10, n = 5)
stored_data_11 <- head(stored_data11, n = 5)
stored_data_12 <- head(stored_data12, n = 5)
stored_data_13 <- head(stored_data13, n = 5)
stored_data_14 <- head(stored_data14, n = 5)
stored_data_15 <- head(stored_data15, n = 5)
stored_data_16 <- head(stored_data16, n = 5)
stored_data_17 <- head(stored_data17, n = 5)
stored_data_18 <- head(stored_data18, n = 5)
stored_data_19 <- head(stored_data19, n = 5)
stored_data_20 <- head(stored_data20, n = 5)
stored_data_21 <- head(stored_data21, n = 5)

dplyr::bind_rows(stored_data_4, stored_data_15, stored_data_16, stored_data_17,
                 stored_data_18, stored_data_19, stored_data_20) -> data_all

dplyr::bind_rows(stored_data_7, stored_data_21) -> data_all

str(data_all)


str(stored_data1)
str(stored_data7)

stored_data1 %>% 
  dplyr::select(-c(Life_1_LastName, Life_1_FirstName, Life_1_MiddleName, 
                   Life_1_DateOfBirth, Life_1_IssueAge, Life_1_SmokingStatus, 
                   Life_1_UnderwritingClass, Life_1_Gender, Life_1_MortalityRating, 
                   Life_1_TemporaryFlatExtraRate, Life_1_PermanentFlatExtraRate)) -> stored_data12

str(stored_data12)

stored_data2 = fread('202009 Korean Re Inforce File - PFS-KOR-2.csv', data.table='FALSE')
stored_data3 = fread('202009 Korean Re Inforce File - PFS-KOR-3.csv', data.table='FALSE')
stored_data4 = fread('202009 Korean Re Inforce File - PFS-KOR-4.csv', data.table='FALSE')
stored_data5 = fread('202009 Korean Re Inforce File - PFS-KRC.csv', data.table='FALSE')
stored_data6 = fread('202009 Korean Re Inforce File - PFS-KRS, PFS-KRP.csv', data.table='FALSE')
stored_data7 = fread('202009 Korean Re Inforce File - PRU, NYL, PFS Canada.csv', data.table='FALSE')

# stored_data7$Policy_PolicyNumber <- as.integer(stored_data7$Policy_PolicyNumber)
# stored_data7$Coverage_IssueAge   <- as.integer(stored_data7$Coverage_IssueAge)
# stored_data7$Coverage_ClientReportedStatReserve   <- as.double(stored_data7$Coverage_ClientReportedStatReserve)

stored_data_1 <- head(stored_data1, n = 5)
stored_data_2 <- head(stored_data2, n = 5)
stored_data_3 <- head(stored_data3, n = 5)
stored_data_4 <- head(stored_data4, n = 5)
stored_data_5 <- head(stored_data5, n = 5)
stored_data_6 <- head(stored_data6, n = 5)
stored_data_7 <- head(stored_data7, n = 5)

dplyr::bind_rows(stored_data_1, stored_data_2, stored_data_3, stored_data_4,
                 stored_data_5, stored_data_6) -> data_all

str(data_all)
str(stored_data_7)

stored_data_7 %>% 
  dplyr::select(-c(Life_1_LastName, Life_1_FirstName, Life_1_MiddleName, 
                   Life_1_DateOfBirth, Life_1_IssueAge, Life_1_SmokingStatus, 
                   Life_1_UnderwritingClass, Life_1_Gender, Life_1_MortalityRating, 
                   Life_1_TemporaryFlatExtraRate, Life_1_PermanentFlatExtraRate)) -> stored_data72

str(stored_data72)

stored_data %>% 
  group_by(RmaTreatyNumber) %>% 
  summarise(sum(Coverage_CededAmount),n=n()) -> stored_data1

 
# 02.Optimum Re

setwd("C:/koreanre/북미data/02.Optimum Re")
getwd()


stored_data1 = fread('Retro_Inforce_0683_20201231.csv', data.table='FALSE')
stored_data2 = fread('Retro_Inforce_0683_20210331.csv', data.table='FALSE')
stored_data3 = fread('Retro_Inforce_0683_20210630.csv', data.table='FALSE')

head(stored_data1, n = 5)
head(stored_data2, n = 5)
head(stored_data3, n = 5)

stored_data1 <- head(stored_data1, n = 5)
stored_data2 <- head(stored_data2, n = 5)
stored_data3 <- head(stored_data3, n = 5)

stored_data1 %>% 
  dplyr::distinct(EQUIVALENT_TESTED)

is.na(stored_data1)

stored_data3 %>% 
  dplyr::distinct(RETRO_POOL_NUMBER)


dplyr::bind_rows(stored_data_1, stored_data_2, stored_data_3) -> data_all

str(data_all)

data_all %>% 
  dplyr::select(-c(INFORCE_DATE, CEDING_TREATY_NUMBER, RETRO_POOL_NUMBER,                    RETRO_POOL_TREATY_NUMBER, RETRO_ACCOUNT_NUMBER, RETRO_ORGANIZATION_NAME,                    RETRO_ACCOUNT_DESCRIPTION, RETRO_TREATY_NUMBER, RETRO_REFERENCE_TREATY,                    RETRO_EXPERIENCE_REFUND, RETRO_LEGAL_TREATY, RETRO_BUSINESS_BLOCK,                    BUSINESS_LINE, CEDING_POLICY_NUMBER, CEDING_POLICY_SEQUENCE,                    CESSION_NUMBER, CESSION_SEQUENCE, POLICY_ISSUE_DATE, ORIGINAL_ISSUE_DATE,                    APPLICATION_DATE, EQUIVALENT_SEX, EQUIVALENT_SMOKER, EQUIVALENT_TESTED,                    EQUIVALENT_RISK_CLASS, CEDING_REINSURANCE_BASIS, JOINT_CODE, RESIDENCE_CODE,                    DIVIDEND_PARTICIPATION, CURRENCY_CODE, GEN_YEAR, ELAPSED_YEARS, BENEFIT_SEQUENCE,                    BENEFIT_CODE, BENEFIT_ISSUE_DATE, BENEFIT_PLAN_CODE, BENEFIT_PLAN_SEQUENCE,                    BENEFIT_PLAN_TYPE, BENEFIT_PLAN_DURATION_TYPE, CEDING_FACE_AMOUNT,                    ULTIMATE_FACE_AMOUNT, INITIAL_REINSURANCE_AMOUNT, BENEFIT_ISSUE_AGE,                    AGE_CALCULATION_METHOD, AGE_RATE_UP_DIFFERENCE, BENEFIT_TERMINATION_AGE,                    PREMIUM_TERMINATION_AGE, RETROCESSION_SEQUENCE, RETROCESSION_BASIS,                    RETROCESSION_RATE_BASIS, RETROCESSION_METHOD, INITIAL_RETROCEDED_AMOUNT,                    ULTIMATE_RETROCEDED_AMOUNT, EXTRA_IND, EXTRA_REASON, EXTRA_FLAT_VALUE,                    EXTRA_FLAT_DURATION, EXTRA_RATING_VALUE, EXTRA_RATING_DURATION,                    EXTRA_CONV_VALUE, EXTRA_CONV_DURATION, PREMIUM_MODE, BENEFIT_ATTAINED_DURATION,                    NET_AMOUNT_AT_RISK, PREMIUM, COMMISSION, ALLOWANCE, CESSION_FEE,                    CESSION_FEE_COMMISSION, FLAT_EXTRA_ALLOWANCE, FLAT_EXTRA, FLAT_EXTRA_COMMISSION,                   FLAT_EXTRA_ALLOWANCE, RATING_EXTRA, RATING_EXTRA_COMMISSION, RATING_EXTRA_ALLOWANCE, NET_PREMIUM, INSURED_COUNT, INSURED1_IDENT_NO, INSURED1_IDENT_SEQ, INSURED1_FIRST_NAME, INSURED1_LAST_NAME, INSURED1_INITIAL, INSURED1_DOB, INSURED1_BIRTHPLACE, INSURED1_SEX, INSURED1_SMOKER, INSURED1_RISK_CLASS, INSURED1_TESTED, INSURED1_AGE, INSURED1_STATUS)) -> data_all_2

str(data_all_2)

# RGA - Canada
setwd("C:/koreanre/북미data/03.RGA/Canada")
getwd()

inforce_RGA_Canada = fread('RGA_Canada_Inforce_20201231_E44.csv', data.table='FALSE')
view(inforce_RGA_Canada)

inforce_RGA_Canada %>% 
  dplyr::distinct(Schedule_Period)

str(stored_data11)

# RGA - international
setwd("C:/koreanre/북미data/03.RGA/International")
getwd()

inforce_RGA_international = fread('RGA_International_Inforce_202012 - 복사본.csv', data.table='FALSE')
view(inforce_RGA_international)

str(inforce_RGA_international)

inforce_RGA_international %>% 
  dplyr::distinct(AAR_MOD)

# RGA - US
setwd("C:/koreanre/북미data/03.RGA/US")
getwd()

inforce_RGA_US = fread('RGA_US_Inforce_202012.csv', data.table='FALSE')

str(inforce_RGA_US)

inforce_RGA_US %>% 
  dplyr::distinct(POLYR)

# SGLA
setwd("C:/koreanre/북미data/04.SGLA")
getwd()

inforce_SGLA = fread('SGLA_Inforce_202012.csv', data.table='FALSE')

str(inforce_SGLA)

inforce_SGLA %>% 
  dplyr::select(-c(AdminReportingType, AgeBasisType, AllowRecapture, BaseFaceAmount,
                   BaseNARAmount, BaseReinsuredAmount, BaseRiderType, CedingCompany, 
                   CessionSequence, CessionStatus, ClientTreatyCodeNumber)) -> data_all_4

inforce_SGLA %>% 
  dplyr::distinct(ReportFromDate)

# Pacific Life Re -> 이것도 읽히지 않음.
setwd("C:/koreanre/북미data/07.Pacific Life Re")
getwd()

stored_data51 = fread('Q42020 KO INF.csv', data.table='FALSE')

str(stored_data51)

stored_data51 %>% 
  dplyr::select(-c(co, pol, cov, cess_seq, lob, reins_co, reporting_co,
                   trans_type, trans_cnt, from_date, to_date, date_reported,
                   mode, pol_duration, reins_duration, cession_no, pol_date,
                   reins_date, state_iss, state_res, joint_type, joint_age,
                   autofac_sw, db_option, par, issue_type, uw_method,
                   treaty_no, reins_type, plan_cd, product_cd)) -> data_all_5

str(data_all_5)

# Reliastar
setwd("C:/koreanre/북미data/05.Reliastar")
getwd()

inforce_reliastar = fread('Reliastar_inforce_202012.csv', data.table = 'FALSE')

str(inforce_reliastar)

inforce_reliastar %>% 
  dplyr::distinct(COV)

# Lombard
setwd("C:/koreanre/북미data/06.Lombard")
getwd()

stored_data71 = fread('Inforce_Lombard_202012.csv', data.table = 'FALSE')
stored_data72 = fread('Inforce_Lombard_202103.csv', data.table = 'FALSE')
stored_data73 = fread('Inforce_Lombard_202106.csv', data.table = 'FALSE')

str(stored_data71)



