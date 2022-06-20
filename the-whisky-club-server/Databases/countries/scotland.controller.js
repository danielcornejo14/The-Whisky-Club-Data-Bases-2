const express = require('express')
const router = express.Router()
const usService = require('./scotland.service')


router.post('/selectTotal', selectTotal) 
router.post('/insertSale', insertSale)

module.exports = router

async function selectTotal(req, res){
    const data = JSON.stringify(req.body)
    const result = await usService.selectTotal(data) 
    res.send(result) 
}

async function insertSale(req, res){
    const data = JSON.stringify(req.body)
    await usService.insertSale(data)

}