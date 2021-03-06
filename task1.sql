create table crashtest(
	gid serial primary key,
	crash_year integer,
	accident_type integer, 
	collision_type integer,
	weather_condition integer,
	light_condition integer,
	geom geometry(point,2263)
);


create table tri(
	gid serial primary key,
	triname varchar,
	geom geometry(triangle,2263)
);


insert into tri values('1','A',ST_GeomFromText('TRIANGLE((40.767967747644725 -73.9783290529785, 40.75860640420429 -73.9237407351074, 40.78369703538845 -73.97266422753904, 40.767967747644725 -73.9783290529785))',2263))

insert into tri values('2','B',ST_GeomFromText('TRIANGLE((40.77978920715366 -73.92294070696067, 40.75860640420429 -73.9237407351074, 40.78369703538845 -73.97266422753904, 40.77978920715366 -73.92294070696067))',2263))




drop table crashtest

INSERT INTO geotable ( the_geom, the_name )
  VALUES ( ST_GeomFromText('POINT(-126.4 45.32)', 312), 'A Place');

INSERT INTO crashtest (crash_year,accident_type,collision_type,weather_condition,light_condition,geom) 
VALUES ('1989','1','9','1','1',ST_GeomFromText('POINT(1021044 243582)', 2263));

INSERT INTO crashtest (crash_year,accident_type,collision_type,weather_condition,light_condition,geom) 
VALUES ('1989','2','9','2','4',ST_GeomFromText('POINT(1000630 156392)', 2263));

INSERT INTO crashtest (crash_year,accident_type,collision_type,weather_condition,light_condition,geom) 
VALUES ('1989','1','1','1','4',ST_GeomFromText('POINT(1039391 183509)', 2263));


--nypp  gid, precinct,geom
--crashtest gid, crash_year,accident_type,collision_type,weather_condition,light_condition,geom

-- number of crashes
select n.gid, count(*) from nypp n, crashtest c
where st_contains(n.geom,c.geom)
group by n.gid;


--size of area
select gid, precinct, st_area(geom) area_sqft,st_area(geom)*3.587*power(10,-8) area_sqml, shape_area from nypp;

select * from nypp;



--density of crashes
create table nypp_crash as
with t as
(select n.gid, count(*) crash_total,n.precinct, n.geom,
st_area(n.geom) area_sqft, st_area(n.geom) * 3.587*power(10,-8) area_sqml 
from nypp n, crashtest c
where st_contains(n.geom,c.geom)
group by n.gid)
select t.gid, t.precinct,t.crash_total,t.crash_total/t.area_sqml crash_density,
t.area_sqft, t.area_sqml, t.geom from t;


