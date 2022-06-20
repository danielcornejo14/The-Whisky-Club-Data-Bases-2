const { json } = require('body-parser')
const express = require('express')
const router = express.Router()
const usService = require('./unitedstates.service')


router.post('/selectTotal', selectTotal) 
router.post('/insertSale', insertSale)
router.post('/filterWhiskey', filterWhiskey)

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

async function filterWhiskey(req, res){
    const data = req.body
    const result = await usService.filterWhiskey(data)
    res.send(result)
}