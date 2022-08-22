/*

Data Cleaning with SQL

[  MS SQL SERVER  ]

*/

Select*
From PortfolioProject.dbo.NashvilleHousing

--Standardize Date Format

Alter Table NashvilleHousing
Alter Column SaleDate Date;

Update NashvilleHousing
Set SaleDate= CONVERT(date, SaleDate)


-- Populate Property Address

Select*
From PortfolioProject..NashvilleHousing
--Where PropertyAddress is null
Order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
Join PortfolioProject..NashvilleHousing b
	on a.ParcelID=b.ParcelID
	And a.[UniqueID ]<> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
Join PortfolioProject.. NashvilleHousing b
	On a.ParcelID = b.ParcelID
	And a.[UniqueID ]<> b.[UniqueID ]
Where a.PropertyAddress is null


-- Breaking down Property Address into Individual Columns (Address, City, State)

Select PropertyAddress
From PortfolioProject..NashvilleHousing
--Where PropertyAddress is null 
--Order by ParcelID

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address
From PortfolioProject..NashvilleHousing

-- adding the new columns to the table
Alter Table NashvilleHousing
ADD NewAddress nvarchar(255);


Update NashvilleHousing
Set NewAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

Alter Table NashvilleHousing
ADD NewCity Nvarchar(255);

Update NashvilleHousing
Set NewCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

Select *
From PortfolioProject..NashvilleHousing




-- Breaking down Owner Address with a different Approach

Select OwnerAddress
From PortfolioProject..NashvilleHousing

Select
PARSENAME(REPLACE(OwnerAddress,',', '.'), 3)
, PARSENAME(REPLACE(OwnerAddress,',', '.'), 2)
, PARSENAME(REPLACE(OwnerAddress,',', '.'), 1)
From PortfolioProject..NashvilleHousing


-- Adding the new columns to the Table

Alter Table NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',', '.'), 3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

Select*
From PortfolioProject..NashvilleHousing



-- Change 'Y' and 'N' to 'Yes' and 'No' in SoldAsVacant Column

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject..NashvilleHousing
Group By SoldAsVacant
order by 2

Select SoldAsVacant
, CASE WHEN SoldAsVacant= 'Y' Then 'Yes'
	   When SoldAsVacant='N' Then 'No'
	   Else SoldAsVacant
	   End
From PortfolioProject..NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant = Case When SoldAsVacant='Y' Then 'Yes'
						When SoldAsVacant='N' Then 'No'
						Else SoldAsVacant
						End



-- Remove Duplicates


With RowNumCTE as(
Select*,ROW_NUMBER() 
		Over (Partition by ParcelID,
						   PropertyAddress,
						   SalePrice,
						   SaleDate,
						   LegalReference
						   Order by UniqueID
						   ) row_num
From PortfolioProject..NashvilleHousing
)
Delete
--Select * 
From  RowNumCTE
Where row_num>2
--Order by PropertyAddress

Select*
From PortfolioProject..NashvilleHousing


-- Delete Unused Columns

Alter Table NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress
