
-------------------
with hotels as(
select * from dbo.['2018$']
union
select * from dbo.['2019$']
union
select * from dbo.['2020$'])

--select (stays_in_week_nights+stays_in_weekend_nights) *adr as Revenue
--from hotels

--select arrival_date_year,
--sum((stays_in_week_nights + stays_in_weekend_nights) *adr) as Revenue
--from hotels
--group by arrival_date_year


--select arrival_date_year,
--hotel,
--round(sum((stays_in_week_nights + stays_in_weekend_nights) *adr),2) as Revenue
--from hotels
--group by arrival_date_year,hotel



--with hotels as(
--select * from dbo.['2018$']
--union
--select * from dbo.['2019$']
--union
--select * from dbo.['2020$'])

--select* from hotels
--left join market_segment$
--on hotels.market_segment = market_segment$.market_segment
--left join meal_cost$
--on hotels.meal = meal_cost$.meal


