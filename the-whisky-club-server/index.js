require('dotenv').config()
const express = require('express')
const cors = require('cors')
const bodyParser = require('body-parser')

const app = express()

app.use(cors())
app.use(bodyParser.json())

app.use('/user', require('./users/users.controller'))
app.use('/main-db', require('./Databases/MsSql/mainframe.controller'))

app.get('/', (req,res)=>{
    res.json({message: "this is on codespaces"})
})


const port = process.env.API_PORT

app.listen(port, ()=>{
    console.log(`server is running on port http://localhost:${port}`)    
})
