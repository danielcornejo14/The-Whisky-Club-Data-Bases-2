const express = require('express')
const router = express.Router()
const jwt = require('jsonwebtoken')
const userService = require('./users.service')
const employeeService = require("../Databases/employees/employees.service")


router.post('/authAdmin', authAdmin)
router.post('/authCustomer', authCustomer)
router.post('/authEmployee', authEmployee)

module.exports = router;

async function authAdmin(req, res){
    if (await userService.authAdmin(req.body.username, req.body.password)){
        const token = jwt.sign(req.body.username, process.env.TOKEN_SECRET, {})
        res.json({"token": token})
    }
    else{
        res.sendStatus(401)
    }
}

async function authCustomer(req, res){
    if (await userService.authCustomer(req.body.username, req.body.password)){
        const token = jwt.sign(req.body.username, process.env.TOKEN_SECRET, {})
        res.json({"token": token})
    }
    else{
        res.sendStatus(401)
    }
}

function authEmployee(req, res){
    const data = req.body
    employeeService.authEmployee(data.username, data.password, res)
}