-- 보험료 (가정산출용)
-- 마감기준으로 변경

with base as 
(
	select 
		statementdate as 기준일자, rmatreatynumber as RMA특약번호, cedingcompany as 원수보험사명, coverage_companycode as 원수보험사코드,
		blockbusiness as 특약block, coverage_currency as 화폐코드, policy_originalpolicyissuedate as 최초계약일자, policy_currentpolicyissuedate as 현재계약일자,
		policy_currentpolicyduration as 현재_경과기간, policy_originalpolicyduration as 최초_경과기간, life_1_gender as 성별, life_1_dateofbirth as 생년월일,
		life_1_issueage as 가입연령, 
		case when cedingcompany in ('Prudential', 'Pruco Life') then to_char((statementdate::date + '2 month'::interval),'YYYYMM') 
		else to_char((statementdate::date + '1 month'::interval),'YYYYMM') end as new_report_date,
		sum(coverage_faceamount) as 보험가입금액, sum(coverage_cedednetamountrisk) as 출재위험보험금액, sum(coverage_cededamount) as 출재보험금액
		,sum(FinancialTransaction_FirstYearTemporaryFlatExtraPremium + FinancialTransaction_RenewalTemporaryFlatExtraPremium													
    	+ FinancialTransaction_FirstYearPermanentFlatExtraPremium + FinancialTransaction_RenewalPermanentFlatExtraPremium													
    	+ FinancialTransaction_FirstYearStandardPremium + FinancialTransaction_RenewalStandardPremium													
    	+ FinancialTransaction_FirstYearSubstandardPremium + FinancialTransaction_RenewalSubstandardPremium													
    	- FinancialTransaction_FirstYearTemporaryFlatExtraAllowance - FinancialTransaction_RenewalTemporaryFlatExtraAllowance													
    	- FinancialTransaction_FirstYearPermanentFlatExtraAllowance - FinancialTransaction_RenewalPermanentFlatExtraAllowance													
    	- FinancialTransaction_FirstYearStandardAllowance - FinancialTransaction_RenewalStandardAllowance													
    	- FinancialTransaction_FirstYearSubstandardAllowance - FinancialTransaction_RenewalSubstandardAllowance) as premium, count(distinct policy_policynumber) as 계약자수
	from public."2_PREMIUM_1_RMA_2019" pr 
	group by 1,2,3,4,5,6,7,8,9,10,11,12,13
	
	union all 
	
	select 
		statementdate as 기준일자, rmatreatynumber as RMA특약번호, cedingcompany as 원수보험사명, coverage_companycode as 원수보험사코드,
		blockbusiness as 특약block, coverage_currency as 화폐코드, policy_originalpolicyissuedate as 최초계약일자, policy_currentpolicyissuedate as 현재계약일자,
		policy_currentpolicyduration as 현재_경과기간, policy_originalpolicyduration as 최초_경과기간, life_1_gender as 성별, life_1_dateofbirth as 생년월일,
		life_1_issueage as 가입연령, 
		case when cedingcompany in ('Prudential', 'Pruco Life') then to_char((statementdate::date + '2 month'::interval),'YYYYMM') 
		else to_char((statementdate::date + '1 month'::interval),'YYYYMM') end as new_report_date, 
		sum(coverage_faceamount) as 보험가입금액, sum(coverage_cedednetamountrisk) as 출재위험보험금액, sum(coverage_cededamount) as 출재보험금액,
		sum(FinancialTransaction_FirstYearTemporaryFlatExtraPremium + FinancialTransaction_RenewalTemporaryFlatExtraPremium													
    	+ FinancialTransaction_FirstYearPermanentFlatExtraPremium + FinancialTransaction_RenewalPermanentFlatExtraPremium													
    	+ FinancialTransaction_FirstYearStandardPremium + FinancialTransaction_RenewalStandardPremium													
    	+ FinancialTransaction_FirstYearSubstandardPremium + FinancialTransaction_RenewalSubstandardPremium													
    	- FinancialTransaction_FirstYearTemporaryFlatExtraAllowance - FinancialTransaction_RenewalTemporaryFlatExtraAllowance													
    	- FinancialTransaction_FirstYearPermanentFlatExtraAllowance - FinancialTransaction_RenewalPermanentFlatExtraAllowance													
    	- FinancialTransaction_FirstYearStandardAllowance - FinancialTransaction_RenewalStandardAllowance													
    	- FinancialTransaction_FirstYearSubstandardAllowance - FinancialTransaction_RenewalSubstandardAllowance) as premium, count(distinct policy_policynumber) as 계약자수
	from public."2_PREMIUM_1_RMA_2020" pr 
	group by 1,2,3,4,5,6,7,8,9,10,11,12,13
	
	union all 
	
	select 
		statementdate as 기준일자, rmatreatynumber as RMA특약번호, cedingcompany as 원수보험사명, coverage_companycode as 원수보험사코드,
		blockbusiness as 특약block, coverage_currency as 화폐코드, policy_originalpolicyissuedate as 최초계약일자, policy_currentpolicyissuedate as 현재계약일자,
		policy_currentpolicyduration as 현재_경과기간, policy_originalpolicyduration as 최초_경과기간, life_1_gender as 성별, life_1_dateofbirth as 생년월일,
		life_1_issueage as 가입연령,
		case when cedingcompany in ('Prudential', 'Pruco Life') then to_char((statementdate::date + '2 month'::interval),'YYYYMM') 
		else to_char((statementdate::date + '1 month'::interval),'YYYYMM') end as new_report_date,
		sum(coverage_faceamount) as 보험가입금액, sum(coverage_cedednetamountrisk) as 출재위험보험금액, sum(coverage_cededamount) as 출재보험금액
		,sum(FinancialTransaction_FirstYearTemporaryFlatExtraPremium + FinancialTransaction_RenewalTemporaryFlatExtraPremium													
    	+ FinancialTransaction_FirstYearPermanentFlatExtraPremium + FinancialTransaction_RenewalPermanentFlatExtraPremium													
    	+ FinancialTransaction_FirstYearStandardPremium + FinancialTransaction_RenewalStandardPremium													
    	+ FinancialTransaction_FirstYearSubstandardPremium + FinancialTransaction_RenewalSubstandardPremium													
    	- FinancialTransaction_FirstYearTemporaryFlatExtraAllowance - FinancialTransaction_RenewalTemporaryFlatExtraAllowance													
    	- FinancialTransaction_FirstYearPermanentFlatExtraAllowance - FinancialTransaction_RenewalPermanentFlatExtraAllowance													
	    - FinancialTransaction_FirstYearStandardAllowance - FinancialTransaction_RenewalStandardAllowance													
	    - FinancialTransaction_FirstYearSubstandardAllowance - FinancialTransaction_RenewalSubstandardAllowance) as premium, count(distinct policy_policynumber) as 계약자수
	from public."2_PREMIUM_1_RMA_2021" pr 
	group by 1,2,3,4,5,6,7,8,9,10,11,12,13
)

select substr(new_report_date,1,4) as new_reportdate, 원수보험사명 as cedingcompany, RMA특약번호 as treaty_num, 특약block as blockbusiness,
		case when 성별 = 'RMA_GENDER_CODE_MALE' then 'MALE' else 'FEMALE' end as life_1_gender, 화폐코드 as currency,
		(extract(year from age(기준일자, 최초계약일자)) + 1) as duration,
		case when (기준일자 is null or 생년월일 is null) then 가입연령
		when 기준일자 < 생년월일 then extract(year from age(기준일자, 생년월일::date - '100 years'::interval)) + 1 
		else (extract(year from age(기준일자, 생년월일)) + 1) end as ins_age,
		sum(premium) as prem, sum(계약자수) as policy_count,
		case when 화폐코드 = 'CAD' then sum(premium * cctu."USD_CAD") else sum(premium) end as prem_curr
from base a
	inner join public."CURRENCY_CAD_to_USD" cctu on a.new_report_date = cctu.statementdate

where 1=1
and new_report_date is not null
and 최초계약일자 is not null
and new_report_date <= '202109'

group by 1,2,3,4,5,6,7,8

;

-- 보험료 정합성 검증용

with base as 
(
	select 
		statementdate as 기준일자, rmatreatynumber as RMA특약번호, cedingcompany as 원수보험사명, coverage_companycode as 원수보험사코드,
		blockbusiness as 특약block, coverage_currency as 화폐코드, policy_originalpolicyissuedate as 최초계약일자, policy_currentpolicyissuedate as 현재계약일자,
		policy_currentpolicyduration as 현재_경과기간, policy_originalpolicyduration as 최초_경과기간, life_1_gender as 성별, life_1_dateofbirth as 생년월일,
		life_1_issueage as 가입연령, 
		sum(coverage_faceamount) as 보험가입금액, sum(coverage_cedednetamountrisk) as 출재위험보험금액, sum(coverage_cededamount) as 출재보험금액
		,sum(FinancialTransaction_FirstYearTemporaryFlatExtraPremium + FinancialTransaction_RenewalTemporaryFlatExtraPremium													
    + FinancialTransaction_FirstYearPermanentFlatExtraPremium + FinancialTransaction_RenewalPermanentFlatExtraPremium													
    + FinancialTransaction_FirstYearStandardPremium + FinancialTransaction_RenewalStandardPremium													
    + FinancialTransaction_FirstYearSubstandardPremium + FinancialTransaction_RenewalSubstandardPremium													
    - FinancialTransaction_FirstYearTemporaryFlatExtraAllowance - FinancialTransaction_RenewalTemporaryFlatExtraAllowance													
    - FinancialTransaction_FirstYearPermanentFlatExtraAllowance - FinancialTransaction_RenewalPermanentFlatExtraAllowance													
    - FinancialTransaction_FirstYearStandardAllowance - FinancialTransaction_RenewalStandardAllowance													
    - FinancialTransaction_FirstYearSubstandardAllowance - FinancialTransaction_RenewalSubstandardAllowance) as premium, count(*) as 계약자수
	from public."2_PREMIUM_1_RMA_2019" pr 
	group by 1,2,3,4,5,6,7,8,9,10,11,12,13
	
	union all 
	
	select 
		statementdate as 기준일자, rmatreatynumber as RMA특약번호, cedingcompany as 원수보험사명, coverage_companycode as 원수보험사코드,
		blockbusiness as 특약block, coverage_currency as 화폐코드, policy_originalpolicyissuedate as 최초계약일자, policy_currentpolicyissuedate as 현재계약일자,
		policy_currentpolicyduration as 현재_경과기간, policy_originalpolicyduration as 최초_경과기간, life_1_gender as 성별, life_1_dateofbirth as 생년월일,
		life_1_issueage as 가입연령,  
		sum(coverage_faceamount) as 보험가입금액, sum(coverage_cedednetamountrisk) as 출재위험보험금액, sum(coverage_cededamount) as 출재보험금액,
		sum(FinancialTransaction_FirstYearTemporaryFlatExtraPremium + FinancialTransaction_RenewalTemporaryFlatExtraPremium													
    + FinancialTransaction_FirstYearPermanentFlatExtraPremium + FinancialTransaction_RenewalPermanentFlatExtraPremium													
    + FinancialTransaction_FirstYearStandardPremium + FinancialTransaction_RenewalStandardPremium													
    + FinancialTransaction_FirstYearSubstandardPremium + FinancialTransaction_RenewalSubstandardPremium													
    - FinancialTransaction_FirstYearTemporaryFlatExtraAllowance - FinancialTransaction_RenewalTemporaryFlatExtraAllowance													
    - FinancialTransaction_FirstYearPermanentFlatExtraAllowance - FinancialTransaction_RenewalPermanentFlatExtraAllowance													
    - FinancialTransaction_FirstYearStandardAllowance - FinancialTransaction_RenewalStandardAllowance													
    - FinancialTransaction_FirstYearSubstandardAllowance - FinancialTransaction_RenewalSubstandardAllowance) as premium, count(*) as 계약자수
	from public."2_PREMIUM_1_RMA_2020" pr 
	group by 1,2,3,4,5,6,7,8,9,10,11,12,13
	
	union all 
	
	select 
		statementdate as 기준일자, rmatreatynumber as RMA특약번호, cedingcompany as 원수보험사명, coverage_companycode as 원수보험사코드,
		blockbusiness as 특약block, coverage_currency as 화폐코드, policy_originalpolicyissuedate as 최초계약일자, policy_currentpolicyissuedate as 현재계약일자,
		policy_currentpolicyduration as 현재_경과기간, policy_originalpolicyduration as 최초_경과기간, life_1_gender as 성별, life_1_dateofbirth as 생년월일,
		life_1_issueage as 가입연령,
		sum(coverage_faceamount) as 보험가입금액, sum(coverage_cedednetamountrisk) as 출재위험보험금액, sum(coverage_cededamount) as 출재보험금액
		,sum(FinancialTransaction_FirstYearTemporaryFlatExtraPremium + FinancialTransaction_RenewalTemporaryFlatExtraPremium													
    + FinancialTransaction_FirstYearPermanentFlatExtraPremium + FinancialTransaction_RenewalPermanentFlatExtraPremium													
    + FinancialTransaction_FirstYearStandardPremium + FinancialTransaction_RenewalStandardPremium													
    + FinancialTransaction_FirstYearSubstandardPremium + FinancialTransaction_RenewalSubstandardPremium													
    - FinancialTransaction_FirstYearTemporaryFlatExtraAllowance - FinancialTransaction_RenewalTemporaryFlatExtraAllowance													
    - FinancialTransaction_FirstYearPermanentFlatExtraAllowance - FinancialTransaction_RenewalPermanentFlatExtraAllowance													
    - FinancialTransaction_FirstYearStandardAllowance - FinancialTransaction_RenewalStandardAllowance													
    - FinancialTransaction_FirstYearSubstandardAllowance - FinancialTransaction_RenewalSubstandardAllowance) as premium, count(*) as 계약자수
	from public."2_PREMIUM_1_RMA_2021" pr 
	group by 1,2,3,4,5,6,7,8,9,10,11,12,13
)

select to_char(기준일자,'YYYYMM') as statementdate, 원수보험사명 as cedingcompany,
		case when 원수보험사명 in ('Prudential', 'Pruco Life') then to_char((기준일자::date + '2 month'::interval),'YYYYMM') 
		else to_char((기준일자::date + '1 month'::interval),'YYYYMM') end as recon_date,
		sum(premium) as prem
from base
where 1=1
and 기준일자 is not null
and 최초계약일자 is not null

group by 1,2,3
