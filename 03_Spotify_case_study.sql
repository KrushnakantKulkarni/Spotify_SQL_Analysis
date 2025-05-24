--Advance SQL Project---Spotify Database --


--Create table
drop table if exists spotify ;

create table spotify(
Artist           varchar(265),
Track	         varchar(255),
Album	         varchar(255),
Album_type	     varchar(255),
Danceability     float,
Energy	         float,   
Loudness         float,
Speechiness	     float,
Acousticness	 float,
Instrumentalness float,
Liveness	     float,
Valence	         float,
Tempo	         float,
Duration_min	 float,
Title	         varchar(255), 
Channel	         varchar(255),
Views	         float,
Likes            bigint,
Comments         bigint,
Licensed	     boolean,
official_video	 boolean,
Stream	         bigint,
EnergyLiveness	 float,
most_playedon    varchar(50)
                      ) ;

--Checking exported Data

select * from spotify ;

--Count of data
select count(*) from spotify ;

--EDA

--Cleaning Data
select * from spotify
where duration_min = 0 ;

delete from spotify
where duration_min = 0 ;

select * from spotify
where
Artist          is null or         
Track           is null or
Album	        is null or         
Album_type	    is null or     
Danceability    is null or
Energy	        is null or
Loudness         is null or
Speechiness	     is null or
Acousticness	 is null or
Instrumentalness is null or
Liveness	     is null or
Valence	         is null or
Tempo	         is null or
Duration_min	 is null or
Title	         is null or
Channel	         is null or
Views	         is null or
Likes            is null or
Comments         is null or
Licensed	     is null or
official_video	 is null or
Stream	         is null or
EnergyLiveness	 is null or
most_playedon    is null  ;

--------------------------------|
--Data Analysis----Easy Category| 
--------------------------------|
select * from spotify ;

--Q1.Retrieves the names of all tracks that have more than 1 billion streams.
select * from spotify 
where stream > 1000000000 ;

--Q2.List all albums along with their respective artists
select distinct album,artist
from spotify 
order by 1;

--Q3.Get the total number of comments for tracks where licensed = TRUE.

select sum(comments) from spotify
where licensed = 'true' ;

--Q4.Find all tracks that belong to the album type singl.

select track from spotify
where album_type = 'single' ;

--Q5.Count the total number of tracks by each artis

select count(track) as total_track ,artist from spotify
group by artist
order by 1 desc;


-- Medium Level Analysis -----

--1.Calculate the average dancebility of track in each album 

select album,avg(danceability) as avg_danceability
from spotify
group by album
order by avg_danceability desc;

--2.Find top 5 tracks with the heighest energy values
select  track,max(energy) as energy_level 
from spotify
group by track
order by energy_level desc 
limit 5 ;

--3.List all tracks along with their views and likes where official_video=TRUE.

select track,sum(views) as total_views,sum(likes) as total_likes 
from spotify 
where official_video='true'
group by track
order by total_views desc;

--4.for each album,calculate the total views of all assosciated tracks.

select album,track,sum(views) from spotify
group by 1,2 ;

--5.Retrieve the track names that have been stramed on spotify more than youtube

select * from
(select 
track,
coalesce(sum(case when most_playedon ='YouTube' then stream end),0) as stramed_on_youtub,
coalesce(sum(case when most_playedon ='Spotify' then stream end),0) as stramed_on_spotify 
from spotify 
group by 1) as t1
 where 
 stramed_on_spotify > stramed_on_youtub
 and 
 stramed_on_youtub <> 0 

---Advance Problems 

--Q1.Find top 3 most-viewed tracks for each artist using window functions.
 --each artists and total view for each track
 --track with heighest view for each artisy (we need top)
 --dense rank
 --cte and filder rank < = 3
--without windows function 
 select 
 artist,
 track,
 sum(views) as total_views
 from spotify
 group by 1,2
 order by 1,3 desc 


--with windows functiom

with ranking_artist
as 
(select 
artist,
track,
sum(views) as total_views,
dense_rank() over (partition by artist order by sum(views) desc) as rank
from spotify
group by 1,2
order by 1,3
) 
select * from ranking_artist
where rank <= 3;

--Q2.write a query to find where liveness score is above average

select * from spotify
where liveness >(select avg(liveness) from spotify);

--Q3.use a with clause to calculate the difference between the heighest energy levels and lowest energy levles for tracks in each

with cte
as
(select 
album,
max(energy) as heighest_energy,
min(energy) as lowest_energy
from spotify
group by 1)
select album,
heighest_energy - lowest_energy 
from cte ;

--Q4.find tracks where the energy to liveness ratio is greater than 1.2 .

select track,( energy / liveness ) as ratio from spotify
 where ( energy / liveness ) > 1.2 ;

--Q5.calculate the cumulative sum of likes for tracks ordered by the number of views.using window function.
