select min(duration_min) from spotify;
11:26:10
select max(duration_min) from spotify;
11:25:57
select distinct(album_type) from spotify;
11:25:02
select count(distinct album) from spotify;
11:19:49
select count(distinct artist) from spotify;
11:19:37
select distinct(album) from spotify;
11:19:10
 select distinct(albums) from spotify;
11:19:00
select distinct(artist) from spotify;
11:18:37
 select count(*) from spotify;
11:18:14
select * from public.spotify;
11:17:05
--Advanced Spotify SQL Quries -- 
create table DROP TABLE IF EXISTS spotify; 
CREATE TABLE spotify ( artist VARCHAR(255), 
track VARCHAR(255), album VARCHAR(255), 
album_type VARCHAR(50), danceability FLOAT, 
energy FLOAT, loudness FLOAT, speechiness FLOAT, 
acousticness FLOAT, instrumentalness FLOAT,
liveness FLOAT, valence FLOAT, tempo FLOAT, 
duration_min FLOAT, title VARCHAR(255), 
channel VARCHAR(255), views FLOAT, 
likes BIGINT, comments BIGINT, 
licensed BOOLEAN, official_video BOOLEAN, 
stream BIGINT, energy_liveness FLOAT, 
most_played_on VARCHAR(50) );
11:09:11

-- EDA
select * from spotify
where duration_min = 0;

delete from spotify
where duration_min = 0;

select count(*) from spotify;

Select distinct channel from spotify;

select distinct most_played_on from spotify;
ROLLBACK;

-- Data analysis easy category--
-- Retrieve the names of all tracks that have more than 1 billion streams.

select track, stream from spotify
where stream > 1000000000;

-- List all albums along with their respective artists.

select distinct 
album, artist from spotify
order by 1;

select * from spotify;
-- Get the total number of comments for tracks where licensed = TRUE.
select sum(comments) as total_comm
where licensed = True;

-- Find all tracks that belong to the album type single.
rollback;

select * from spotify
where album_type ilike 'single';

-- Count the total number of tracks by each artist.

select count(track), artist
from spotify
group by 2;

-- Medium Level
-- Calculate the average danceability of tracks in each album.
-- Find the top 5 tracks with the highest energy values.
-- List all tracks along with their views and likes where official_video = TRUE.
-- For each album, calculate the total views of all associated tracks.
-- Retrieve the track names that have been streamed on Spotify more than YouTube.

-- Calculate the average danceability of tracks in each album.

select avg(danceability),album from spotify
group by 2
order by 1 desc;

-- Find the top 5 tracks with the highest energy values.
select track, max(energy) from spotify
group by 1
limit 5;

-- List all tracks along with their views and likes where official_video = TRUE.
select track, sum(views) as total_V, 
sum(likes) as total_l
from spotify
where official_video =  'True'
group by 1
order by 2 desc;

-- For each album, calculate the total views of all associated tracks.
select album, track, sum(views) as total_views 
from spotify 
group by 1,2
order  by 3 desc;

-- Retrieve the track names that have been streamed on Spotify more than YouTube.
select * from(
select track,
coalesce(sum(case when most_played_on ='Youtube' then stream end),0) as streamed_on_yt,
coalesce(sum(case when most_played_on ='Spotify' then stream end),0) as streamed_on_sp
from spotify
group by 1) as t
where streamed_on_yt < streamed_on_sp
and streamed_on_yt <> 0

-- Advanced Level
-- Find the top 3 most-viewed tracks for each artist using window functions.
-- Write a query to find tracks where the liveness score is above the average.
-- Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.

-- Find the top 3 most-viewed tracks for each artist using window functions.
with top_three as(
select track,
artist,
sum(views),
dense_rank() over(partition by artist order by sum(views) desc) as rnk
from spotify
group by 1,2)
select *
from top_three
where rnk <= 3;

rollback;

-- Write a query to find tracks where the liveness score is above the average.
select * from spotify;
select track, liveness,artist
from spotify
where liveness > (select avg(liveness) from spotify);

-- Use a WITH clause to calculate the difference between the highest
-- and lowest energy values for tracks in each album.

select * from spotify;

with diff_eng as(
select album, max(energy) as highest_eng, 
min(energy) as lowest_eng
from spotify
group by 1)
select album,
highest_eng - lowest_eng as diff_energy
from diff_eng
order by 2 desc









