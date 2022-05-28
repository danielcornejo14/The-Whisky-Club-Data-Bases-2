require('dotenv').config()
const express = require('express')
const bodyParser = require('body-parser')
const cors = require('cors')
const mysqlController = require('./MySQL/MySQLController')
const mssqlController = require('./SQL_Server/MSSQLController')


const app = express()
app.use(cors())


app.get('/', function (req, res) {
    mysqlController.testConnection()
    mssqlController.testConnection()
    res.send('Hello World')
})

app.listen(3000, ()=>{
    console.log('listening on port 3000')
})