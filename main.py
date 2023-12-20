
from flask import Flask, request, jsonify
from flask_cors import CORS
import pymysql
from datetime import datetime

app = Flask(__name__)
CORS(app)
con=pymysql.connect(host='localhost',port=3306,user='root',password='password',db='mydata')
cmd=con.cursor()

@app.route('/login', methods=['GET','POST'])
def login():
    data=request.get_json()
    name=data['username']
    pword=data['password']
    cmd.execute("select * from login where userid='"+str(name)+"' and password='"+str(pword)+"' ")
    s = cmd.fetchone()
    if s==None:
        resdata = {'status': 'F'}
    else:
        print(s)
        resdata = {'status': 'T','type':s[2]}

    return jsonify(resdata)

@app.route('/signup', methods=['GET','POST'])
def sign():
    data=request.get_json()
    fname=data['fname']
    lname = data['lname']
    contact=data['contact']
    email=data['email']
    uname=data['userid']
    pword=data['password']
    type='cust'
    cmd.execute("select * from users where userid='"+str(uname)+"'")
    s=cmd.fetchone()
    if s==None:
        cmd.execute("insert into login values('"+uname+"','"+pword+"','"+type+"')")
        cmd.execute("insert into users values('"+fname+"','"+lname+"','"+str(contact)+"','"+email+"','"+uname+"','"+pword+"') ")
        try:
            con.commit()
            return jsonify({'task': "success"})
        except Exception as e:
            print(str(e))
            return jsonify({'task': "Failed"})
    else:
        return jsonify({'task': "Userid exists"})

@app.route('/viewusers', methods=['GET','POST'])
def viewuser():
    cmd.execute("select * from users")
    s = cmd.fetchall()
    if s==None:
        resdata = {'status': 'F'}
    else:
        print(s)
        resdata = {'status': 'T','data':s}

    return jsonify(resdata)

@app.route('/deleteuser', methods=['GET','POST'])
def deleteuser():
    data=request.get_json()

    id=data['userid']
    print(id)
    cmd.execute("delete from users where userid='"+str(id)+"'")
    cmd.execute("delete from login where userid='" + str(id) + "'")
    con.commit()

    return jsonify({'task': 'success'})

@app.route('/userdeleteslot', methods=['GET','POST'])
def userdeleteslot():
    data=request.get_json()
    id=data['id']

    print(id)
    cmd.execute("delete from parkinglot where id='"+str(id)+"'")
    con.commit()

    return jsonify({'task': 'success'})

@app.route('/userslotlist', methods=['GET','POST'])
def userslotlist():
    data=request.get_json()
    id=data['userid']
    date=data['date']
    date_object = datetime.strptime(date, "%Y-%m-%d")
    formatted_date = date_object.strftime("%Y-%m-%d")
    cmd.execute("select * from parkinglot where userid='"+str(id)+"' and date='"+formatted_date+"'")
    s = cmd.fetchall()
    if s==None:
        resdata = {'status': 'F'}
    else:
        resdata = {'status': 'T', 'data': s}

    return jsonify(resdata)

    return jsonify({'task': 'success'})


@app.route('/userandslotdetails', methods=['GET','POST'])
def userandslotdetails():
    data=request.get_json()
    date=data['date']
    date_object = datetime.strptime(date, "%Y-%m-%d")
    formatted_date = date_object.strftime("%Y-%m-%d")
    cmd.execute("select users.firstname,users.contact,parkinglot.id,parkinglot.slotid,parkinglot.starttime,parkinglot.endtime from users inner join parkinglot on users.userid=parkinglot.userid where date='"+formatted_date+"'")
    s = cmd.fetchall()
    if s==None:
        resdata = {'status': 'F'}
    else:
        print(s)
        resdata = {'status': 'T', 'data': s}

    return jsonify(resdata)

    return jsonify({'task': 'success'})


@app.route('/getuserdetails', methods=['GET','POST'])
def getuserdetails():
    data=request.get_json()
    id=data['slotid']
    date=data['date']
    date_object = datetime.strptime(date, "%Y-%m-%d")
    formatted_date = date_object.strftime("%Y-%m-%d")
    cmd.execute("select userid from parkinglot where id='"+str(id)+"' and date='"+formatted_date+"'")
    s = cmd.fetchone()
    if s==None:
        resdata = {'status': 'F'}
    else:
        print(s[0])
        cmd.execute("select * from users where userid='"+str(s[0])+"'")
        user=cmd.fetchone()
        print(user)
        resdata = {'status': 'T','data':user}

    return jsonify(resdata)

@app.route('/slots', methods=['GET','POST'])
def slots():
    data=request.get_json()
    date=data['date']
    time1=data['start']
    time2=data['end']
    date_object = datetime.strptime(date, "%Y-%m-%d")
    formatted_date = date_object.strftime("%Y-%m-%d")
    first = datetime.strptime(time1, '%H:%M').time()
    sec = datetime.strptime(time2, '%H:%M').time()
    cmd.execute("select * from parkinglot where date='" + formatted_date + "'")
    s = cmd.fetchall()
    slots = []
    if s==None:
        resdata = {'status': 'F'}
    else:
        for items in s:
            strt=items[5]
            end=items[6]
            strttime=datetime.strptime(strt, '%H:%M').time()
            endtime=datetime.strptime(end, '%H:%M').time()
            if(first<=endtime and sec>=strttime):
                slots.append(items)
        print(slots)
        resdata = {'status': 'T', 'data': slots}

    return jsonify(resdata)

@app.route('/updateslot', methods=['GET','POST'])
def updateslot():
    data=request.get_json()

    id=data['slotid']
    date=data['date']
    userid=data['userid']
    start=data['start']
    end=data['end']
    date_object = datetime.strptime(date, "%Y-%m-%d")

    # Now, date_object contains the datetime representation of the string
    # If you want to format the date as a string before sending it to MySQL, you can use strftime
    formatted_date = date_object.strftime("%Y-%m-%d")
    cmd.execute("insert into parkinglot values('','"+str(id)+"','booked','"+str(userid)+"','"+formatted_date+"','"+str(start)+"','"+str(end)+"')")
    con.commit()

    return jsonify({'task': 'success'})


@app.route('/freeslot', methods=['GET','POST'])
def freeslot():
    data=request.get_json()

    id=data['slotid']
    date=data['date']
    date_object = datetime.strptime(date, "%Y-%m-%d")

    # Now, date_object contains the datetime representation of the string
    # If you want to format the date as a string before sending it to MySQL, you can use strftime
    formatted_date = date_object.strftime("%Y-%m-%d")
    cmd.execute("delete from parkinglot where date='"+formatted_date+"' and id='"+str(id)+"'")
    con.commit()

    return jsonify({'task': 'success'})


@app.route('/getbookingdetails', methods=['GET','POST'])
def getbookingdetails():
    # data=request.get_json()
    # id=data['slotid']
    # date=data['date']
    date='2023-11-30'
    date_object = datetime.strptime(date, "%Y-%m-%d")
    formatted_date = date_object.strftime("%Y-%m-%d")
    timestr='14:10'
    timestr2='16:00'
    first = datetime.strptime(timestr, '%H:%M').time()
    sec=datetime.strptime(timestr2, '%H:%M').time()
    cmd.execute("select * from parkinglot where date='"+formatted_date+"'")
    s = cmd.fetchall()
    slots=[]
    if(s==None):
        resdata = {'status': 'F'}
    else:
        for items in s:
            strt=items[4]
            end=items[5]
            strttime=datetime.strptime(strt, '%H:%M').time()
            endtime=datetime.strptime(end, '%H:%M').time()
            if(first<=endtime and sec>=strttime):
                slots.append(items)
            

    print(slots)
    return None

if __name__ == '__main__':
    app.run(host='192.168.158.92', port=5000)