require('dotenv').config()
const express = require('express')
const cors = require('cors')
const bodyParser = require('body-parser')

const auth = require('./middleware/auth')

const app = express()

app.use(cors())
app.use(bodyParser.json())

app.post('/getToken', (req, res) =>{
    console.log(req.body.username)
    const token = auth.generateToken({username: req.body.username})
    res.json({jwt: token})
})

app.get('/authToken', auth.verifyToken, (req, res)=>{
    res.json({message: "authorized"})
})

const port = process.env.PORT

app.listen(port, ()=>{
    console.log(`server is running on port ${port}`)
})

//"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImRhbmllbCIsImlhdCI6MTY1MzkzNTgxMiwiZXhwIjoxNjUzOTM1OTMyfQ.2VU0dne6TUVQytMzOYzXUXPwhnd-jt9SKnNxv4iSDUg"