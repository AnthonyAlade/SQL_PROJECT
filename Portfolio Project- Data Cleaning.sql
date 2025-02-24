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
  FROM [portpoflio project2].[dbo].[Nashvillehousing]

  --- STANDARDIZE DATE FORMAT
 SELECT *
 FROM Nashvillehousing

 SELECT SaleDate, CONVERT(date,saledate)
 FROM Nashvillehousing

 ALTER TABLE Nashvillehousing
 ADD Saledateconverted Date

 UPDATE Nashvillehousing
 SET Saledateconverted = CONVERT(date,saledate)

 --- POPULATE PROPERTY ADDRESS

 SELECT *---PropertyAddress
 FROM Nashvillehousing
 ---WHERE PropertyAddress IS NULL
 ORDER BY 2

 SELECT A.ParcelID,A.PropertyAddress,B.ParcelID,B.PropertyAddress, ISNULL(A.PropertyAddress,B.PropertyAddress)
 FROM Nashvillehousing A
 JOIN Nashvillehousing B
 ON A.ParcelID = B.ParcelID
 AND A.[UniqueID ] <> B.[UniqueID ]
 WHERE A.PropertyAddress IS NULL


 UPDATE A
 SET A.PropertyAddress = ISNULL(A.PropertyAddress,B.PropertyAddress)
  FROM Nashvillehousing A
 JOIN Nashvillehousing B
 ON A.ParcelID = B.ParcelID
 AND A.[UniqueID ] <> B.[UniqueID ]
 WHERE A.PropertyAddress IS NULL

 ---BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMS

 SELECT *
 FROM Nashvillehousing

 SELECT PropertyAddress
 FROM Nashvillehousing
 
 SELECT SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1),
 SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))
 FROM Nashvillehousing

 
 ALTER TABLE Nashvillehousing
 ADD PROPERTYSPLITADRRESS NVARCHAR(255)

 UPDATE Nashvillehousing
 SET PROPERTYSPLITADRRESS = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

 ALTER TABLE Nashvillehousing
 ADD PROPERTYSPLITCITY NVARCHAR(255)

 UPDATE Nashvillehousing
 SET PROPERTYSPLITCITY = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

---ANOTHER WAY TO DO THIS

SELECT PARSENAME(REPLACE(OWNERADDRESS,',','.'),3),
PARSENAME(REPLACE(OWNERADDRESS,',','.'),2),
PARSENAME(REPLACE(OWNERADDRESS,',','.'),1)
FROM Nashvillehousing

ALTER TABLE Nashvillehousing
 ADD OWNERSPLITADRRESS NVARCHAR(255)

 UPDATE Nashvillehousing
 SET OWNERSPLITADRRESS  = PARSENAME(REPLACE(OWNERADDRESS,',','.'),3)

 ALTER TABLE Nashvillehousing
 ADD OWNERSPLITCITY NVARCHAR(255)

 UPDATE Nashvillehousing
 SET OWNERSPLITCITY = PARSENAME(REPLACE(OWNERADDRESS,',','.'),2)

  ALTER TABLE Nashvillehousing
 ADD OWNERSPLITSTATE NVARCHAR(255)

 UPDATE Nashvillehousing
 SET OWNERSPLITSTATE = PARSENAME(REPLACE(OWNERADDRESS,',','.'),1)

 --CHANGE Y AND N INTO YES AND NO IN 'SOLD AS VACANT' FIELD

 SELECT *
 FROM Nashvillehousing

 SELECT DISTINCT SoldAsVacant, COUNT(SoldAsVacant)
 FROM Nashvillehousing
 GROUP BY SoldAsVacant
 ORDER BY 2 ASC

 SELECT SoldAsVacant, 
 CASE
 WHEN SoldAsVacant = 'Y' THEN 'YES' 
 WHEN SoldAsVacant = 'N' THEN 'NO'  
 ELSE SoldAsVacant
 END
 FROM Nashvillehousing

 UPDATE Nashvillehousing
 SET SoldAsVacant =  CASE
 WHEN SoldAsVacant = 'Y' THEN 'YES' 
 WHEN SoldAsVacant = 'N' THEN 'NO'  
 ELSE SoldAsVacant
 END

 --- REMOVING DUPLICATES
 
 SELECT *
 FROM Nashvillehousing

 WITH rownumCTE AS (
 SELECT*, ROW_NUMBER()OVER(PARTITION BY Parcelid,PropertyAddress,Saleprice,Saledate,LegalReference ORDER BY Uniqueid) AS row_num
 FROM Nashvillehousing
 )

 SELECT *
 FROM  rownumCTE 
 WHERE row_num > 1

 ----DELETE UNSED COLUMS
 
 SELECT *
 FROM Nashvillehousing

 ALTER TABLE Nashvillehousing
 DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress,Saledate

----FINAL CLEANED DATA
 SELECT *
 FROM Nashvillehousing





