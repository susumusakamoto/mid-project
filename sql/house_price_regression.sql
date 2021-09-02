use house_price;

-- Select all the data from table house_price_data to check if the data was imported correctly
select * from house_price_data;

-- Use the alter table command to drop the column date from the database, as we would not use it in the analysis with SQL. Select all the data from the table to verify if the command worked. Limit your returned results to 10.
alter table house_price_data
drop date;

select * from house_price_data
limit 10;

-- Use sql query to find how many rows of data you have.
select count(*) 
from house_price_data;

-- Now we will try to find the unique values in some of the categorical columns:
-- What are the unique values in the column bedrooms?
select distinct bedrooms
from house_price_data
order by bedrooms;

-- What are the unique values in the column bathrooms?
select distinct bathrooms
from house_price_data
order by bathrooms;

-- What are the unique values in the column floors?
select distinct floors
from house_price_data
order by floors;

-- What are the unique values in the column condition?
select distinct house_price_data.condition
from house_price_data
order by house_price_data.condition;

-- What are the unique values in the column grade?
select distinct grade
from house_price_data
order by grade;

-- Arrange the data in a decreasing order by the price of the house. Return only the IDs of the top 10 most expensive houses in your data.
select id
from house_price_data
order by price desc
limit 10;

-- What is the average price of all the properties in your data?
select round(avg(price)) as average_price
from house_price_data;

-- In this exercise we will use simple group by to check the properties of some of the categorical variables in our data
-- What is the average price of the houses grouped by bedrooms? The returned result should have only two columns, bedrooms and Average of the prices. Use an alias to change the name of the second column.
select bedrooms, round(avg(price)) as avg_price
from house_price_data
group by bedrooms
order by bedrooms;

-- What is the average sqft_living of the houses grouped by bedrooms? The returned result should have only two columns, bedrooms and Average of the sqft_living. Use an alias to change the name of the second column.
select bedrooms, round(avg(sqft_living), 1) as avg_sqft_living
from house_price_data
group by bedrooms
order by bedrooms;

-- What is the average price of the houses with a waterfront and without a waterfront? The returned result should have only two columns, waterfront and Average of the prices. Use an alias to change the name of the second column.
select waterfront, round(avg(price)) as avg_price
from house_price_data
group by waterfront
order by waterfront;

-- Is there any correlation between the columns condition and grade? You can analyse this by grouping the data by one of the variables and then aggregating the results of the other column. Visually check if there is a positive correlation or negative correlation or no correlation between the variables.
select (avg(house_price_data.condition * grade) - avg(house_price_data.condition) * avg(grade)) / (stddev_pop(house_price_data.condition) * stddev_pop(grade)) as correlation
from house_price_data;
-- The correlation is negative.

-- You might also have to check the number of houses in each category (ie number of houses for a given condition) to assess if that category is well represented in the dataset to include it in your analysis. For eg. If the category is under-represented as compared to other categories, ignore that category in this analysis
-- One of the customers is only interested in the following houses:

-- Number of bedrooms either 3 or 4
select count(bedrooms) as number
from house_price_data
where bedrooms = 3 or bedrooms = 4;

-- Bathrooms more than 3
select count(bedrooms) as number
from house_price_data
where bedrooms > 3;

-- One Floor
select count(bedrooms) as number
from house_price_data
where floors = 1;

-- No waterfront
select count(bedrooms) as number
from house_price_data
where waterfront = 0;

-- Condition should be 3 at least
select count(bedrooms) as number
from house_price_data
where house_price_data.condition >= 3;

-- Grade should be 5 at least
select count(bedrooms) as number
from house_price_data
where grade >= 5;

-- Price less than 300000
select count(bedrooms) as number
from house_price_data
where price < 300000;

-- Your manager wants to find out the list of properties whose prices are twice more than the average of all the properties in the database. Write a query to show them the list of such properties. You might need to use a sub query for this problem.
select * from house_price_data
having price > (select (avg(price)*2) from house_price_data);

-- Since this is something that the senior management is regularly interested in, create a view called Houses_with_higher_than_double_average_price of the same query.
create view house_price.Houses_with_higher_than_double_average_price as 
select * from house_price_data
having price > (select (avg(price)*2) from house_price_data);

-- Most customers are interested in properties with three or four bedrooms. What is the difference in average prices of the properties with three and four bedrooms? In this case you can simply use a group by to check the prices for those particular houses
select bedrooms, round(avg(price)) as avg_price
from house_price_data
where bedrooms = 3 or bedrooms = 4
group by bedrooms
order by bedrooms;

-- What are the different locations where properties are available in your database? (distinct zip codes)
select distinct zipcode
from house_price_data
order by zipcode;

-- Show the list of all the properties that were renovated.
select count(yr_renovated) as number
from house_price_data
where yr_renovated != 0;

-- Provide the details of the property that is the 11th most expensive property in your database.
select * from(
select *, rank() over(order by price desc) as ranking 
from house_price_data
order by price desc) t1
where ranking = 11;
