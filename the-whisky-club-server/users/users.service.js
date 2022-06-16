const mainframeService = require("../Databases/mainframe/mainframe.service");
const jwt = require("jsonwebtoken");
const { response } = require("express");

module.exports = {
    authAdmin,
    authCustomer
}

async function authAdmin(username, password) {
    const response = await mainframeService.verifyAdmin(username, password)
    console.log(response) 
    return response
}

async function authCustomer(username, password){
    const response = await mainframeService.verifyCustomer(username, password)
    console.log(response)
    return response
}
