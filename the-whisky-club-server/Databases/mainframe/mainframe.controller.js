const express = require('express')
const jwt = require('jsonwebtoken')
const router = express.Router()
const mainframeService = require('./mainframe.service')


router.get('/selectWhiskeyAdmin', selectWhiskeyAdmin)
router.get('/selectWhiskeyType', selectWhiskeyType)
router.get('/selectPresentation', selectPresentation)
router.get('/selectSupplier', selectSupplier)
router.get('/selectCurrency', selectCurrency)
router.get('/selectPaymentMethod', selectPaymentMethod)
router.get('/selectSubscription', selectSubscription)

router.post('/updateWhiskey', updateWhiskey)
router.post('/insertWhiskey', insertWhiskey)
router.post('/deleteWhiskey', deleteWhiskey)
router.post('/insertCustomer', insertCustomer)
router.post('/deleteSubscription', deleteSubscription)
router.post('/updateSubscription', updateSubscription)
router.post('/insertSubscription', insertSubscription)
router.post('/insertWhiskeyType', insertWhiskeyType)
router.post('/updateWhiskeyType', updateWhiskeyType)
router.post('/deleteWhiskeyType', deleteWhiskeyType)
router.post('/insertPresentation', insertPresentation)
router.post('/updatePresentation', updatePresentation)
router.post('/deletePresentation', deletePresentation)
router.post('/insertCurrency', insertCurrency)
router.post('/updateCurrency', updateCurrency)
router.post('/deleteCurrency', deleteCurrency)
router.post('/selectWhiskeyReview', selectWhiskeyReview)
router.post('/insertReview', insertReview)
router.post('/selectSales', selectSales)
router.post('/selectWhiskey', selectWhiskey)

router.post('/queryCustomerReport', queryCustomerReport)
router.post('/queryEmployeeReport', queryEmployeeReport)
router.post('/querySalesReport', querySalesReport)

module.exports = router


//===================================INSERT=============================

async function insertWhiskey(req, res){
    const data = req.body
    const result = await mainframeService.insertWhiskey(data)
}

async function insertCustomer(req, res){
    const data = req.body
    await mainframeService.insertCustomer(data)
}

async function insertSubscription(req, res){
    const data = req.body
    await mainframeService.insertSubscription(data)
}

async function insertWhiskeyType(req, res){
    const data = req.body
    await mainframeService.insertWhiskeyType(data)
}

async function insertPresentation(req, res){
    const data = req.body
    await mainframeService.insertPresentation(data)
}

async function insertCurrency(req, res){
    const data = req.body
    await mainframeService.insertCurrency(data)
}

async function insertReview(req, res){
    const data = req.body
    await mainframeService.insertReview(data)
}

//===================================SELECT=============================

async function selectWhiskey(req, res){
    const data = req.body
    const recordset = await mainframeService.selectWhisky(data.username) 
    res.send(recordset)
}

async function selectWhiskeyAdmin(req,res){
    const recordset = await mainframeService.selectWhiskyAdmin() 
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

async function selectPaymentMethod(req, res){
    const recordset = await mainframeService.selectPaymentMethod() 
    res.send(recordset)
}

async function selectSubscription(req, res){
    const recordset = await mainframeService.selectSubscription() 
    res.send(recordset)
}

async function selectWhiskeyReview(req, res){
    const data = req.body
    const recordset = await mainframeService.selectWhiskeyReviews(data.id)
    res.send(recordset)
}

async function selectSales(req, res){
    const data = req.body
    const recordset = await mainframeService.selectSales(data.username)
    res.send(recordset)
}

//===================================UPDATE=============================
async function updateWhiskey(req, res){
    const data = req.body
    const result = await mainframeService.updateWhiskey(data)
}

async function updateSubscription(req, res){
    const data = req.body
    await mainframeService.updateSubscription(data)
}

async function updateWhiskeyType(req, res){
    const data = req.body
    await mainframeService.updateWhiskeyType(data)
}

async function updatePresentation(req, res){
    const data = req.body
    await mainframeService.updatePresentation(data)
}

async function updateCurrency(req, res){
    const data = req.body
    await mainframeService.updateCurrency(data)
}

//===================================DELETE=============================
async function deleteWhiskey(req, res){
   const data = req.body
   await mainframeService.deleteWhiskey(data.id) 
}

async function deleteSubscription(req, res){
    const data = req.body
    await mainframeService.deleteSubscription(data.id) 
}

async function deleteWhiskeyType(req, res){
    const data = req.body
    await mainframeService.deleteWhiskeyType(data.id)
}

async function deletePresentation(req, res){
    const data = req.body
    await mainframeService.deletePresentation(data.id)
}

async function deleteCurrency(req, res){
    const data = req.body
    await mainframeService.deleteCurrency(data.id)
}

//=============================REPORTS==============================

async function queryCustomerReport(req, res){
    const data = req.body
    const result = await mainframeService.queryCustomerReport(data)
    res.send(result)
}

async function queryEmployeeReport(req, res){
    const data = req.body
    const result = await mainframeService.queryEmployeeReport(data)
    res.send(result)
}

async function querySalesReport(req, res){
    const data = req.body
    const result = await mainframeService.querySalesReport(data)
    res.send(result)
}
