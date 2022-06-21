const mysql = require('mysql');
const jwt = require('jsonwebtoken')


module.exports = {
  selectEmployees,
  selectDepartment,
  selectEmployeeReview,
  selectEmployeeType,
  updateEmployee,
  deleteEmployee,
  insertEmployee,
  authEmployee,
  updateReview,
  insertReport
}

const config = {
  host: process.env.HOST,
  user: process.env.MYSQL_USER,
  password: process.env.MYSQL_PASSWORD,
  database: process.env.MYSQL_DB
}

const employeedb = mysql.createConnection(config);


//=============SELECT==============================

function authEmployee(username, password,res){
  employeedb.query(`call employees_db.validateEmployee('${username}','${password}')`, (err, result, field)=>{
    if (err){ console.log(err)}
    else{
      console.log(username, password)
      if(result[0][0].message == '00'){
        const token = jwt.sign(username, process.env.TOKEN_SECRET, {})
        res.json({"token": token})
      }     
      else{
        res.send(401)
      }
    }
  })
}

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
    ${data.idShop},
    '${data.name}', 
    '${data.lastName1}',
    '${data.lastName2}', 
    ${data.localSalary}, 
    ${data.dollarSalary})`, (err, recordset, fields) =>{
    if(err){console.log(err)}
  })
}

function updateReview(data, res){
  console.log(data)
  employeedb.query(`call employees_db.updateEmployeeUnresolvedReviews(${data.idEmployeeReview}, '${data.comment}');`, (err, rec, field)=>{
    if(err){console.log(err)}
  })
}

//=============INSERT==============================
function insertEmployee(data, res){
  employeedb.query(`call employees_db.insertEmployee(${data.idDepartment},
    ${data.idEmployeeType},
    ${data.idShop},
    '${data.name}',
    '${data.lastName1}',
    '${data.lastName2}',
    ${data.localSalary},
    ${data.dollarSalary},
    '${data.username}',
    '${data.password}')`, (err, result, fields)=>{
      if(err){console.log(err)}
    })
}

function insertReport(data, res){
  employeedb.query(`call employees_db.insertEmployeeReview(
  '${data.username}',
  ${data.idEmployee},
  '${data.comment}',
  ${data.evaluation})`,(err,rec,field)=>{
    if(err){console.log(err)}
  })
}

//=============DELETE==============================

function deleteEmployee(id, res){
  employeedb.query(`call  employees_db.deleteEmployee(${id})`, (err, result, fields)=>{
    if(err){console.log(err)}
  })
}