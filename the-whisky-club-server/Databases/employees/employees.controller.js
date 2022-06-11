const express = require('express')
const jwt = require('jsonwebtoken')
const router = express.Router()

const employeeService = require('./employees.service')

router.get('/testdb', testdb)

router.get('/selectDepartment', selectDepartment)
router.get('/selectEmployees', selectEmployees)
router.get('/selectEmployeeReview', selectEmployeeReview)
router.get('/selectEmployeeType', selectEmployeeType)

module.exports = router

//TODO #5 send employee data to front end

function testdb(req, res){
    console.log(employeeService.testdb())
}

function selectDepartment(req, res){

}

function selectEmployees(req, res){

}

function selectEmployeeReview(req, res){

}

function selectEmployeeType(req, res){

}