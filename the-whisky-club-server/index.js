require('dotenv').config()
const express = require('express')
const cors = require('cors')
const bodyParser = require('body-parser')

const app = express()

app.use(cors())
app.use(bodyParser.json())

app.use('/user', require('./users/users.controller'))
app.use('/main-db', require('./Databases/MsSql/mainframe.controller'))

const port = process.env.API_PORT

app.listen(port, ()=>{
    console.log(`server is running on port ${port}`)
})
