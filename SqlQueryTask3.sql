--create a table CRASH into database D401.

create table crash(
	gid serial primary key,
	crash_year integer,
	accident_type integer, 
	collision_type integer,
	weather_condition integer,
	light_condition integer,
	geom geometry(point,2263)
);


/*
downloaded data from http://134.74.112.65/WebGIS/nyccrash.txt will be uploaded to CRASH table.
For this purpose, a python program is written to convert the data to sql-input format.
for example, sample data in nycccrash.text: 1989,1,9,1,1,1021044,243582
this will be converted to input sql format: INSERT INTO crashtest  VALUES ('1989','1','9','1','1',ST_GeomFromText('POINT(1021044 243582)', 2263));
the sql formatted data will be saved in a '.sql' file so that the data can be easily imported to the database
the import command : psql -U username -d databaseName -f fileName
for this particular project the command will be: psql -U debn20 -d d401 -f inputRawDataTask1.sql
*/

/*
For task2 data from nyc_pp shape file was imported to database d401 in a table nypp.
To import shape file into the the database the following command was used:
    shp2pgsql -s 2263 "nypp" nypp | psql -h 192.168.88.30 -p 5432 -U debn20 -d d401

we can see that nypp table has the following columns
    gid 
    precinct 
    shape_leng 
    shape_area 
    geom 

*/

--for task3, A. Preparation:
--As we do not need shape_leng and shape_area we drop those two columns.
alter table nypp
drop column if exists shape_leng,
drop column if exists shape_area;

-- Following sql adds three new columns to nypp table to store the numbers of crashes, area sizes and crash densities
alter table nypp
add column crash_total integer,
add column area_sqml double PRECISION,
add column crash_density double PRECISION

--for task3, B. Compute:
-- Compute the area size, number of crashes and crash density for all police precincts using SQL queries. 


--size of area: in nypp table the column geom coordinate is in feet. So we need to convert to square miles. 
select gid, precinct, st_area(geom)*3.587*power(10,-8) area_sqml from nypp;


--Number of crashes:
select n.gid, count(*) from nypp n, crash c
where st_contains(n.geom,c.geom)
group by n.gid;


--crash density
with t as
(select n.gid, count(*) crash_total,n.precinct, n.geom,
st_area(n.geom) * 3.587*power(10,-8) area_sqml 
from nypp n, crash c
where st_contains(n.geom,c.geom)
group by n.gid)
select t.gid, t.precinct,t.crash_total,t.area_sqml,
t.crash_total/t.area_sqml crash_density, t.geom from t;


/*
What to use a the WFS services for
A WFS allows uniform direct access to the features stored on a server. Use a WFS when they want to perform actions such as:

query a dataset and retrieve the features
find the feature definition (feature’s property names and types)
add features to dataset
delete feature from a dataset
update feature in a dataset
lock features to prevent modification

A WFS returns data using Geography Markup Language (GML),
 a specification for expressing GIS data using XML. 
 GML can contain both geometry and attribute information. Because it is based on XML 
WFS 
A WMS allows for uniform rendering access to features stored on a server. Use a WMS when you want to perform actions such as:
Producing Maps
Very simple Querying of data


When user clicks on a region of the map, WMS-GetFeatureInfo is called to get the region id. 
Then WFS-GetFeature is called which retrieves the data in gml format based on the region id.
infotemplate.html is used to show the data in the html file.
Below is a snapshot of the request in the browser.
*/





