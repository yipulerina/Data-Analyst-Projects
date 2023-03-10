----- For Tableau

create view ppp_main as

SELECT 
	d.Sector,  
	year(DateApproved) year_approved,
	month(DateApproved) month_Approved,
	OriginatingLender, 	
	BorrowerState,
	Race,
	Gender,
	Ethnicity,

	count(LoanNumber) Number_of_Approved,

	sum(CurrentApprovalAmount) Current_Approved_Amount,
	avg (CurrentApprovalAmount) Current_Average_loan_size,
	sum(ForgivenessAmount) Amount_Forgiven,


	sum(InitialApprovalAmount) Approved_Amount,
	avg (InitialApprovalAmount) Average_loan_size

FROM 
	dbo.sba_data p
	inner join dbo.sba_naics_sector_code_description d
		on left(p.NAICSCode, 2) = d.lookupcode
group by 
	d.Sector,  
	year(DateApproved),
	month(DateApproved),
	OriginatingLender, 	
	BorrowerState,
	Race,
	Gender,
	Ethnicity