const mysql = require('mysql');

module.exports = {
  testdb,
  selectEmployees,
  selectDepartment,
  selectEmployeeReview,
  selectEmployeeType,
  updateEmployee,
  deleteEmployee,
  insertEmployee
}

const config = {
  host: process.env.HOST,
  user: process.env.MYSQL_USER,
  password: process.env.MYSQL_PASSWORD,
  database: process.env.MYSQL_DB
}

const employeedb = mysql.createConnection(config);


function testdb(res){

  employeedb.query(`select 1 + 1 as solution`, (err, result, fields)=>{
    if(err) throw err;
    res.send(result[0].solution)
  })
}

//=============SELECT==============================


function selectEmployees(res){

  employeedb.query(`call employees_db.selectAllEmployees();`, (err, recordset, fields)=>{
    if(err){ console.log(err)}
    res.send(recordset[0])
  })
}

function selectDepartment(res){
  employeedb.query(`call employees_db.selectAllDepartments();`, (err,recordset,fields)=>{
    if(err){console.log(err)}
    res.send(recordset[0]) 
  })
}

function selectEmployeeType(res){
  employeedb.query(`call employees_db.selectAllEmployeeTypes();`, (err,recordset,fields)=>{
    if(err){console.log(err)}
    res.send(recordset[0])
  })
}

function selectEmployeeReview(res){
  employeedb.query(`call employees_db.selectAllEmployeeReviews();`, (err,recordset,fields)=>{
    if(err){console.log(err)}
    res.send(recordset[0])
  })
}

//=============UPDATE==============================

function updateEmployee(data, res){
  employeedb.query(`call employees_db.updateEmployee(${data.idEmployee}, 
    ${data.idDepartment},
    ${data.idEmployeeType}, 
    '${data.name}', 
    '${data.lastName1}',
    '${data.lastName2}', 
    ${data.localSalary}, 
    ${data.dollarSalary})`, (err, recordset, fields) =>{
    if(err)console.log(err)
  })
}

//=============INSERT==============================
function insertEmployee(data, res){
  employeedb.query(`call employees_db.insertEmployee(${data.idDepartment},
    ${data.idEmployeeType},
    '${data.name}',
    '${data.lastName1}',
    '${data.lastName2}',
    ${data.localSalary},
    ${data.dollarSalary},
    '${data.username}',
    '${data.password}')`, (err, result, fields)=>{
      if(err)console.log(err)
    })
}

//=============DELETE==============================

function deleteEmployee(id, res){
  employeedb.query(`call  employees_db.deleteEmployee(${id})`, (err, result, fields)=>{
    if(err) console.log(err)
  })
}