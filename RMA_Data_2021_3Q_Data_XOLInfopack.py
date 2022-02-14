import pandas as pd
filenames = ['202109 Korean Re Inforce File - PFS_KOR_1', 
             '202109 Korean Re Inforce File - PFS_KOR_2',
             '202109 Korean Re Inforce File - PFS_KOR_3',
            '202109 Korean Re Inforce File - PFS_KOR_4',
            '202109 Korean Re Inforce File - PFS_KRC',
            '202109 Korean Re Inforce File - PFS_KRS, PFS_KRP',
             '202109 Korean Re Inforce File - PRU, NYL, PFSC, Lincoln, Principal']
dfs = []

for fname in filenames:
    print('Loading {}'.format(fname))
    df = pd.read_csv('data/{}.csv'.format(fname), low_memory = False)
    df = df[['StatementDate','CedingCompany', 'Coverage_CededNetAmountRisk']]
    dfs.append(df)

print('Data loading is completed!')
df_merged = pd.concat(dfs)
def RiskProfile(lower, upper):
    count = len(df_merged[(df_merged['Coverage_CededNetAmountRisk'] >= lower) & (df_merged['Coverage_CededNetAmountRisk'] < upper)])
    NAR = df_merged[(df_merged['Coverage_CededNetAmountRisk'] >= lower) & (df_merged['Coverage_CededNetAmountRisk'] < upper)]['Coverage_CededNetAmountRisk'].sum()
    return [count, NAR]
RiskProfile(0,20000)
lower = [0,20000,40000,60000,80000,100000,150000,200000,250000,500000,1000000,1500000,2000000,2500000,3000000,4000000]
upper = [20000,40000,60000,80000,100000,150000,200000,250000,500000,1000000,1500000,2000000,2500000,3000000,4000000,10000000]
results = []

for low, up in zip(lower, upper) :
    row = []
    row.append(low)
    row.append(up)
    row.append(RiskProfile(lower=low,upper=up)[0])
    row.append(RiskProfile(lower=low,upper=up)[1])
    results.append(row)
results
column_name = ['Min NAR', 'Max NAR', 'No. of insureds', 'NAR']
df = pd.DataFrame (results, columns = [column_name])
df
excelfilename = 'Risk Profile as at 202109.xlsx'

writer = pd.ExcelWriter(excelfilename, 
                        engine='xlsxwriter',
                       datetime_format='mmm-yyyy')

df.to_excel(writer)
writer.save()
