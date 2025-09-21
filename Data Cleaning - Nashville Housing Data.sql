/*
Cleaning Data in SQL Queries
*/

SELECT *
FROM Project.dbo.NashvilleHousing

-------------------------------------------------------------------------------------------------------------------------------
/* Standardize Date Format */

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

SELECT SaleDateConverted, CONVERT(Date, SaleDate)
FROM Project.dbo.NashvilleHousing

-------------------------------------------------------------------------------------------------------------------------------
/* Populate Property Address Data */

SELECT *
FROM Project.dbo.NashvilleHousing
ORDER BY ParcelID

-- Have the same ParcelID and PropertyAddress
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM Project.dbo.NashvilleHousing a
JOIN Project.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM Project.dbo.NashvilleHousing a
JOIN Project.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL

-------------------------------------------------------------------------------------------------------------------------------
/* Breaking out Address into Individual Columns (Address, City, State) */

-- Property Address
SELECT PropertyAddress
FROM Project.dbo.NashvilleHousing

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS City
FROM Project.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress Nvarchar(255);
UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity Nvarchar(255);
UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

SELECT *
FROM Project.dbo.NashvilleHousing


-- Owner Address

SELECT OwnerAddress
FROM Project.dbo.NashvilleHousing

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) AS Address,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) AS City,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) AS State
FROM Project.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255);
UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity Nvarchar(255);
UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState Nvarchar(255);
UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

SELECT *
FROM Project.dbo.NashvilleHousing

-------------------------------------------------------------------------------------------------------------------------------
/* Change 1 and 0 to Yes and No in "Sold as Vacant" field*/

SELECT SoldAsVacant, Count(SoldAsVacant)
FROM Project.dbo.NashvilleHousing
GROUP BY SoldAsVacant

SELECT SoldAsVacant,
	CASE SoldAsVacant
	WHEN 0 THEN 'No'
	WHEN 1 THEN 'Yes'
	END
FROM Project.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ALTER COLUMN SoldAsVacant VARCHAR(10)

UPDATE NashvilleHousing
SET SoldAsVacant = CASE SoldAsVacant
	WHEN '0' THEN 'No'
	WHEN '1' THEN 'Yes'
	END


-------------------------------------------------------------------------------------------------------------------------------
/* Remove duplicates */
WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
	ORDER BY UniqueID) row_num
FROM Project.dbo.NashvilleHousing
)
--DELETE
SELECT *
FROM RowNumCTE
WHERE row_num > 1

-------------------------------------------------------------------------------------------------------------------------------
/* Remove Unused Columns */
SELECT *
FROM Project.dbo.NashvilleHousing

ALTER TABLE Project.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, PropertyAddress

ALTER TABLE Project.dbo.NashvilleHousing
DROP COLUMN SaleDate

-- whole point of this project is to clean the data and make it more usable
-- convert -> standardize data
-- substring, parsename
-- case when
-- drop -> unused column
-- row_number -> duplicates