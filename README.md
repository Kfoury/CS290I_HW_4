# CS290I_HW_4
In this assigment you will be creating a cloud mySQL database hosted on pythonanywhere.com.
The webserver database will contain one table **lat_long_table** . The table will have four fields as follows:
* lat (float)
* longi (float)
* description (varchar(100))
* id (Primary key, autoincrement)

**The following mySQL bash code can be used to create your database**
> MySQL Code
CREATE TABLE lat_long_table (id INT NOT NULL AUTO_INCREMENT, description VARCHAR(100) NOT NULL, lat float , longi float , epoch int(11), PRIMARY KEY ( id ));


**Flask Webmethod to implement**

   @app.route('/push_location_data_290I',methods=['POST'])
   def push_location_data():
    #return "ff"


    db = MySQLdb.connect("mysql.server","fadikf","151515","fadikf$default" )
    cursor = db.cursor()
    #return json.dumps({'response':data['lat']})


    #return str(data['lat'])

    try:
        data = json.loads(request.data)
        
        latitude=data['lat']
        longitude=data['long']
        #batteryLife = data['bat']
        #acc_x = data['acc_x']
        #acc_y = data['acc_y']
        #acc_z = data['acc_z']
        #time_stamp = data['time_stamp']
        #reading_tag = data['tag']
        device_id = data['issuer_id']
    except:
        return json.dumps({'response_description':'invalid_input','response_int':0})

    t=time.time()


    a=""
    try:
        cursor.execute("INSERT INTO lat_long_table (description, lat, longi, epoch)  VALUES ("+"'"+device_id+"'"+","+str(latitude)+","+str(longitude)+","+str(int(t))+");")

        db.commit()
        return json.dumps({'response_description':'data saved','response_int':1})

    except:
        db.rollback()
        return json.dumps({'response_description':'error saving the data','response_int':2})

**Remember to import these libraries**
    import MySQLdb
    from flask import Flask
    from flask import request
    import json
    import socket, ssl, struct
    import time
    import random
 
