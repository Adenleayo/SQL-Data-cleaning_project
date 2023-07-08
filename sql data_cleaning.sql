--Data cleaning

select * from NashvilleHousing

select SaleDate from NashvilleHousing


--Property Address date
select propertyAddress from NashvilleHousing
where propertyAddress is null

select a.ParcelID,b.ParcelID,a.PropertyAddress,b.PropertyAddress,ISNULl(a.PropertyAddress,b.PropertyAddress) from NashvilleHousing a
join NashvilleHousing b on a.ParcelID = b.ParcelID and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

update a
set PropertyAddress =ISNULl(a.PropertyAddress,b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b on a.ParcelID = b.ParcelID and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

--seperate the address into different columns

select * from NashvilleHousing

select PropertyAddress, substring(PropertyAddress,1,charindex(',',PropertyAddress)-1) as address,
substring(PropertyAddress,charindex(',',PropertyAddress)+1,len(PropertyAddress)) as address
from NashvilleHousing

alter table NashvilleHousing
add PropertySplitAddress varchar(255)

update NashvilleHousing
set PropertySplitAddress = substring(PropertyAddress,1,charindex(',',PropertyAddress)-1)


alter table NashvilleHousing
add PropertySplitCity varchar(255)


update NashvilleHousing
set PropertySplitCity = substring(PropertyAddress,charindex(',',PropertyAddress)+1,len(PropertyAddress))

--spliting the owner address into 3 categories,address,city,state
select parsename(replace(OwnerAddress,',','.'),3) as address, 
parsename(replace(OwnerAddress,',','.'),2) as city,
parsename(replace(OwnerAddress,',','.'),1) as state
from NashvilleHousing

--changinig of 0 and 1 in vacant to yes and no
select SoldAsVacant,count(*) from NashvilleHousing
group by SoldAsVacant 

select SoldAsVacant,
case when SoldAsVacant = 0 then 'No'
                         when SoldAsVacant = 1 then 'Yes'
						 else 'Others'
						 end as soldvacant
from NashvilleHousing

alter table NashvilleHousing
add SoldVacant varchar(255)

update NashvilleHousing
set SoldVacant = case when SoldAsVacant = 0 then 'Yes'
                        when SoldAsVacant = 1 then 'No'
						else 'Others'
						end 

--delete duplicate rows
select * from NashvilleHousing

WITH Row_numbersCTE
as
(
select *,
row_number() over(partition by ParcelID,PropertyAddress,SaleDate,SalePrice,LegalReference order by UniqueID ) row_num
from NashvilleHousing
)
select *
from Row_numbersCTE
where row_num > 1


--delete irrelvant rows
alter table NashvilleHousing
drop column OwnerAddress,SoldAsVacant,Address1,Address2
