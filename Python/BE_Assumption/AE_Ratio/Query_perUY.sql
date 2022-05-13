# 1) UY별 실적 - 년도별 보험료													
													
#  (1) primerica/NBL 이외의 사 : treaty number 별 													
													
with base as (													
select													
substr(rmatreatynumber, 13, 4) treaty_number,													
cast(extract(year from policy_currentpolicyissuedate) as text) UY,													
cast(extract(year from statementdate) as text) AY,													
sum(FinancialTransaction_FirstYearTemporaryFlatExtraPremium + FinancialTransaction_RenewalTemporaryFlatExtraPremium													
    + FinancialTransaction_FirstYearPermanentFlatExtraPremium + FinancialTransaction_RenewalPermanentFlatExtraPremium													
    + FinancialTransaction_FirstYearStandardPremium + FinancialTransaction_RenewalStandardPremium													
    + FinancialTransaction_FirstYearSubstandardPremium + FinancialTransaction_RenewalSubstandardPremium													
    - FinancialTransaction_FirstYearTemporaryFlatExtraAllowance - FinancialTransaction_RenewalTemporaryFlatExtraAllowance													
    - FinancialTransaction_FirstYearPermanentFlatExtraAllowance - FinancialTransaction_RenewalPermanentFlatExtraAllowance													
    - FinancialTransaction_FirstYearStandardAllowance - FinancialTransaction_RenewalStandardAllowance													
    - FinancialTransaction_FirstYearSubstandardAllowance - FinancialTransaction_RenewalSubstandardAllowance) premium													
from public."2_PREMIUM_1_RMA_2019"													
group by substr(rmatreatynumber, 13, 4),  													
 cast(extract(year from policy_currentpolicyissuedate) as text), 													
 cast(extract(year from statementdate) as text)													
													
union all 													
													
select													
substr(rmatreatynumber, 13, 4) treaty_number,													
cast(extract(year from policy_currentpolicyissuedate) as text) UY,													
cast(extract(year from statementdate) as text) AY,													
sum(FinancialTransaction_FirstYearTemporaryFlatExtraPremium + FinancialTransaction_RenewalTemporaryFlatExtraPremium													
    + FinancialTransaction_FirstYearPermanentFlatExtraPremium + FinancialTransaction_RenewalPermanentFlatExtraPremium													
    + FinancialTransaction_FirstYearStandardPremium + FinancialTransaction_RenewalStandardPremium													
    + FinancialTransaction_FirstYearSubstandardPremium + FinancialTransaction_RenewalSubstandardPremium													
    - FinancialTransaction_FirstYearTemporaryFlatExtraAllowance - FinancialTransaction_RenewalTemporaryFlatExtraAllowance													
    - FinancialTransaction_FirstYearPermanentFlatExtraAllowance - FinancialTransaction_RenewalPermanentFlatExtraAllowance													
    - FinancialTransaction_FirstYearStandardAllowance - FinancialTransaction_RenewalStandardAllowance													
    - FinancialTransaction_FirstYearSubstandardAllowance - FinancialTransaction_RenewalSubstandardAllowance) premium													
from public."2_PREMIUM_1_RMA_2020"													
group by substr(rmatreatynumber, 13, 4),  													
 cast(extract(year from policy_currentpolicyissuedate) as text), 													
 cast(extract(year from statementdate) as text)													
													
union all 													
													
select													
substr(rmatreatynumber, 13, 4) treaty_number,													
cast(extract(year from policy_currentpolicyissuedate) as text) UY,													
cast(extract(year from statementdate) as text) AY,													
sum(FinancialTransaction_FirstYearTemporaryFlatExtraPremium + FinancialTransaction_RenewalTemporaryFlatExtraPremium													
    + FinancialTransaction_FirstYearPermanentFlatExtraPremium + FinancialTransaction_RenewalPermanentFlatExtraPremium													
    + FinancialTransaction_FirstYearStandardPremium + FinancialTransaction_RenewalStandardPremium													
    + FinancialTransaction_FirstYearSubstandardPremium + FinancialTransaction_RenewalSubstandardPremium													
    - FinancialTransaction_FirstYearTemporaryFlatExtraAllowance - FinancialTransaction_RenewalTemporaryFlatExtraAllowance													
    - FinancialTransaction_FirstYearPermanentFlatExtraAllowance - FinancialTransaction_RenewalPermanentFlatExtraAllowance													
    - FinancialTransaction_FirstYearStandardAllowance - FinancialTransaction_RenewalStandardAllowance													
    - FinancialTransaction_FirstYearSubstandardAllowance - FinancialTransaction_RenewalSubstandardAllowance) premium													
from public."2_PREMIUM_1_RMA_2021"													
group by substr(rmatreatynumber, 13, 4),  													
 cast(extract(year from policy_currentpolicyissuedate) as text), 													
 cast(extract(year from statementdate) as text)													
), base2 as (													
select													
treaty_number, uy, 													
case when AY = '2019' then premium else 0 end as AY_2019,													
case when AY = '2020' then premium else 0 end as AY_2020,													
case when AY = '2021' then premium else 0 end as AY_2021													
from base													
)													
select													
treaty_number, uy, 													
sum(AY_2019) AY_2019_premium,													
sum(AY_2020) AY_2020_premium,													
sum(AY_2021) AY_2021_premium													
from base2													
group by treaty_number, uy													
													
#  (2) primerica/NBL : blockbusiness 별 													
													
with base as (													
select													
cedingcompany || blockbusiness classification, cedingcompany, blockbusiness,													
cast(extract(year from policy_currentpolicyissuedate) as text) UY,													
cast(extract(year from statementdate) as text) AY,													
sum(FinancialTransaction_FirstYearTemporaryFlatExtraPremium + FinancialTransaction_RenewalTemporaryFlatExtraPremium													
    + FinancialTransaction_FirstYearPermanentFlatExtraPremium + FinancialTransaction_RenewalPermanentFlatExtraPremium													
    + FinancialTransaction_FirstYearStandardPremium + FinancialTransaction_RenewalStandardPremium													
    + FinancialTransaction_FirstYearSubstandardPremium + FinancialTransaction_RenewalSubstandardPremium													
    - FinancialTransaction_FirstYearTemporaryFlatExtraAllowance - FinancialTransaction_RenewalTemporaryFlatExtraAllowance													
    - FinancialTransaction_FirstYearPermanentFlatExtraAllowance - FinancialTransaction_RenewalPermanentFlatExtraAllowance													
    - FinancialTransaction_FirstYearStandardAllowance - FinancialTransaction_RenewalStandardAllowance													
    - FinancialTransaction_FirstYearSubstandardAllowance - FinancialTransaction_RenewalSubstandardAllowance) premium													
from public."2_PREMIUM_1_RMA_2019"													
group by cedingcompany || blockbusiness, cedingcompany, blockbusiness,													
 cast(extract(year from policy_currentpolicyissuedate) as text), 													
 cast(extract(year from statementdate) as text)													
													
union all 													
													
select													
cedingcompany || blockbusiness classification, cedingcompany, blockbusiness,													
cast(extract(year from policy_currentpolicyissuedate) as text) UY,													
cast(extract(year from statementdate) as text) AY,													
sum(FinancialTransaction_FirstYearTemporaryFlatExtraPremium + FinancialTransaction_RenewalTemporaryFlatExtraPremium													
    + FinancialTransaction_FirstYearPermanentFlatExtraPremium + FinancialTransaction_RenewalPermanentFlatExtraPremium													
    + FinancialTransaction_FirstYearStandardPremium + FinancialTransaction_RenewalStandardPremium													
    + FinancialTransaction_FirstYearSubstandardPremium + FinancialTransaction_RenewalSubstandardPremium													
    - FinancialTransaction_FirstYearTemporaryFlatExtraAllowance - FinancialTransaction_RenewalTemporaryFlatExtraAllowance													
    - FinancialTransaction_FirstYearPermanentFlatExtraAllowance - FinancialTransaction_RenewalPermanentFlatExtraAllowance													
    - FinancialTransaction_FirstYearStandardAllowance - FinancialTransaction_RenewalStandardAllowance													
    - FinancialTransaction_FirstYearSubstandardAllowance - FinancialTransaction_RenewalSubstandardAllowance) premium													
from public."2_PREMIUM_1_RMA_2020"													
group by cedingcompany || blockbusiness, cedingcompany, blockbusiness,													
 cast(extract(year from policy_currentpolicyissuedate) as text), 													
 cast(extract(year from statementdate) as text)													
													
union all 													
													
select													
cedingcompany || blockbusiness classification, cedingcompany, blockbusiness,													
cast(extract(year from policy_currentpolicyissuedate) as text) UY,													
cast(extract(year from statementdate) as text) AY,													
sum(FinancialTransaction_FirstYearTemporaryFlatExtraPremium + FinancialTransaction_RenewalTemporaryFlatExtraPremium													
    + FinancialTransaction_FirstYearPermanentFlatExtraPremium + FinancialTransaction_RenewalPermanentFlatExtraPremium													
    + FinancialTransaction_FirstYearStandardPremium + FinancialTransaction_RenewalStandardPremium													
    + FinancialTransaction_FirstYearSubstandardPremium + FinancialTransaction_RenewalSubstandardPremium													
    - FinancialTransaction_FirstYearTemporaryFlatExtraAllowance - FinancialTransaction_RenewalTemporaryFlatExtraAllowance													
    - FinancialTransaction_FirstYearPermanentFlatExtraAllowance - FinancialTransaction_RenewalPermanentFlatExtraAllowance													
    - FinancialTransaction_FirstYearStandardAllowance - FinancialTransaction_RenewalStandardAllowance													
    - FinancialTransaction_FirstYearSubstandardAllowance - FinancialTransaction_RenewalSubstandardAllowance) premium													
from public."2_PREMIUM_1_RMA_2021"													
group by cedingcompany || blockbusiness, cedingcompany, blockbusiness,													
 cast(extract(year from policy_currentpolicyissuedate) as text), 													
 cast(extract(year from statementdate) as text)													
), base2 as (													
select													
classification, uy, cedingcompany, blockbusiness,													
case when AY = '2019' then premium else 0 end as AY_2019,													
case when AY = '2020' then premium else 0 end as AY_2020,													
case when AY = '2021' then premium else 0 end as AY_2021													
from base													
)													
select													
uy, cedingcompany, blockbusiness,													
sum(AY_2019) AY_2019_premium,													
sum(AY_2020) AY_2020_premium,													
sum(AY_2021) AY_2021_premium													
from base2													
group by uy, cedingcompany, blockbusiness													
													
# 2) UY별 실적 - 년도별 보험금													
													
#  (1) primerica/NBL 이외의 사 : treaty number 별 													
													
with base as (													
select													
substr(rmatreatynumber, 13, 4) treaty_number,													
cast(extract(year from currentissuedate) as text) UY,													
cast(extract(year from paymentdate) as text) AY,													
sum(total_claim) claim													
from public."3_CLAIM_1_RMA_2021"													
where paidstatus = 'PAID' and reportdate = '2021-09-30'													
group by substr(rmatreatynumber, 13, 4),  													
 cast(extract(year from currentissuedate) as text),													
 cast(extract(year from paymentdate) as text)													
), base2 as (													
select													
treaty_number, uy, 													
case when AY = '2019' then claim else 0 end as AY_2019,													
case when AY = '2020' then claim else 0 end as AY_2020,													
case when AY = '2021' then claim else 0 end as AY_2021													
from base													
)													
select													
treaty_number, uy, 													
sum(AY_2019) AY_2019_claim,													
sum(AY_2020) AY_2020_claim,													
sum(AY_2021) AY_2021_claim													
from base2													
group by treaty_number, uy													
													
#  (2) primerica/NBL : blockbusiness 별 													
													
with base as (													
select													
cedingcompany || block classification, cedingcompany, block,													
cast(extract(year from currentissuedate) as text) UY,													
cast(extract(year from paymentdate) as text) AY,													
sum(total_claim) claim													
from public."3_CLAIM_1_RMA_2021"													
where paidstatus = 'PAID' and reportdate = '2021-09-30'													
group by cedingcompany || block, cedingcompany, block,													
 cast(extract(year from currentissuedate) as text),													
 cast(extract(year from paymentdate) as text)													
), base2 as (													
select													
classification, uy, cedingcompany, block,													
case when AY = '2019' then claim else 0 end as AY_2019,													
case when AY = '2020' then claim else 0 end as AY_2020,													
case when AY = '2021' then claim else 0 end as AY_2021													
from base													
)													
select													
uy, cedingcompany, block,													
sum(AY_2019) AY_2019_claim,													
sum(AY_2020) AY_2020_claim,													
sum(AY_2021) AY_2021_claim													
from base2													
group by uy, cedingcompany, block													
													
# 3) UY별 실적 - 월별 보험료													
													
#  (1) primerica/NBL 이외의 사 : treaty number 별 													
													
with base as (													
select													
substr(rmatreatynumber, 13, 4) treaty_number,													
cast(extract(year from policy_currentpolicyissuedate) as text) || lpad(cast(extract(month from policy_currentpolicyissuedate) as text),2,'0') UY,													
cast(extract(year from statementdate) as text) || lpad(cast(extract(month from statementdate) as text),2,'0') AY,													
sum(FinancialTransaction_FirstYearTemporaryFlatExtraPremium + FinancialTransaction_RenewalTemporaryFlatExtraPremium													
    + FinancialTransaction_FirstYearPermanentFlatExtraPremium + FinancialTransaction_RenewalPermanentFlatExtraPremium													
    + FinancialTransaction_FirstYearStandardPremium + FinancialTransaction_RenewalStandardPremium													
    + FinancialTransaction_FirstYearSubstandardPremium + FinancialTransaction_RenewalSubstandardPremium													
    - FinancialTransaction_FirstYearTemporaryFlatExtraAllowance - FinancialTransaction_RenewalTemporaryFlatExtraAllowance													
    - FinancialTransaction_FirstYearPermanentFlatExtraAllowance - FinancialTransaction_RenewalPermanentFlatExtraAllowance													
    - FinancialTransaction_FirstYearStandardAllowance - FinancialTransaction_RenewalStandardAllowance													
    - FinancialTransaction_FirstYearSubstandardAllowance - FinancialTransaction_RenewalSubstandardAllowance) premium													
from public."2_PREMIUM_1_RMA_2019"													
group by substr(rmatreatynumber, 13, 4),  													
 cast(extract(year from policy_currentpolicyissuedate) as text) || lpad(cast(extract(month from policy_currentpolicyissuedate) as text),2,'0'), 													
 cast(extract(year from statementdate) as text) || lpad(cast(extract(month from statementdate) as text),2,'0')													
 													
union all													
													
select													
substr(rmatreatynumber, 13, 4) treaty_number,													
cast(extract(year from policy_currentpolicyissuedate) as text) || lpad(cast(extract(month from policy_currentpolicyissuedate) as text),2,'0') UY,													
cast(extract(year from statementdate) as text) || lpad(cast(extract(month from statementdate) as text),2,'0') AY,													
sum(FinancialTransaction_FirstYearTemporaryFlatExtraPremium + FinancialTransaction_RenewalTemporaryFlatExtraPremium													
    + FinancialTransaction_FirstYearPermanentFlatExtraPremium + FinancialTransaction_RenewalPermanentFlatExtraPremium													
    + FinancialTransaction_FirstYearStandardPremium + FinancialTransaction_RenewalStandardPremium													
    + FinancialTransaction_FirstYearSubstandardPremium + FinancialTransaction_RenewalSubstandardPremium													
    - FinancialTransaction_FirstYearTemporaryFlatExtraAllowance - FinancialTransaction_RenewalTemporaryFlatExtraAllowance													
    - FinancialTransaction_FirstYearPermanentFlatExtraAllowance - FinancialTransaction_RenewalPermanentFlatExtraAllowance													
    - FinancialTransaction_FirstYearStandardAllowance - FinancialTransaction_RenewalStandardAllowance													
    - FinancialTransaction_FirstYearSubstandardAllowance - FinancialTransaction_RenewalSubstandardAllowance) premium													
from public."2_PREMIUM_1_RMA_2020"													
group by substr(rmatreatynumber, 13, 4),  													
 cast(extract(year from policy_currentpolicyissuedate) as text) || lpad(cast(extract(month from policy_currentpolicyissuedate) as text),2,'0'), 													
 cast(extract(year from statementdate) as text) || lpad(cast(extract(month from statementdate) as text),2,'0')													
 													
 union all 													
 													
select													
substr(rmatreatynumber, 13, 4) treaty_number,													
cast(extract(year from policy_currentpolicyissuedate) as text) || lpad(cast(extract(month from policy_currentpolicyissuedate) as text),2,'0') UY,													
cast(extract(year from statementdate) as text) || lpad(cast(extract(month from statementdate) as text),2,'0') AY,													
sum(FinancialTransaction_FirstYearTemporaryFlatExtraPremium + FinancialTransaction_RenewalTemporaryFlatExtraPremium													
    + FinancialTransaction_FirstYearPermanentFlatExtraPremium + FinancialTransaction_RenewalPermanentFlatExtraPremium													
    + FinancialTransaction_FirstYearStandardPremium + FinancialTransaction_RenewalStandardPremium													
    + FinancialTransaction_FirstYearSubstandardPremium + FinancialTransaction_RenewalSubstandardPremium													
    - FinancialTransaction_FirstYearTemporaryFlatExtraAllowance - FinancialTransaction_RenewalTemporaryFlatExtraAllowance													
    - FinancialTransaction_FirstYearPermanentFlatExtraAllowance - FinancialTransaction_RenewalPermanentFlatExtraAllowance													
    - FinancialTransaction_FirstYearStandardAllowance - FinancialTransaction_RenewalStandardAllowance													
    - FinancialTransaction_FirstYearSubstandardAllowance - FinancialTransaction_RenewalSubstandardAllowance) premium													
from public."2_PREMIUM_1_RMA_2021"													
group by substr(rmatreatynumber, 13, 4),  													
 cast(extract(year from policy_currentpolicyissuedate) as text) || lpad(cast(extract(month from policy_currentpolicyissuedate) as text),2,'0'), 													
 cast(extract(year from statementdate) as text) || lpad(cast(extract(month from statementdate) as text),2,'0')													
), base2 as (													
select													
treaty_number, uy, 													
case when AY = '201901' then premium else 0 end as AY_201901,													
case when AY = '201902' then premium else 0 end as AY_201902,													
case when AY = '201903' then premium else 0 end as AY_201903,													
case when AY = '201904' then premium else 0 end as AY_201904,													
case when AY = '201905' then premium else 0 end as AY_201905,													
case when AY = '201906' then premium else 0 end as AY_201906,													
case when AY = '201907' then premium else 0 end as AY_201907,													
case when AY = '201908' then premium else 0 end as AY_201908,													
case when AY = '201909' then premium else 0 end as AY_201909,													
case when AY = '201910' then premium else 0 end as AY_201910,													
case when AY = '201911' then premium else 0 end as AY_201911,													
case when AY = '201912' then premium else 0 end as AY_201912,													
													
case when AY = '202001' then premium else 0 end as AY_202001,													
case when AY = '202002' then premium else 0 end as AY_202002,													
case when AY = '202003' then premium else 0 end as AY_202003,													
case when AY = '202004' then premium else 0 end as AY_202004,													
case when AY = '202005' then premium else 0 end as AY_202005,													
case when AY = '202006' then premium else 0 end as AY_202006,													
case when AY = '202007' then premium else 0 end as AY_202007,													
case when AY = '202008' then premium else 0 end as AY_202008,													
case when AY = '202009' then premium else 0 end as AY_202009,													
case when AY = '202010' then premium else 0 end as AY_202010,													
case when AY = '202011' then premium else 0 end as AY_202011,													
case when AY = '202012' then premium else 0 end as AY_202012,													
													
case when AY = '202101' then premium else 0 end as AY_202101,													
case when AY = '202102' then premium else 0 end as AY_202102,													
case when AY = '202103' then premium else 0 end as AY_202103,													
case when AY = '202104' then premium else 0 end as AY_202104,													
case when AY = '202105' then premium else 0 end as AY_202105,													
case when AY = '202106' then premium else 0 end as AY_202106,													
case when AY = '202107' then premium else 0 end as AY_202107,													
case when AY = '202108' then premium else 0 end as AY_202108,													
case when AY = '202109' then premium else 0 end as AY_202109,													
case when AY = '202110' then premium else 0 end as AY_202110,													
case when AY = '202111' then premium else 0 end as AY_202111,													
case when AY = '202112' then premium else 0 end as AY_202112													
from base													
)													
select													
treaty_number, uy, 													
sum(AY_201901) AY_201901,													
sum(AY_201902) AY_201902,													
sum(AY_201903) AY_201903,													
sum(AY_201904) AY_201904,													
sum(AY_201905) AY_201905,													
sum(AY_201906) AY_201906,													
sum(AY_201907) AY_201907,													
sum(AY_201908) AY_201908,													
sum(AY_201909) AY_201909, 													
sum(AY_201910) AY_201910,													
sum(AY_201911) AY_201911,													
sum(AY_201912) AY_201912,													
													
sum(AY_202001) AY_202001,													
sum(AY_202002) AY_202002,													
sum(AY_202003) AY_202003,													
sum(AY_202004) AY_202004,													
sum(AY_202005) AY_202005,													
sum(AY_202006) AY_202006,													
sum(AY_202007) AY_202007,													
sum(AY_202008) AY_202008,													
sum(AY_202009) AY_202009, 													
sum(AY_202010) AY_202010,													
sum(AY_202011) AY_202011,													
sum(AY_202012) AY_202012,													
													
sum(AY_202101) AY_202101,													
sum(AY_202102) AY_202102,													
sum(AY_202103) AY_202103,													
sum(AY_202104) AY_202104,													
sum(AY_202105) AY_202105,													
sum(AY_202106) AY_202106,													
sum(AY_202107) AY_202107,													
sum(AY_202108) AY_202108,													
sum(AY_202109) AY_202109, 													
sum(AY_202110) AY_202110,													
sum(AY_202111) AY_202111,													
sum(AY_202112) AY_202112													
from base2													
group by treaty_number, uy													
													
#  (2) primerica/NBL : blockbusiness 별 													
													
with base as (													
select													
cedingcompany || blockbusiness classification, cedingcompany, blockbusiness,													
cast(extract(year from policy_currentpolicyissuedate) as text) || lpad(cast(extract(month from policy_currentpolicyissuedate) as text),2,'0') UY,													
cast(extract(year from statementdate) as text) || lpad(cast(extract(month from statementdate) as text),2,'0') AY,													
sum(FinancialTransaction_FirstYearTemporaryFlatExtraPremium + FinancialTransaction_RenewalTemporaryFlatExtraPremium													
    + FinancialTransaction_FirstYearPermanentFlatExtraPremium + FinancialTransaction_RenewalPermanentFlatExtraPremium													
    + FinancialTransaction_FirstYearStandardPremium + FinancialTransaction_RenewalStandardPremium													
    + FinancialTransaction_FirstYearSubstandardPremium + FinancialTransaction_RenewalSubstandardPremium													
    - FinancialTransaction_FirstYearTemporaryFlatExtraAllowance - FinancialTransaction_RenewalTemporaryFlatExtraAllowance													
    - FinancialTransaction_FirstYearPermanentFlatExtraAllowance - FinancialTransaction_RenewalPermanentFlatExtraAllowance													
    - FinancialTransaction_FirstYearStandardAllowance - FinancialTransaction_RenewalStandardAllowance													
    - FinancialTransaction_FirstYearSubstandardAllowance - FinancialTransaction_RenewalSubstandardAllowance) premium													
from public."2_PREMIUM_1_RMA_2019"													
group by cedingcompany || blockbusiness, cedingcompany, blockbusiness,													
 cast(extract(year from policy_currentpolicyissuedate) as text) || lpad(cast(extract(month from policy_currentpolicyissuedate) as text),2,'0'), 													
 cast(extract(year from statementdate) as text) || lpad(cast(extract(month from statementdate) as text),2,'0')													
 													
union all													
													
select													
cedingcompany || blockbusiness classification, cedingcompany, blockbusiness,													
cast(extract(year from policy_currentpolicyissuedate) as text) || lpad(cast(extract(month from policy_currentpolicyissuedate) as text),2,'0') UY,													
cast(extract(year from statementdate) as text) || lpad(cast(extract(month from statementdate) as text),2,'0') AY,													
sum(FinancialTransaction_FirstYearTemporaryFlatExtraPremium + FinancialTransaction_RenewalTemporaryFlatExtraPremium													
    + FinancialTransaction_FirstYearPermanentFlatExtraPremium + FinancialTransaction_RenewalPermanentFlatExtraPremium													
    + FinancialTransaction_FirstYearStandardPremium + FinancialTransaction_RenewalStandardPremium													
    + FinancialTransaction_FirstYearSubstandardPremium + FinancialTransaction_RenewalSubstandardPremium													
    - FinancialTransaction_FirstYearTemporaryFlatExtraAllowance - FinancialTransaction_RenewalTemporaryFlatExtraAllowance													
    - FinancialTransaction_FirstYearPermanentFlatExtraAllowance - FinancialTransaction_RenewalPermanentFlatExtraAllowance													
    - FinancialTransaction_FirstYearStandardAllowance - FinancialTransaction_RenewalStandardAllowance													
    - FinancialTransaction_FirstYearSubstandardAllowance - FinancialTransaction_RenewalSubstandardAllowance) premium													
from public."2_PREMIUM_1_RMA_2020"													
group by cedingcompany || blockbusiness, cedingcompany, blockbusiness,													
 cast(extract(year from policy_currentpolicyissuedate) as text) || lpad(cast(extract(month from policy_currentpolicyissuedate) as text),2,'0'), 													
 cast(extract(year from statementdate) as text) || lpad(cast(extract(month from statementdate) as text),2,'0')													
 													
union all 													
 													
select													
cedingcompany || blockbusiness classification, cedingcompany, blockbusiness,													
cast(extract(year from policy_currentpolicyissuedate) as text) || lpad(cast(extract(month from policy_currentpolicyissuedate) as text),2,'0') UY,													
cast(extract(year from statementdate) as text) || lpad(cast(extract(month from statementdate) as text),2,'0') AY,													
sum(FinancialTransaction_FirstYearTemporaryFlatExtraPremium + FinancialTransaction_RenewalTemporaryFlatExtraPremium													
    + FinancialTransaction_FirstYearPermanentFlatExtraPremium + FinancialTransaction_RenewalPermanentFlatExtraPremium													
    + FinancialTransaction_FirstYearStandardPremium + FinancialTransaction_RenewalStandardPremium													
    + FinancialTransaction_FirstYearSubstandardPremium + FinancialTransaction_RenewalSubstandardPremium													
    - FinancialTransaction_FirstYearTemporaryFlatExtraAllowance - FinancialTransaction_RenewalTemporaryFlatExtraAllowance													
    - FinancialTransaction_FirstYearPermanentFlatExtraAllowance - FinancialTransaction_RenewalPermanentFlatExtraAllowance													
    - FinancialTransaction_FirstYearStandardAllowance - FinancialTransaction_RenewalStandardAllowance													
    - FinancialTransaction_FirstYearSubstandardAllowance - FinancialTransaction_RenewalSubstandardAllowance) premium													
from public."2_PREMIUM_1_RMA_2021"													
group by cedingcompany || blockbusiness, cedingcompany, blockbusiness,													
 cast(extract(year from policy_currentpolicyissuedate) as text) || lpad(cast(extract(month from policy_currentpolicyissuedate) as text),2,'0'), 													
 cast(extract(year from statementdate) as text) || lpad(cast(extract(month from statementdate) as text),2,'0')													
), base2 as (													
select													
classification, uy, cedingcompany, blockbusiness,													
case when AY = '201901' then premium else 0 end as AY_201901,													
case when AY = '201902' then premium else 0 end as AY_201902,													
case when AY = '201903' then premium else 0 end as AY_201903,													
case when AY = '201904' then premium else 0 end as AY_201904,													
case when AY = '201905' then premium else 0 end as AY_201905,													
case when AY = '201906' then premium else 0 end as AY_201906,													
case when AY = '201907' then premium else 0 end as AY_201907,													
case when AY = '201908' then premium else 0 end as AY_201908,													
case when AY = '201909' then premium else 0 end as AY_201909,													
case when AY = '201910' then premium else 0 end as AY_201910,													
case when AY = '201911' then premium else 0 end as AY_201911,													
case when AY = '201912' then premium else 0 end as AY_201912,													
													
case when AY = '202001' then premium else 0 end as AY_202001,													
case when AY = '202002' then premium else 0 end as AY_202002,													
case when AY = '202003' then premium else 0 end as AY_202003,													
case when AY = '202004' then premium else 0 end as AY_202004,													
case when AY = '202005' then premium else 0 end as AY_202005,													
case when AY = '202006' then premium else 0 end as AY_202006,													
case when AY = '202007' then premium else 0 end as AY_202007,													
case when AY = '202008' then premium else 0 end as AY_202008,													
case when AY = '202009' then premium else 0 end as AY_202009,													
case when AY = '202010' then premium else 0 end as AY_202010,													
case when AY = '202011' then premium else 0 end as AY_202011,													
case when AY = '202012' then premium else 0 end as AY_202012,													
													
case when AY = '202101' then premium else 0 end as AY_202101,													
case when AY = '202102' then premium else 0 end as AY_202102,													
case when AY = '202103' then premium else 0 end as AY_202103,													
case when AY = '202104' then premium else 0 end as AY_202104,													
case when AY = '202105' then premium else 0 end as AY_202105,													
case when AY = '202106' then premium else 0 end as AY_202106,													
case when AY = '202107' then premium else 0 end as AY_202107,													
case when AY = '202108' then premium else 0 end as AY_202108,													
case when AY = '202109' then premium else 0 end as AY_202109,													
case when AY = '202110' then premium else 0 end as AY_202110,													
case when AY = '202111' then premium else 0 end as AY_202111,													
case when AY = '202112' then premium else 0 end as AY_202112													
from base													
)													
select													
uy, cedingcompany, blockbusiness,													
sum(AY_201901) AY_201901,													
sum(AY_201902) AY_201902,													
sum(AY_201903) AY_201903,													
sum(AY_201904) AY_201904,													
sum(AY_201905) AY_201905,													
sum(AY_201906) AY_201906,													
sum(AY_201907) AY_201907,													
sum(AY_201908) AY_201908,													
sum(AY_201909) AY_201909, 													
sum(AY_201910) AY_201910,													
sum(AY_201911) AY_201911,													
sum(AY_201912) AY_201912,													
													
sum(AY_202001) AY_202001,													
sum(AY_202002) AY_202002,													
sum(AY_202003) AY_202003,													
sum(AY_202004) AY_202004,													
sum(AY_202005) AY_202005,													
sum(AY_202006) AY_202006,													
sum(AY_202007) AY_202007,													
sum(AY_202008) AY_202008,													
sum(AY_202009) AY_202009, 													
sum(AY_202010) AY_202010,													
sum(AY_202011) AY_202011,													
sum(AY_202012) AY_202012,													
													
sum(AY_202101) AY_202101,													
sum(AY_202102) AY_202102,													
sum(AY_202103) AY_202103,													
sum(AY_202104) AY_202104,													
sum(AY_202105) AY_202105,													
sum(AY_202106) AY_202106,													
sum(AY_202107) AY_202107,													
sum(AY_202108) AY_202108,													
sum(AY_202109) AY_202109, 													
sum(AY_202110) AY_202110,													
sum(AY_202111) AY_202111,													
sum(AY_202112) AY_202112													
from base2													
group by uy, cedingcompany, blockbusiness													
													
# 4) UY별 실적 - 월별 보험금													
													
#  (1) primerica/NBL 이외의 사 : treaty number 별 													
													
with base as (													
select													
substr(rmatreatynumber, 13, 4) treaty_number,													
cast(extract(year from currentissuedate) as text) || lpad(cast(extract(month from currentissuedate) as text),2,'0') UY,													
cast(extract(year from paymentdate) as text) || lpad(cast(extract(month from paymentdate) as text),2,'0') AY,													
sum(total_claim) claim													
from public."3_CLAIM_1_RMA_2021"													
where paidstatus = 'PAID' and reportdate = '2021-09-30'													
group by substr(rmatreatynumber, 13, 4),  													
 cast(extract(year from currentissuedate) as text) || lpad(cast(extract(month from currentissuedate) as text),2,'0'),													
 cast(extract(year from paymentdate) as text) || lpad(cast(extract(month from paymentdate) as text),2,'0')													
), base2 as (													
select													
treaty_number, uy, 													
case when AY = '201901' then claim else 0 end as AY_201901,													
case when AY = '201902' then claim else 0 end as AY_201902,													
case when AY = '201903' then claim else 0 end as AY_201903,													
case when AY = '201904' then claim else 0 end as AY_201904,													
case when AY = '201905' then claim else 0 end as AY_201905,													
case when AY = '201906' then claim else 0 end as AY_201906,													
case when AY = '201907' then claim else 0 end as AY_201907,													
case when AY = '201908' then claim else 0 end as AY_201908,													
case when AY = '201909' then claim else 0 end as AY_201909,													
case when AY = '201910' then claim else 0 end as AY_201910,													
case when AY = '201911' then claim else 0 end as AY_201911,													
case when AY = '201912' then claim else 0 end as AY_201912,													
													
case when AY = '202001' then claim else 0 end as AY_202001,													
case when AY = '202002' then claim else 0 end as AY_202002,													
case when AY = '202003' then claim else 0 end as AY_202003,													
case when AY = '202004' then claim else 0 end as AY_202004,													
case when AY = '202005' then claim else 0 end as AY_202005,													
case when AY = '202006' then claim else 0 end as AY_202006,													
case when AY = '202007' then claim else 0 end as AY_202007,													
case when AY = '202008' then claim else 0 end as AY_202008,													
case when AY = '202009' then claim else 0 end as AY_202009,													
case when AY = '202010' then claim else 0 end as AY_202010,													
case when AY = '202011' then claim else 0 end as AY_202011,													
case when AY = '202012' then claim else 0 end as AY_202012,													
													
case when AY = '202101' then claim else 0 end as AY_202101,													
case when AY = '202102' then claim else 0 end as AY_202102,													
case when AY = '202103' then claim else 0 end as AY_202103,													
case when AY = '202104' then claim else 0 end as AY_202104,													
case when AY = '202105' then claim else 0 end as AY_202105,													
case when AY = '202106' then claim else 0 end as AY_202106,													
case when AY = '202107' then claim else 0 end as AY_202107,													
case when AY = '202108' then claim else 0 end as AY_202108,													
case when AY = '202109' then claim else 0 end as AY_202109,													
case when AY = '202110' then claim else 0 end as AY_202110,													
case when AY = '202111' then claim else 0 end as AY_202111,													
case when AY = '202112' then claim else 0 end as AY_202112													
from base													
)													
select													
treaty_number, uy, 													
sum(AY_201901) AY_201901,													
sum(AY_201902) AY_201902,													
sum(AY_201903) AY_201903,													
sum(AY_201904) AY_201904,													
sum(AY_201905) AY_201905,													
sum(AY_201906) AY_201906,													
sum(AY_201907) AY_201907,													
sum(AY_201908) AY_201908,													
sum(AY_201909) AY_201909, 													
sum(AY_201910) AY_201910,													
sum(AY_201911) AY_201911,													
sum(AY_201912) AY_201912,													
													
sum(AY_202001) AY_202001,													
sum(AY_202002) AY_202002,													
sum(AY_202003) AY_202003,													
sum(AY_202004) AY_202004,													
sum(AY_202005) AY_202005,													
sum(AY_202006) AY_202006,													
sum(AY_202007) AY_202007,													
sum(AY_202008) AY_202008,													
sum(AY_202009) AY_202009, 													
sum(AY_202010) AY_202010,													
sum(AY_202011) AY_202011,													
sum(AY_202012) AY_202012,													
													
sum(AY_202101) AY_202101,													
sum(AY_202102) AY_202102,													
sum(AY_202103) AY_202103,													
sum(AY_202104) AY_202104,													
sum(AY_202105) AY_202105,													
sum(AY_202106) AY_202106,													
sum(AY_202107) AY_202107,													
sum(AY_202108) AY_202108,													
sum(AY_202109) AY_202109, 													
sum(AY_202110) AY_202110,													
sum(AY_202111) AY_202111,													
sum(AY_202112) AY_202112													
from base2													
group by treaty_number, uy													
													
#  (2) primerica/NBL : blockbusiness 별 													
													
with base as (													
select													
cedingcompany || block classification, cedingcompany, block,													
cast(extract(year from currentissuedate) as text) || lpad(cast(extract(month from currentissuedate) as text),2,'0') UY,													
cast(extract(year from paymentdate) as text) || lpad(cast(extract(month from paymentdate) as text),2,'0') AY,													
sum(total_claim) claim													
from public."3_CLAIM_1_RMA_2021"													
where paidstatus = 'PAID' and reportdate = '2021-09-30'													
group by cedingcompany || block, cedingcompany, block,													
 cast(extract(year from currentissuedate) as text) || lpad(cast(extract(month from currentissuedate) as text),2,'0'),													
 cast(extract(year from paymentdate) as text) || lpad(cast(extract(month from paymentdate) as text),2,'0')													
), base2 as (													
select													
classification, uy, cedingcompany, block,													
case when AY = '201901' then claim else 0 end as AY_201901,													
case when AY = '201902' then claim else 0 end as AY_201902,													
case when AY = '201903' then claim else 0 end as AY_201903,													
case when AY = '201904' then claim else 0 end as AY_201904,													
case when AY = '201905' then claim else 0 end as AY_201905,													
case when AY = '201906' then claim else 0 end as AY_201906,													
case when AY = '201907' then claim else 0 end as AY_201907,													
case when AY = '201908' then claim else 0 end as AY_201908,													
case when AY = '201909' then claim else 0 end as AY_201909,													
case when AY = '201910' then claim else 0 end as AY_201910,													
case when AY = '201911' then claim else 0 end as AY_201911,													
case when AY = '201912' then claim else 0 end as AY_201912,													
													
case when AY = '202001' then claim else 0 end as AY_202001,													
case when AY = '202002' then claim else 0 end as AY_202002,													
case when AY = '202003' then claim else 0 end as AY_202003,													
case when AY = '202004' then claim else 0 end as AY_202004,													
case when AY = '202005' then claim else 0 end as AY_202005,													
case when AY = '202006' then claim else 0 end as AY_202006,													
case when AY = '202007' then claim else 0 end as AY_202007,													
case when AY = '202008' then claim else 0 end as AY_202008,													
case when AY = '202009' then claim else 0 end as AY_202009,													
case when AY = '202010' then claim else 0 end as AY_202010,													
case when AY = '202011' then claim else 0 end as AY_202011,													
case when AY = '202012' then claim else 0 end as AY_202012,													
													
case when AY = '202101' then claim else 0 end as AY_202101,													
case when AY = '202102' then claim else 0 end as AY_202102,													
case when AY = '202103' then claim else 0 end as AY_202103,													
case when AY = '202104' then claim else 0 end as AY_202104,													
case when AY = '202105' then claim else 0 end as AY_202105,													
case when AY = '202106' then claim else 0 end as AY_202106,													
case when AY = '202107' then claim else 0 end as AY_202107,													
case when AY = '202108' then claim else 0 end as AY_202108,													
case when AY = '202109' then claim else 0 end as AY_202109,													
case when AY = '202110' then claim else 0 end as AY_202110,													
case when AY = '202111' then claim else 0 end as AY_202111,													
case when AY = '202112' then claim else 0 end as AY_202112													
from base													
)													
select													
uy, cedingcompany, block,													
sum(AY_201901) AY_201901,													
sum(AY_201902) AY_201902,													
sum(AY_201903) AY_201903,													
sum(AY_201904) AY_201904,													
sum(AY_201905) AY_201905,													
sum(AY_201906) AY_201906,													
sum(AY_201907) AY_201907,													
sum(AY_201908) AY_201908,													
sum(AY_201909) AY_201909, 													
sum(AY_201910) AY_201910,													
sum(AY_201911) AY_201911,													
sum(AY_201912) AY_201912,													
													
sum(AY_202001) AY_202001,													
sum(AY_202002) AY_202002,													
sum(AY_202003) AY_202003,													
sum(AY_202004) AY_202004,													
sum(AY_202005) AY_202005,													
sum(AY_202006) AY_202006,													
sum(AY_202007) AY_202007,													
sum(AY_202008) AY_202008,													
sum(AY_202009) AY_202009, 													
sum(AY_202010) AY_202010,													
sum(AY_202011) AY_202011,													
sum(AY_202012) AY_202012,													
													
sum(AY_202101) AY_202101,													
sum(AY_202102) AY_202102,													
sum(AY_202103) AY_202103,													
sum(AY_202104) AY_202104,													
sum(AY_202105) AY_202105,													
sum(AY_202106) AY_202106,													
sum(AY_202107) AY_202107,													
sum(AY_202108) AY_202108,													
sum(AY_202109) AY_202109, 													
sum(AY_202110) AY_202110,													
sum(AY_202111) AY_202111,													
sum(AY_202112) AY_202112													
from base2													
group by uy, cedingcompany, block													
