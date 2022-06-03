const jwt = require('jsonwebtoken')
const mainframe = require('../Databases/MsSql/mainframe.controller')

module.exports = {
    login,
    verifyToken
}

async function login(req, res, next){
    console.log(req.body)
    const reqData = {
        username: req.body.username,
        password: req.body.password
    }
    if(await mainframe.verifyAdmin(reqData.username, reqData.password)){

    }
    next();
    // return jwt.sign(username, process.env.TOKEN_SECRET, {})
}
function verifyToken (req, res, next){
    const authHeader = req.headers['Authorization']
    const token = authHeader && authHeader.split(' ')[1]



    if(token == null){
        return res.sendStatus(401)
    }
    else{
        jwt.verify(token, process.env.TOKEN_SECRET, (err, user) =>{
            console.log(err)
            if(err){
                return res.sendStatus(403)
            }
            else{
                req.user = user
                next()
            }

        })
    }
}