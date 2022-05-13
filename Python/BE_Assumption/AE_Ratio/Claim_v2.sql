-- 마감기준
-- 월별 자료 사용하는 기준으로 변경
with code1 as 
(
	select 
		reportdate, cedingcompany, substr(RMAtreatynumber, 13, 4) as treaty_num, currency, underwritingyear,
        to_char(paymentdate,'yyyy') as payment_year, statementdate, originalissuedate, claimnotificationdate, paymentdate,
   		policynumber, case when life_1_gender = 'RMA_GENDER_CODE_MALE' then 'MALE' else 'FEMALE' end as gender, Life_1_CauseofDeathDescription, total_claim, paidstatus,
   		
        -- 북미 지급금 자료는 지급일 21일을 기준으로 마감일정을 끊으며, 이를 반영한 코드
        -- ex. 3월23일 지급완료 상태면, 4월 마감 / 3월20일 지급완료 상태면, 3월 마감에 분류
        case when (paidstatus = 'PAID' and to_char(paymentdate, 'dd') < '21') then date_trunc('month', paymentdate + interval '1 months')::date - 1
            when (paidstatus = 'PAID' and to_char(paymentdate, 'dd') >= '21') then date_trunc('month', paymentdate + interval '1 months')::date - 1 + '1 month'::interval
            when (paidstatus = 'PENDING' and to_char(claimnotificationdate, 'dd') < '21') then date_trunc('month', claimnotificationdate + interval '1 months')::date - 1
            when (paidstatus = 'PENDING' and to_char(claimnotificationdate, 'dd') >= '21') then date_trunc('month', claimnotificationdate + interval '1 months')::date - 1 + '1 month'::interval
        end as new_reportdate
        
    from "3_CLAIM_1_RMA_2021" cr
    where 1=1
    and claimnotificationdate is not null
    and originalissuedate is not null
    and (extract(year from age(claimnotificationdate, originalissuedate)) + 1) >= 1 
    
    group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16
)

select 
    reportdate, cedingcompany, treaty_num, currency, underwritingyear, payment_year, a.statementdate, originalissuedate, 
    claimnotificationdate, paymentdate, to_char(new_reportdate,'yyyymm') as new_reportdate, paidstatus, policynumber, gender, Life_1_CauseofDeathDescription,
    
    case when to_char(new_reportdate,'yyyy') = '2021' then '1'
        when (paidstatus = 'PAID' and to_char(new_reportdate,'yyyy') = '2020' and to_char(paymentdate,'yyyymm') > '202003') then '2'
   	    when (to_char(new_reportdate,'yyyy') = '2020' and to_char(paymentdate,'yyyymm') <= '202003') then '3'
   	    when (paidstatus = 'PENDING' and to_char(new_reportdate,'yyyy') = '2020') then '3'
        when (paidstatus = 'PAID' and to_char(new_reportdate,'yyyy') = '2019' and to_char(paymentdate,'yyyymm') > '202003') then '4'
   	    when (to_char(new_reportdate,'yyyy') = '2019' and to_char(paymentdate,'yyyymm') <= '202003') then '5'
   	    when (paidstatus = 'PENDING' and to_char(new_reportdate,'yyyy') = '2019') then '5'
    end as period_key, 
	(extract(year from age(new_reportdate, originalissuedate)) + 1) as duration,
    sum(total_claim) as claim, count(distinct policynumber) as claim_count,
    case when currency = 'CAD' then sum(total_claim * cctu."USD_CAD") else sum(total_claim) end claim_curr
    
     
from code1 a
    left outer join public."CURRENCY_CAD_to_USD" cctu on to_char(a.new_reportdate,'yyyymm') = cctu.statementdate
where 1=1
and to_char(new_reportdate,'yyyymm') <= '202109'

group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17

;

-- New Code ...ing

-- Pending 증번별 추적을 위한 코드, 아래 코드로 데이터 뽑은 뒤 엑셀로 작업함.
with code as 
(
    select koreanre_report_date, policynumber, ceding_company, originalcurrency,
    case when original_issue_date is NULL then current_issue_date else original_issue_date end issue_date, 
    case when cause_of_death_description = 'COVID' then 'COVID' else 'Not COVID' end death_cause, treaty, final_status, total_claim
        from "3_CLAIM_1_RMA_202101_202203_Monthly" crm
    where 1=1
    and final_status = 'PENDING'
    and to_char(koreanre_report_date,'YYYYMM') between '202101' and '202112'
)

select
    koreanre_report_date, policynumber, ceding_company, issue_date, death_cause, treaty, final_status, originalcurrency,
    (extract(year from age(koreanre_report_date, issue_date)) + 1) as duration,
    case when originalcurrency = 'CAD' then sum(total_claim * cctu."USD_CAD") else sum(total_claim) end claim_curr
from code a
    left outer join public."CURRENCY_CAD_to_USD" cctu on to_char(a.koreanre_report_date,'YYYYMM') = cctu.statementdate
where 1=1
and issue_date is not null
group by 1,2,3,4,5,6,7,8

----------------------
-- Paid 건별 자료 추출 쿼리
with code as
(
    select koreanre_report_date, ceding_company, block, originalcurrency, 
    cause_of_death_description as death_cause, treaty, description, voucher_payment_date, final_status, policynumber, 
    case when original_issue_date is NULL then current_issue_date else original_issue_date end issue_date, cause_of_death_description, total_claim

    from "3_CLAIM_1_RMA_202101_202203_Monthly" crm
    where 1=1
    and final_status = 'PENDING'
    and to_char(koreanre_report_date,'YYYYMM') between '202101' and '202112'
)

select
    to_char(koreanre_report_date,'YYYYMM') as reportdate, ceding_company, block, originalcurrency, issue_date, cause_of_death_description as death_cause, 
    treaty, description, voucher_payment_date, final_status, (extract(year from age(koreanre_report_date, issue_date)) + 1) as duration,
    count(distinct policynumber) as claim_count,
    case when originalcurrency = 'CAD' then sum(total_claim * cctu."USD_CAD") else sum(total_claim) end claim_curr

from code a
    left outer join public."CURRENCY_CAD_to_USD" cctu on to_char(koreanre_report_date,'YYYYMM') = cctu.statementdate
where 1=1

group by 1,2,3,4,5,6,7,8,9,10,11