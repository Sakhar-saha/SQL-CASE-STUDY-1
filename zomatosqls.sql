create database zomata_sw;

use zomata_sw;

/*Business Questions: 
1) Help Zomato in identifying the cities with poor Restaurant ratings
2) Mr.roy is looking for a restaurant in kolkata which provides online 
delivery. Help him choose the best restaurant
3) Help Peter in finding the best rated Restraunt for Pizza in New Delhi.
4)Enlist most affordable and highly rated restaurants city wise.
5)Help Zomato in identifying the restaurants with poor offline services
6)Help zomato in identifying those cities which have atleast 3 restaurants with ratings >= 4.9
  In case there are two cities with the same result, sort them in alphabetical order.
7) What are the top 5 countries with most restaurants linked with Zomato?
8) What is the average cost for two across all Zomato listed restaurants? 
9) Group the restaurants basis the average cost for two into: 
Luxurious Expensive, Very Expensive, Expensive, High, Medium High, Average. 
Then, find the number of restaurants in each category. 
10) List the two top 5 restaurants with highest rating with maximum votes. 
*/

#1

select  city, count(rating) as pr
from zomato
group by city
having pr < 2.5
order by pr desc;

#2

select city, Has_Online_delivery,rating, restaurantid
from zomato
where Has_Online_delivery = "yes" and rating >=5 and city = "kolkata";

#3

select city, cuisines, rating, restaurantid
from zomato 
where cuisines = "pizza" and city = "New Delhi" and rating >=4;

##4

select city, restaurantid, rating, avg(average_cost_for_two) as av
from zomato
where rating >=4
group by city, restaurantid, rating
having av <= av;

#5

select city, Has_Online_delivery, restaurantid, rating
from zomato
where rating <= 2.5 and Has_Online_delivery = "no"
order by rating;

#6

select city, count(restaurantid) as rs
from zomato
where rating >=4.9
group by city
having rs >=3
order by city asc;

#7

select c.CountryCode, country, count(restaurantid) as linkres
from zomato as z inner join countrytable as c
on z.CountryCode = c.CountryCode
group by c.CountryCode, country
order by linkres desc
limit 5;

#8

select avg(average_cost_for_two) as averageallres
from zomato;


#9

with qw as (select restaurantid, case when average_cost_for_two >= 1500 then "luxirious" when average_cost_for_two between 1499 and 1000 then "very expensive" when average_cost_for_two between 999 and 500 then "high" when average_cost_for_two <500 then "average" else "poor" end as positions   
from zomato)

select positions, count(restaurantid) as cores
from qw
group by positions;


#10

select restaurantid, rating, votes
from zomato
order by rating desc, votes desc
limit 5;
