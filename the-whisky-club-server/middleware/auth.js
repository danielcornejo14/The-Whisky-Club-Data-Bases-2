const jwt = require('jsonwebtoken')

module.exports = {
    generateToken,
    verifyToken
}

function generateToken(username){
    return jwt.sign(username, process.env.TOKEN_SECRET, {expiresIn: '120000s'})
}
function verifyToken (req, res, next){
    const authHeader = req.headers['auth']
    const token = authHeader && authHeader.split(' ')[1]

    console.log(token)

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