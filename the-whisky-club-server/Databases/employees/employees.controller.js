const express = require('express')
const jwt = require('jsonwebtoken')
const router = express.Router()

const employeeService = require('./employees.service')

router.get('/testdb', testdb)

router.get('/selectDepartment', selectDepartment)
router.get('/selectEmployees', selectEmployees)
router.get('/selectEmployeeReview', selectEmployeeReview)
router.get('/selectEmployeeType', selectEmployeeType)

router.post('/updateEmployee', updateEmployee)

module.exports = router

//TODO #5 send employee data to front end

function testdb(req, res){
    employeeService.testdb(res)
}

function selectDepartment(req, res){
    employeeService.selectDepartment(res)
}

function selectEmployees(req, res){
    employeeService.selectEmployees(res)

}

function selectEmployeeReview(req, res){
    employeeService.selectEmployeeReview(res)
}

function selectEmployeeType(req, res){
    employeeService.selectEmployeeType(res)
}

function updateEmployee(req, res){
    const data = req.body
    console.log(data)
    employeeService.updateEmployee(data, res)
    
}