# Notes

## SuperPACs

- Retrieve a list of top 50 aggregated expenditures by SuperPACs broken down by
  candidate support/opposition for candidate's full elecion period (not 2-year
  election cycle)
  - /v1/schedules/schedule_e/totals/by_candidate?election_full=True&sort=-total&per_page=50
  - This does not have Super PACs information, because multiple Super PACs may
    have supported/opposed a candidate in an election campaign

## State Government 

### NY State

- https://data.ny.gov

- This is is interactive (web based search, not API)
  - https://publicreporting.elections.ny.gov
  
- Link to Board of Elections related data
  - https://data.ny.gov/browse?sortBy=alpha&pageSize=20&Dataset-Information_Agency=Elections%2C+Board+of 
  
- "Campaign Finance Active Candidates Data"
  - All Campaign Finance Active Candidate Filers registered with the New York State Board of Elections
  - https://data.ny.gov/resource/epr8-9fny.json
  - Contains only Candidates ("compliance_type_desc":"CANDIDATE"), but not the election year or candidate's committee name
  
- Campaign Finance Active Committees Data
  - All Campaign Finance Active Committee Filers registered with the New York State Board of Elections
  - https://data.ny.gov/resource/udeh-rt5n.json
  
- Campaign Finance Active Filer Data
  - All Campaign Finance Active Filers registered with the New York State Board of Elections
  - https://data.ny.gov/resource/qcz9-s873.json
  - Does not contain candidate's name or election year
  
- Campaign Finance Disclosure Reports Contributions
  - All Campaign Finance Disclosure Reports contributions Filed with the New York Board of Elections 
  - https://data.ny.gov/resource/4j2b-6a2j.json
  - Does not contain candidate's name
  - Contain's "cand_comm_name" and election year
  - Sum: https://data.ny.gov/resource/4j2b-6a2j.json?$select=sum(org_amt)&$where=cand_comm_name%20like%20%27Molinaro%20For%20New%20York%27%20AND%20election_year=%272018%27
  - General info, particulary about candidate committee name:
    - https://www.transparencyusa.org/ny/candidate/michael-louis-henry?cycle=2022-election-cycle
  
- Campaign Finance Disclosure Reports Data
  - All Campaign Finance Disclosure Reports Filed with the New York Board of Elections
  - https://data.ny.gov/resource/e9ss-239a.json
  - Does not contain candidate's name
  - Contain's "cand_comm_name" and election year
  
- Campaign Finance Disclosure Reports Expenditures
  - All Campaign Finance Disclosure Reports expenditures Filed with the New York Board of Elections 
  - https://data.ny.gov/resource/ajsb-8pni.json
  - Does not contain candidate's name
  - Contain's "cand_comm_name" and election year
  
- Campaign Finance Filer Data
  - All Campaign Finance Filers registered with the New York State Board of Elections
  - https://data.ny.gov/resource/7x2g-h32p.json

- Query for Contributions Data for Kathy Hochul for Governor elections for year 2022, grouped by filing entity name and contribution amount, and sorted by contribution amount (sorted by contribution amount)

  - https://data.ny.gov/resource/4j2b-6a2j.json?$select=flng_ent_name,org_amt&$where=cand_comm_name%20like%20%27Friends%20for%20Kathy%20Hochul%27%20AND%20election_year=%272022%27&$order=org_amt%20DESC&$limit=100&$group=flng_ent_name,org_amt


- A sample query from the browser:
    https://data.ny.gov/resource/4j2b-6a2j.json?election_type=State/Local&election_year=2024

- How to query more than 1000 rows (SODA link)
  - https://support.socrata.com/hc/en-us/articles/202949268-How-to-query-more-than-1000-rows-of-a-dataset

### WA State

- Expenditures by Candidates and Political Committees
  - https://data.wa.gov/resource/tijg-9zyp.json
  
- Contributions to Candidates and Political Committees
  - https://data.wa.gov/resource/kv7h-kjye.json
  
- Page with links to various APIs
  - https://data.wa.gov/browse?tags=elections&sortBy=relevance&pageSize=20
  
### IL State

- https://www.elections.il.gov

### IA State

- Registered Political Candidates, Committees and Entities in Iowa
  - https://data.iowa.gov/api/v3/views/5dtu-swbk/query.json
  - https://data.iowa.gov/api/v3/views/5dtu-swbk/query.json?app_token=XXX&query=SELECT committee_type GROUP BY committee_type
  - data.iowa.gov/api/v3/views/5dtu-swbk/query.json?app_token=XXX&query=SELECT * WHERE committee_type='Governor'
  - 
  
- Iowa Campaign Contributions Received
  - https://data.iowa.gov/api/v3/views/smfg-ds7h/query.json
  - List of all Governor candidates via Contributions (sorted by year)
    - https://data.iowa.gov/api/v3/views/smfg-ds7h/query.json?app_token=XXX&query=SELECT%20*%20WHERE%20committee_type=%27Governor%27%20ORDER%20BY%20date%20DESC
  
- Iowa Campaign Expenditures
  - https://data.iowa.gov/api/v3/views/3adi-mht4/query.json

## Local Elections

### San Francisco

- https://data.sfgov.org/browse
  - https://dev.socrata.com/foundry/data.sfgov.org/pitq-e56w
    - "Campaign Finance - Transactions"
    
  - https://data.sfgov.org/City-Management-and-Ethics/Campaign-Finance-San-Francisco-Campaign-Filers/4c8t-ngau/about_data
    - "Campaign Finance - San Francisco Campaign Filers"
    - https://data.sfgov.org/api/v3/views/4c8t-ngau/query.json
    - https://dev.socrata.com/foundry/data.sfgov.org/4c8t-ngau
    
  - Can use fppc\_id field in both above responses to identify candidates 

- https://nf4.netfile.com/pub2/Default.aspx?focus=SearchName&aid=SFO

### Austin

- https://data.austintexas.gov/browse?limitTo=datasets&sortBy=relevance&pageSize=20&q=Campaign+Finance+-+Committee+Purpose

- https://data.austintexas.gov/api/v3/views/3kfv-biw6/query.json?$$app_token=ZZZ&query=SELECT recipient,contribution_year GROUP BY recipient,contribution_year ORDER BY contribution_year DESC

- https://data.austintexas.gov/api/v3/views/gd3e-xut2/query.json?$$app_token=ZZZ&query=SELECT paid_by,payment_year GROUP BY paid_by,payment_year ORDER BY payment_year DESC

### Los Angeles

- Candidates
  - https://data.lacity.org/Administration-Finance/City-Campaign-Statements-Filed/br3a-db9a/about_data
  - https://data.lacity.org/api/v3/views/br3a-db9a/query.json?$$app_token=XXX&query=SELECT%20*%20WHERE%20cmt_type_desc=%27Candidate%27
  
- Contributions
  - https://data.lacity.org/api/v3/views/m6g2-gc6c/query.json
  - "query=SELECT * WHERE cmt_id = "1234" AND schedule != "I" ORDER BY con_amount DESC LIMIT 100"
  - From https://data.lacity.org/Administration-Finance/City-Campaign-Contributions-and-Misc-Increases-to-/m6g2-gc6c/about_data
  
- Expenditures
  - https://data.lacity.org/Administration-Finance/City-Campaign-Expenditures/5mrt-4zhe/about_data
  - https://data.lacity.org/api/v3/views/5mrt-4zhe/query.json
  - Use cmt\_name instead of cmt\_id

- https://ethics.lacity.gov/data/campaigns/contributions/#dt


- https://ethics.lacity.gov/dataresults?dtQuery=cmpContributionSearch&ssid=&con_lname=&to_amt=&from_amt=&search_type_id_con=18&search_type_id=1&ent_typ=I&cand_per_id=172&from_date=&elec_or_date_flg=D&inc_schedule=A&element_submit=1&con_addr=&search_type_id_lob=15&cmt_type=C%2CO&search_type_id_oth=3&disclosure_group_cd=CF&search_type_id_eth=23&inc_schedule_all=A%2CB1%2CC%2CI&to_date=&search_type_id_cf=1&incempandint_all=yes&search_type_id_dev=29&con_fname=

### NYC

- Contributions

  - https://www.nyccfb.info/FTMSearch/Candidates/ContriputionsAjaxHandler?sEcho=3&iColumns=7&sColumns=%2C%2C%2C%2C%2C%2C&iDisplayStart=0&iDisplayLength=100&mDataProp_0=0&bSortable_0=true&mDataProp_1=1&bSortable_1=true&mDataProp_2=2&bSortable_2=true&mDataProp_3=3&bSortable_3=true&mDataProp_4=4&bSortable_4=true&mDataProp_5=5&bSortable_5=true&mDataProp_6=6&bSortable_6=true&iSortCol_0=5&sSortDir_0=desc&iSortingCols=1&election_cycle=2025&office_cd=1%2C11&&cand_id=2899&c_cd=IND%2CCAN%2CSPO%2CFAM%2CPCOMC%2CPCOMZ%2CPCOMP%2Cempo%2CCORP%2CPART%2CLLC%2Cothr_unkn&RecipientType=can&TransactionType_ID=ABC&page_no=&rows_per_page=&action_type=search&view_mode=list
      
- Expenditures

  - https://www.nyccfb.info/FTMSearch/Candidates/ExpendituresAjaxHandler?sEcho=3&iColumns=7&sColumns=%2C%2C%2C%2C%2C%2C&iDisplayStart=0&iDisplayLength=100&mDataProp_0=0&bSortable_0=true&mDataProp_1=1&bSortable_1=true&mDataProp_2=2&bSortable_2=true&mDataProp_3=3&bSortable_3=true&mDataProp_4=4&bSortable_4=true&mDataProp_5=5&bSortable_5=true&mDataProp_6=6&bSortable_6=true&iSortCol_0=4&sSortDir_0=desc&iSortingCols=1&election_cycle=2025&office_cd=1%2C11&cand_id=2899&TransactionType_ID=F&Account_ID=&sort_expression=&sort_direction=&page_no=&rows_per_page=&action_type=search&internCode=&CommunicationType_ID=&Communication_ID=&comm_id=&spender_ID=&contributor_id=&Sond_cd=&IndependentSpenderSearchName=&Payee_Name=&view_mode=list
    

