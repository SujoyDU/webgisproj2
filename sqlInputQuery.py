
'''
1989,1,9,1,1,1021044,243582

INSERT INTO crashtest (crash_year,accident_type,collision_type,weather_condition,light_condition,geom) 
VALUES ('1989','1','9','1','1',ST_GeomFromText('POINT(1021044 243582)', 2263));
'''


 
def config(filename='database.ini', section='postgresql'):
    # create a parser
    parser = ConfigParser()
    # read config file
    parser.read(filename)
 
    # get section, default to postgresql
    db = {}
    if parser.has_section(section):
        params = parser.items(section)
        for param in params:
            db[param[0]] = param[1]
    else:
        raise Exception('Section {0} not found in the {1} file'.format(section, filename))
 
    return db


 
def connect():
    """ Connect to the PostgreSQL database server """
    conn = None
    try:
        # read connection parameters
        params = config()
 
        # connect to the PostgreSQL server
        print('Connecting to the PostgreSQL database...')
        conn = psycopg2.connect(**params)
      
        # create a cursor
        cur = conn.cursor()
        
   # execute a statement
        print('PostgreSQL database version:')
        cur.execute('SELECT version()')
 
        # display the PostgreSQL database server version
        db_version = cur.fetchone()
        print(db_version)
       
       # close the communication with the PostgreSQL
        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()
            print('Database connection closed.')
 
 

def outputQuery(value,id):
    #value = ['1989','1','9','1','1','1021044','243582']
    f = open('input.sql','a+')
    dbname = 'crashtest'
    mystr = 'insert into '+ dbname+ ' values ('+ "'" + str(id+1) + "',"
    geometry = "ST_GeomFromText('POINT("+value[-2]+ " "+ value[-1]+ ")',2263));\n"
    for x in value[:-2]:
        mystr = mystr + "'" + x + "',"
    
    mystr = mystr+geometry
    f.write(mystr)
    f.close()

def inserIntoDB():
    input = "INSERT INTO crashtest (crash_year,accident_type,collision_type,weather_condition,light_condition,geom) \
             VALUES ('1989','1','9','1','1',ST_GeomFromText('POINT(1021044 243582)', 2263))"
    
       
filename = 'nyccrash.txt'
with open (filename) as f:
    data = f.readlines()

for id,val in enumerate(data):
    outputQuery(val.rstrip().rsplit(','),id)
#outputQuery()
#psql -U your_username -d dbname -f single_table_data.sql



#connect()