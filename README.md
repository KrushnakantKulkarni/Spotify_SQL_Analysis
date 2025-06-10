# Spotify_SQL_Analysis
🎵 Spotify Data Analysis using SQL This project involves advanced SQL analysis on a real-world Spotify dataset. It is designed to showcase practical data cleaning, exploratory analysis, and advanced querying skills using SQL, including window functions and aggregate operations.
💡 Skills & Concepts Demonstrated
Table creation, DROP IF EXISTS

Aggregation: SUM, AVG, COUNT

Filtering: WHERE, HAVING, IN, NOT IN

Grouping and sorting: GROUP BY, ORDER BY

Window functions: DENSE_RANK() OVER (PARTITION BY ...)

Subqueries and WITH CTEs

Data cleaning with DELETE, IS NULL, and conditional filtering
🧩 Dataset Structure
The dataset contains details of music tracks such as:

Artist, Track, Album, Album Type

Audio Features: Danceability, Energy, Loudness, Speechiness, Acousticness, Instrumentalness, Liveness, Valence, Tempo, Duration

YouTube Info: Title, Channel, Views, Likes, Comments

Spotify Info: Licensed, Official Video, Stream, EnergyLiveness, Most Played On

🏗️ Table Creation
sql
Copy
Edit
DROP TABLE IF EXISTS spotify;
```
create table spotify(
artist           varchar(265),
track            varchar(255),
album            varchar(255),
album_type       varchar(255),
danceability     float,
energy           float,   
loudness         float,
speechiness      float,
acousticness     float,
instrumentalness float,
liveness         float,
valence          float,
tempo            float,
duration_min     float,
title            varchar(255), 
channel          varchar(255),
views            float,
likes            bigint,
comments         bigint,
licensed         boolean,
official_video   boolean,
stream           bigint,
energyliveness   float,
most_playedon    varchar(50)
);
```
🧹 Data Cleaning Queries
Remove tracks with 0 duration

Remove rows with NULL values

📊 Data Analysis
🔹 Basic Queries
Tracks with over 1 billion streams

List of all albums with their artists

Total comments for licensed tracks

Tracks with album type 'single'

Track count by each artist

🔸 Medium-Level Queries
Average danceability per album

Top 5 tracks by energy

Views and likes for official videos

Total views per album

Tracks streamed more on Spotify than YouTube

🔺 Advanced SQL Analysis
Top 3 most-viewed tracks per artist using DENSE_RANK()

Tracks with above-average liveness

Difference between highest and lowest energy per album

Tracks where Energy/Liveness > 1.2
```
--advance sql project – spotify database

--create table
drop table if exists spotify;

create table spotify(
artist           varchar(265),
track            varchar(255),
album            varchar(255),
album_type       varchar(255),
danceability     float,
energy           float,   
loudness         float,
speechiness      float,
acousticness     float,
instrumentalness float,
liveness         float,
valence          float,
tempo            float,
duration_min     float,
title            varchar(255), 
channel          varchar(255),
views            float,
likes            bigint,
comments         bigint,
licensed         boolean,
official_video   boolean,
stream           bigint,
energyliveness   float,
most_playedon    varchar(50)
);

--check exported data
select * from spotify;

--count total records
select count(*) from spotify;

--eda

--cleaning data: find and delete tracks with 0 duration
select * from spotify
where duration_min = 0;

delete from spotify
where duration_min = 0;

--check for null values in any column
select * from spotify
where
artist           is null or         
track            is null or
album            is null or         
album_type       is null or     
danceability     is null or
energy           is null or
loudness         is null or
speechiness      is null or
acousticness     is null or
instrumentalness is null or
liveness         is null or
valence          is null or
tempo            is null or
duration_min     is null or
title            is null or
channel          is null or
views            is null or
likes            is null or
comments         is null or
licensed         is null or
official_video   is null or
stream           is null or
energyliveness   is null or
most_playedon    is null;

--------------------------------|
--data analysis – easy category|
--------------------------------|

--view all data
select * from spotify;
```
```
--q1. retrieve names of tracks with more than 1 billion streams
select * from spotify 
where stream > 1000000000;

--q2. list all albums along with their respective artists
select distinct album, artist
from spotify 
order by 1;

--q3. total number of comments for licensed tracks
select sum(comments) from spotify
where licensed = 'true';

--q4. find all tracks belonging to album type 'single'
select track from spotify
where album_type = 'single';

--q5. count total number of tracks by each artist
select count(track) as total_track, artist from spotify
group by artist
order by 1 desc;
```
```
--medium level analysis

--1. calculate average danceability per album
select album, avg(danceability) as avg_danceability
from spotify
group by album
order by avg_danceability desc;

--2. find top 5 tracks with the highest energy values
select track, max(energy) as energy_level 
from spotify
group by track
order by energy_level desc 
limit 5;

--3. list tracks with their views and likes where official_video is true
select track, sum(views) as total_views, sum(likes) as total_likes 
from spotify 
where official_video = 'true'
group by track
order by total_views desc;

--4. for each album, calculate total views of all associated tracks
select album, track, sum(views) 
from spotify
group by 1, 2;

--5. retrieve tracks streamed more on spotify than on youtube
select * from (
    select 
        track,
        coalesce(sum(case when most_playedon = 'YouTube' then stream end), 0) as streamed_on_youtube,
        coalesce(sum(case when most_playedon = 'Spotify' then stream end), 0) as streamed_on_spotify 
    from spotify 
    group by 1
) as t1
where 
    streamed_on_spotify > streamed_on_youtube
    and streamed_on_youtube <> 0;

--advance problems

--q1. find top 3 most-viewed tracks for each artist using window functions

--without window function
select 
    artist,
    track,
    sum(views) as total_views
from spotify
group by 1, 2
order by 1, 3 desc;

--with window function
with ranking_artist as (
    select 
        artist,
        track,
        sum(views) as total_views,
        dense_rank() over (partition by artist order by sum(views) desc) as rank
    from spotify
    group by 1, 2
)
select * from ranking_artist
where rank <= 3;

--q2. find tracks where liveness score is above average
select * from spotify
where liveness > (select avg(liveness) from spotify);

--q3. calculate the difference between highest and lowest energy levels per album
with cte as (
    select 
        album,
        max(energy) as highest_energy,
        min(energy) as lowest_energy
    from spotify
    group by 1
)
select album,
       highest_energy - lowest_energy 
from cte;

--q4. find tracks where energy to liveness ratio is greater than 1.2
select track, (energy / liveness) as ratio 
from spotify
where (energy / liveness) > 1.2;
```
