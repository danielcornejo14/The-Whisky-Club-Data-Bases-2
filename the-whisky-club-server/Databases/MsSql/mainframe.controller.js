const express = require('express')
const jwt = require('jsonwebtoken')
const router = express.Router()
const mainframeService = require('./mainframe.service')

router.get('/testdb', testdb)

router.get('/selectWhiskey', selectWhiskey)
router.get('/selectWhiskeyType', selectWhiskeyType)
router.get('/selectPresentation', selectPresentation)
router.get('/selectSupplier', selectSupplier)
router.get('/selectCurrency', selectCurrency)

router.post('/updateWhiskey', updateWhiskey)

module.exports = router

async function testdb(req, res){
    res.json(await mainframeService.testdb())
}

async function selectWhiskey(req, res){
    const recordset = await mainframeService.selectWhisky()
    res.send(recordset)
}
async function selectPresentation(req,res){
    const recordset = await mainframeService.selectPresentation()
    res.send(recordset)
}

async function selectWhiskeyType(req,res){
    const recordset = await mainframeService.selectWhiskeyType()
    res.send(recordset)
}

async function selectSupplier(req,res){
    const recordset = await mainframeService.selectSupplier()
    res.send(recordset)
}

async function selectCurrency(req, res){
    const recordset = await  mainframeService.selectCurrency()
    res.send(recordset)
}

//===================================UPDATE=============================
async function updateWhiskey(req, res){
    const data = req.body
    await mainframeService.updateWhiskey(data)
    res.json({message: "tomelo"})
}
