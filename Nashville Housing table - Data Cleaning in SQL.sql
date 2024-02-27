/*

Cleaning Data in SQL Queries 

*/

SELECT *
FROM NashvilleHousing

-- Standardize SaleDate format

SELECT SaleDate, CONVERT(Date, SaleDate)
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ALTER COLUMN SaleDate DATE

-- Showing it worked 

SELECT SaleDate
FROM NashvilleHousing

------------------------------------------------------------------------------------------------------------

-- Populate Property Address data
-- We can see the there are 29 NULL values in PropertyAddress coulumn 

SELECT COUNT(*) AS Number_of_nulls
FROM NashvilleHousing
WHERE PropertyAddress IS NULL 

-- We can also see that there is a one one relationship between ParcelId and PropertyAddress

SELECT ParcelId, PropertyAddress
FROM NashvilleHousing


-- Thus we can populate NULL PropertyAddress by using ParcelId
-- I did this by firstly Self Join on ParcelID where uniqueID is different where PropertyAddress is NULL
-- then creates another coulumn using ISNULL function to fill all NULLs with correct address

SELECT 
	n1.ParcelID, 
	n1.PropertyAddress, 
	n2.ParcelID, 
	n2.PropertyAddress,
	ISNULL(n1.PropertyAddress, n2.PropertyAddress)
FROM NashvilleHousing n1
JOIN NashvilleHousing n2 
ON n1. ParcelID = n2.ParcelID
AND n1.[UniqueID ] <> n2.[UniqueID ]
WHERE n1.PropertyAddress IS NULL 

-- Change original coulumn in table 

UPDATE n1
SET PropertyAddress = ISNULL(n1.PropertyAddress, n2.PropertyAddress)
FROM NashvilleHousing n1
JOIN NashvilleHousing n2 
ON n1. ParcelID = n2.ParcelID
AND n1.[UniqueID ] <> n2.[UniqueID ]
WHERE n1.PropertyAddress IS NULL 


-- Checking it worked

SELECT COUNT(*) AS Number_of_nulls
FROM NashvilleHousing
WHERE PropertyAddress IS NULL 


------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

SELECT 
	PropertyAddress,
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) AS Address,
	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS City
FROM NashvilleHousing

-- Add columns to table 

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255),
    PropertySplitCity NVARCHAR(255);

UPDATE NashvilleHousing
SET 
    PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1),
    PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress));



-- Make sure it worked 

SELECT 
	PropertyAddress,
	PropertySplitAddress,
	PropertySplitCity
FROM NashvilleHousing

--  Let's take a look at OwnerAdress column 

SELECT OwnerAddress
FROM NashvilleHousing

-- Now I will show another method to Parse this coulumn into Address, city and State
-- Using PARSENAME and REPLACE . 

SELECT 
	OwnerAddress, 
	PARSENAME(REPLACE(OwnerAddress,',', '.'), 3) AS Address, 
	PARSENAME(REPLACE(OwnerAddress,',', '.'), 2) AS City,
	PARSENAME(REPLACE(OwnerAddress,',', '.'), 1) AS State
FROM NashvilleHousing

-- Create columns and add to table 

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255),
    OwnerSplitCity NVARCHAR(255),
    OwnerSplitState NVARCHAR(255);

UPDATE NashvilleHousing
SET  
    OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',', '.'), 3),
    OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',', '.'), 2),
    OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',', '.'), 1);


-- Make sure it worked 

SELECT 
	OwnerAddress,
	OwnerSplitAddress,
	OwnerSplitCity,
	OwnerSplitState
FROM NashvilleHousing


------------------------------------------------------------------------------------------------------------


-- Change Y  and N to Yes and No in 'Sold as Vacant' field

SELECT 
	SoldAsVacant,
	(CASE 
		WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
	END) AS UpdatedSoldAsVacant
FROM NashvilleHousing

-- Update table 

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
						WHEN SoldAsVacant = 'N' THEN 'No'
						ELSE SoldAsVacant END

------------------------------------------------------------------------------------------------------------


-- Remove Duplicates 
-- Let's say that we define that if two rows have the same ParcelID, PropertyAddress, SalePrice, SalesDate and LegalReference then we have duplicate rows

WITH RowNumCTE AS (
SELECT 	
	*,
	ROW_NUMBER() OVER( 
	PARTITION BY ParcelID,  
				 PropertyAddress, 
				 SalePrice, 
				 SaleDate, 
				 LegalReference
				 ORDER BY 
					UniqueID) AS Row_num
FROM NashvilleHousing
 )


DELETE 
FROM RowNumCTE
WHERE Row_num > 1

-- Checking it worked 

--SELECT *
--FROM RowNumCTE
--WHERE Row_num > 1


------------------------------------------------------------------------------------------------------------

-- Delete Unused Columns 

SELECT *
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress,TaxDistrict, PropertyAddress, SaleDate



