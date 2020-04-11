def outputQuery(value,id):
    f = open('crashdata.sql','a+')
    tableName = 'crash'
    mystr = 'insert into '+ tableName+ ' values ('+ "'" + str(id+1) + "',"
    geometry = "ST_GeomFromText('POINT("+value[-2]+ " "+ value[-1]+ ")',2263));\n"
    for x in value[:-2]:
        mystr = mystr + "'" + x + "',"
    
    mystr = mystr+geometry
    f.write(mystr)
    f.close()

if __name__ == "__main__":
    filename = 'nyccrash.txt'
    with open (filename) as f:
        data = f.readlines()

    for id,val in enumerate(data):
        outputQuery(val.rstrip().rsplit(','),id)