# RMA 데이터 NAR별 분포 코드

import pandas as pd
filenames = ['2021-Q4 Korean Re - Inforce (PFS_KRC)', 
             '2021-Q4 Korean Re - Inforce (PFS_KRS, PFS_KRP)',
             '2021-Q4 Korean Re - Inforce (PRU, NYL, PFSC, Lincoln, Principal)',
            '2021-Q4 Korean Re - Inforce (PFS_KOR1)',
            '2021-Q4 Korean Re - Inforce (PFS_KOR2)',
            '2021-Q4 Korean Re - Inforce (PFS_KOR3)',
             '2021-Q4 Korean Re - Inforce (PFS_KOR4)']

dfs = []

# csv 자료 읽어오기
# .format(fname)으로 {} 칸 안에 직접입력 기능
# 전체 자료 중 3개 컬럼 추출해서 빈 배열(dfs)에 대입
for fname in filenames:
    print('Loading {}'.format(fname))
    df = pd.read_csv('C:\\Users\\sdpark\\Desktop\\업무\\1_출재특약\\1_CAT XOL\\2022\\1_RawData\\RMA\\2021 4Q\\{}.csv'.format(fname), low_memory = False)
    # condition = df[(df['Coverage_CededNetAmountRisk'] > 500000) & (df['Policy_PolicyNumber'] != "0056733505")]
    # df = condition[['Policy_PolicyNumber','CedingCompany','Coverage_CededNetAmountRisk']]
    # KIMMEL 사망건(계약번호: 0056733505) 제외
    condition = df[df['Policy_PolicyNumber'] != "0056733505"]
    df = condition[['Policy_PolicyNumber','CedingCompany','Coverage_CededNetAmountRisk']]
    dfs.append(df)

print('Data loading is completed!')

df_merged = pd.concat(dfs)

# Group by로 동일 증번의 가입금액 합산해줌 (Risk XOL과 기준을 맞추기 위해선 해당 코드 필요)
# grouped = df_merged.groupby('Policy_PolicyNumber')
# df_merged = grouped.sum()

# 결과 함수 정의
def RiskProfile(lower, upper):
    count = len(df_merged[(df_merged['Coverage_CededNetAmountRisk'] > lower) & (df_merged['Coverage_CededNetAmountRisk'] <= upper)])
    NAR = df_merged[(df_merged['Coverage_CededNetAmountRisk'] > lower) & (df_merged['Coverage_CededNetAmountRisk'] <= upper)]['Coverage_CededNetAmountRisk'].sum()
    return [count, NAR]
RiskProfile(0,20000)

# CAT XOL 범위
lower = [0,20000,40000,60000,80000,100000,150000,200000,250000,500000,1000000,1500000,2000000,2500000,3000000,4000000]
upper = [20000,40000,60000,80000,100000,150000,200000,250000,500000,1000000,1500000,2000000,2500000,3000000,4000000,10000000]
# Per Risk XOL 범위
# lower = [1000000,1500000,2000000,2500000,3000000,3500000,4000000,4500000,5000000,5500000,6000000,6500000]
# upper = [1500000,2000000,2500000,3000000,3500000,4000000,4500000,5000000,5500000,6000000,6500000,7000000]
results = []

# 함수를 통해 결과 값 생성
for low, up in zip(lower, upper) :
    row = []
    row.append(low)
    row.append(up)
    row.append(RiskProfile(lower=low,upper=up)[0])
    row.append(RiskProfile(lower=low,upper=up)[1])
    results.append(row)

# 결과 산출
results

# 컬럼 이름 지정
column_name = ['Min NAR', 'Max NAR', 'No. of insureds', 'NAR']

# Data frame 설정
df = pd.DataFrame (results, columns = [column_name])
df
excelfilename = 'Risk Profile as at 2021Q4-high exposure.xlsx'

# 엑셀에 작성
writer = pd.ExcelWriter(excelfilename, 
                        engine='xlsxwriter',
                       datetime_format='mmm-yyyy')

df.to_excel(writer)
writer.save()

print('The End')
