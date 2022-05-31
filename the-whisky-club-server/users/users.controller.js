const express = require('express')
const router = express.Router()
const auth = require('../middleware/auth')

router.post('/authAdmin',authAdmin)

module.exports = router

function authAdmin(req, res){
    res.json({
        message: true
    })
}