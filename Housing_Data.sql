/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [PortfolioProject].[dbo].[Housing]



  --Check Duplicates
SELECT UniqueID, PropertyAddress, SalePrice, SaleDate, LegalReference, COUNT(*)
FROM PortfolioProject..Housing
GROUP BY PropertyAddress, SalePrice, SaleDate, LegalReference, 
HAVING COUNT(*) > 1;


  -- Edit Sales Date Format
  Select SaleDate, Convert(Date, Saledate)
  From PortfolioProject..Housing

  Update Housing
  Set SaleDate = Convert(Date, SaleDate)

  Alter Table Housing
  Add SaleDate_New Date

  Update Housing
  Set SaleDate_New = Convert(date, SaleDate)


  --Clean PropertyAddress Colunm
  Select PropertyAddress
  From PortfolioProject..Housing
  
  Select *
  From PortfolioProject..Housing
  Where PropertyAddress is null

    Select *
  From PortfolioProject..Housing
 Order by ParcelID

 Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, IsNull(a.PropertyAddress, b.PropertyAddress)
 From PortfolioProject..Housing a
 Join PortfolioProject..Housing b
 on a.ParcelID = b.ParcelID
 and
 a.[UniqueID] <> b.[UniqueID]
 where a.PropertyAddress is Null

 Update a
 Set PropertyAddress = IsNull(a.PropertyAddress, b.PropertyAddress)
 From PortfolioProject..Housing a
 Join PortfolioProject..Housing b
 on a.ParcelID = b.ParcelID
 and
 a.[UniqueID] <> b.[UniqueID]
 where a.PropertyAddress is Null
 


 --Split Property Address into 3 Colunms (Address, City, and State)
 Select PropertyAddress
 From  PortfolioProject..Housing

 Select 
 SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address,
 SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address
  From  PortfolioProject..Housing

  Alter Table Housing
  Add PropertySplitAddress nvarchar(255);

  Update Housing
  Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

  Alter Table Housing
  Add PropertySplitCity nvarchar(255);

  Update Housing
  Set PropertySplitCity =  SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

 Select *
 From  PortfolioProject..Housing

 --Using The Parsename
Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProject.dbo.Housing



ALTER TABLE Housing
Add OwnerSplitAddress Nvarchar(255);

Update Housing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE Housing
Add OwnerSplitCity Nvarchar(255);

Update Housing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE Housing
Add OwnerSplitState Nvarchar(255);

Update Housing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.Housing
Group by SoldAsVacant
order by 2


--------

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProject..Housing


Update Housing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END




ALTER TABLE PortfolioProject.dbo.Housing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
