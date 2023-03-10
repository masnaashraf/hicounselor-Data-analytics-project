use hicounselor_db;

show tables;

#creating  Apps_Cleaned table

create table Apps_Cleaned(App text ,Category text ,Rating double ,Reviews double ,Size text ,Installs double, 
Type text ,Price double ,Content_Rating text ,Genres text ,Last_Updated text ,Current_Ver text ,Android_Ver text);

select count(*) from Apps_Cleaned;
Select * from Apps_Cleaned;

#loading data to Apps_Cleaned table


LOAD DATA LOCAL INFILE 'C:\\Users\\Masna_2\\Desktop\\hicounselor_playstoreapps_Cleaned.csv' 
INTO TABLE Apps_Cleaned
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;



select count(*)  from Apps_Cleaned;

#Executing the querries for Apps_Cleaned dataset

#1. Which apps have the highest rating in the given available dataset?


SELECT APP ,Rating 
FROM Apps_Cleaned
WHERE Rating=(SELECT MAX(Rating) From Apps_Cleaned);


#2. What are the number of installs and reviews for the above apps? Return the apps with the highest reviews to the top.

SELECT App, Installs, Reviews
FROM Apps_Cleaned
WHERE Rating = (SELECT MAX(Rating) FROM Apps_Cleaned)
ORDER BY Reviews DESC;



#3. Which app has the highest number of reviews? Also, mention the number of reviews and category of the app
SELECT App, Reviews, Category
FROM Apps_Cleaned
WHERE Reviews = (SELECT MAX(Reviews) FROM Apps_Cleaned);


#4. What is the total amount of revenue generated by the google play store by hosting apps? (Whenever a user buys apps from the
#google play store, the amount is considered in the revenue)

SELECT SUM(Price) as total_revenue
FROM Apps_Cleaned;

#5. Which Category of google play store apps has the highest number of installs? also, find out the total number of installs for that particular
#category.

SELECT Category, SUM(Installs) as total_installs
FROM Apps_Cleaned
GROUP BY Category
HAVING SUM(Installs) = (SELECT MAX(total_installs) FROM (SELECT SUM(Installs) as total_installs FROM Apps_Cleaned GROUP BY Category) as temp);

#6. Which Genre has the most number of published apps?


SELECT Genres, COUNT(*) as num_published_apps
FROM Apps_Cleaned
GROUP BY Genres
HAVING COUNT(*) = (SELECT MAX(num_published_apps) FROM (SELECT COUNT(*) 
as num_published_apps FROM Apps_Cleaned GROUP BY Genres) as temp);


#7. Provide the list of all games ordered in such a way that the game that has the highest number of installs is displayed on the top
#(to avoid duplicate results use distinct)
SELECT DISTINCT App, Installs
FROM Apps_Cleaned
WHERE Category = 'GAME'
ORDER BY Installs DESC;

#8. Provide the list of apps that can work on android version 4.0.3 and UP.

SELECT App,Android_Ver
FROM Apps_Cleaned
WHERE Android_Ver like '4.0.3 and up';


#9. How many apps from the given data set are free? Also, provide the number of paid apps.
SELECT COUNT(*) as num_free_apps FROM Apps_Cleaned WHERE price = 0;
Select COUNT(*) as num_Paid_apps FROM Apps_Cleaned WHERE price >0;


#10. Which is the best dating app? (Best dating app is the one having the highest number of Reviews)
SELECT App, Reviews FROM Apps_Cleaned WHERE Category = 'Dating' ORDER BY Reviews DESC LIMIT 1;

#creating table reviews

create table reviews_cleaned(App text ,Review text ,Sentiment text ,Polarity float ,Subjectivity float);

#loading the reviews dataset
LOAD DATA LOCAL INFILE 'C:\\Users\\Masna_2\\Desktop\\hicounselor_playstore_review_cleaned.csv' 
INTO TABLE reviews_cleaned
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

#Excecuting Sql queries

#11.Get the number of reviews having positive sentiment and number of reviews having negative sentiment for the app 10 best foods for
#you and compare them.
SELECT SUM(Sentiment="Positive") AS Positive_Review ,
SUM(Sentiment="Negative") AS Negative_Review , (SUM(Sentiment="Positive") - SUM(Sentiment="Negative")) 
AS comparison
from reviews_cleaned 
where App like '10 Best Foods for You';

#12. Which comments of ASUS SuperNote have sentiment polarity and sentiment subjectivity both as 1?


SELECT Review from reviews_cleaned  where  Polarity=1 and Subjectivity=1 and App like "ASUS SuperNote";


#13. Get all the neutral sentiment reviews for the app Abs Training-Burn belly fat


SELECT Review from reviews_cleaned 
where Sentiment like "Neutral" and App like "Abs Training-Burn belly fat";


#14. Extract all negative sentiment reviews for Adobe Acrobat Reader with their sentiment polarity and sentiment subjectivity


SELECT Review,Polarity,Subjectivity from reviews_cleaned   
where Sentiment like "Negative" and App like "Adobe Acrobat Reader";