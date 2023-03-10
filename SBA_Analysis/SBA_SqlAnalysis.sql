/****** Script for SelectTopNRows command from SSMS  ******/

--- *** Data Cleaning ***
select *
into sba_naics_sector_codes_description 
from(

	SELECT 
		  [NAICS_Industry_Description],
		  iif([NAICS_Industry_Description] like '%–%', substring([NAICS_Industry_Description], 8, 2 ), '') lookupcode,
		  iif([NAICS_Industry_Description] like '%–%', ltrim(substring([NAICS_Industry_Description], CHARINDEX('–', [NAICS_Industry_Description]) + 1, LEN([NAICS_Industry_Description]) )), '') Sector
	  FROM dbo.sba_standards
	  where [NAICS_Codes] = ''
) main
where 
	lookupcode != ''


insert into sba_naics_sector_code_description
values 
  ('Sector 31 – 33 – Manufacturing', 32, 'Manufacturing'), 
  ('Sector 31 – 33 – Manufacturing', 33, 'Manufacturing'), 
  ('Sector 44 - 45 – Retail Trade', 45, 'Retail Trade'),
  ('Sector 48 - 49 – Transportation and Warehousing', 49, 'Transportation and Warehousing')

update   sba_naics_sector_code_description
set Sector = 'Manufacturing'
where lookupcode = 31

-- 1. What is the summary of all PPP approved loans

select 
	year(DateApproved) Date_Approved,
	count(LoanNumber) Number_of_Approved,
	sum(InitialApprovalAmount) Approved_Amount,
	avg(InitialApprovalAmount) Average
From dbo.sba_data
where 
	year(DateApproved) = 2020
group by year(DateApproved)

union

select 
	year(DateApproved) Date_Approved,
	count(LoanNumber) Number_of_Approved,
	sum(InitialApprovalAmount) Approved_Amount,
	avg(InitialApprovalAmount) Average
From dbo.sba_data
where 
	year(DateApproved) = 2021
group by year(DateApproved)


--- What is the summary of all approved PPP loans

select 
	year(DateApproved) Date_Approved,
	count(distinct OriginatingLender) Originating_lender,
	count(LoanNumber) Number_of_Approved,
	sum(InitialApprovalAmount) Approved_Amount,
	avg(InitialApprovalAmount) Average
From dbo.sba_data
where 
	year(DateApproved) = 2020
group by year(DateApproved)

union

select 
	year(DateApproved) Date_Approved,
	count(distinct OriginatingLender) Originating_lender,
	count(LoanNumber) Number_of_Approved,
	sum(InitialApprovalAmount) Approved_Amount,
	avg(InitialApprovalAmount) Average
From dbo.sba_data
where 
	year(DateApproved) = 2021
group by year(DateApproved)


--- Top 15 Originating lenders by loan count, total amount and average in 2020 and 2023

-- For 2020
select
	Top 15
	OriginatingLender,
	count(LoanNumber) Number_of_Approved,
	sum(InitialApprovalAmount) Approved_Amount,
	avg(InitialApprovalAmount) Average
From dbo.sba_data
where 
	year(DateApproved)= 2020
group by 
	OriginatingLender
order by 3 desc

--For 2021

select
	Top 15
	OriginatingLender,
	count(LoanNumber) Number_of_Approved,
	sum(InitialApprovalAmount) Approved_Amount,
	avg(InitialApprovalAmount) Average
From dbo.sba_data
where 
	year(DateApproved)= 2021
group by 
	OriginatingLender
order by 3 desc


--- Top 20 industries that received the PPP loans in 2021 and 2020

--- FOr 2020
select Top 20
	b.Sector,
	count(LoanNumber) Number_of_Approved,
	round(sum(InitialApprovalAmount),2) Approved_Amount,
	avg(InitialApprovalAmount) Average
From dbo.sba_data a
Join dbo.sba_naics_sector_code_description b
On left(a.NAICSCode,2) = b.lookupcode
where 
	year(DateApproved)= 2020
group by 
	b.Sector
order by 3 desc

--Manufacturing sector is at the top - $100,430,811,635.86
--Healthcare comes at second - $68,116,729,764.7989
--And IT sector at third - $66,892,059,973.2136


-- For 2021
select Top 20
	b.Sector,
	count(LoanNumber) Number_of_Approved,
	round(sum(InitialApprovalAmount),2) Approved_Amount,
	avg(InitialApprovalAmount) Average
From dbo.sba_data a
Join dbo.sba_naics_sector_code_description b
On left(a.NAICSCode,2) = b.lookupcode
where 
	year(DateApproved)= 2021
group by 
	b.Sector
order by 3 desc


-- WOW Accommodation and Food Services is at the top with - $40,969,904,410.46

--- Now let's get the percentage
-- for 2020
with  cte as 
(
select Top 20
	b.Sector,
	count(LoanNumber) Number_of_Approved,
	round(sum(InitialApprovalAmount),2) Approved_Amount,
	avg(InitialApprovalAmount) Average
From dbo.sba_data a
Join dbo.sba_naics_sector_code_description b
On left(a.NAICSCode,2) = b.lookupcode
where 
	year(DateApproved)= 2020
group by 
	b.Sector
--order by 3 desc
)
select Sector, Number_of_Approved, Approved_Amount,Average,
Approved_Amount/sum(Approved_Amount) Over() * 100 Percent_by_amount
From cte
order by 3 desc

-- for 2021
with  cte as 
(
select Top 20
	b.Sector,
	count(LoanNumber) Number_of_Approved,
	round(sum(InitialApprovalAmount),2) Approved_Amount,
	avg(InitialApprovalAmount) Average
From dbo.sba_data a
Join dbo.sba_naics_sector_code_description b
On left(a.NAICSCode,2) = b.lookupcode
where 
	year(DateApproved)= 2021
group by 
	b.Sector
--order by 3 desc
)
select Sector, Number_of_Approved, Approved_Amount,Average,
Approved_Amount/sum(Approved_Amount) Over() * 100 Percent_by_amount
From cte
order by 3 desc


---- How much of the PPP loans of 2021 have been fully forgiven

select 
	count(LoanNumber) Number_of_Approved,
	round(sum(CurrentApprovalAmount),2) Current_Approved_Amount,
	avg(CurrentApprovalAmount) Average_Approved_Amount,
	sum(ForgivenessAmount) Amount_Forgiven,
	sum(ForgivenessAmount)/sum(CurrentApprovalAmount) *100 percent_forgiven
from dbo.sba_data
where 
	year(DateApproved)=2021
order by 3 desc

--- Year,Month with the highest PPP loan approved

select
	 YEAR(DateApproved) Year_Approved,
	 MONTH(DateApproved) Month_approved,
	 count(LoanNumber) Number_of_approved,
	 round(sum(InitialApprovalAmount),0) total_net_dollars,
	 avg(InitialApprovalAmount) average_loan_size
from dbo.sba_data
group by year(DateApproved),
		MONTH(DateApproved)
order by 4 desc

----
