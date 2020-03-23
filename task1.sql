create table crashtest(
	gid serial primary key,
	crash_year integer,
	accident_type integer, 
	collision_type integer,
	weather_condition integer,
	light_condition integer,
	geom geometry(point,2263)
);

drop table crashtest


INSERT INTO crashtest (crash_year,accident_type,collision_type,weather_condition,light_condition,geom) 
VALUES ('1989','1','9','1','1',ST_GeomFromText('POINT(1021044 243582)', 2263));

INSERT INTO crashtest (crash_year,accident_type,collision_type,weather_condition,light_condition,geom) 
VALUES ('1989','2','9','2','4',ST_GeomFromText('POINT(1000630 156392)', 2263));

INSERT INTO crashtest (crash_year,accident_type,collision_type,weather_condition,light_condition,geom) 
VALUES ('1989','1','1','1','4',ST_GeomFromText('POINT(1039391 183509)', 2263));
                               