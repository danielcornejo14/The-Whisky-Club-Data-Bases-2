const express = require('express')
const router = express.Router()
const usService = require('./scotland.service')


router.post('/selectTotal', selectTotal) 
router.post('/insertSale', insertSale)

module.exports = router

async function selectTotal(req, res){
    usService.selectTotal(req.body)
    res.send({tomelo: "tomelo"})
}

async function insertSale(req, res){
    usService.insertSale(req.body)
    res.send({tomelo: "tomelo"})
}