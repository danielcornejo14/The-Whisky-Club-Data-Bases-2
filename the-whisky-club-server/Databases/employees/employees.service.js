const mysql = require('mysql');

module.exports = {
  testdb
}

const config = {
  host: process.env.HOST,
  user: process.env.MYSQL_USER,
  password: process.env.MYSQL_PASSWORD,
  database: process.env.MYSQL_DB
}

const employeedb = mysql.createConnection(config);


function testdb(){
  employeedb.connect()
   let result = employeedb.query(`select 1 + 1 as solution`, (err, res, fields)=>{
    if(err) throw err;
    return res[0].solution
  })
  return result
}