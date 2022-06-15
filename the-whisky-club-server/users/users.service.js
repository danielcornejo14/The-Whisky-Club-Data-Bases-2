const mainframeService = require("../Databases/mainframe/mainframe.service");
const jwt = require("jsonwebtoken");
const { response } = require("express");

module.exports = {
    authAdmin
}

async function authAdmin(username, password) {
    const response = await mainframeService.verifyAdmin(username, password)
    console.log(response) 
    return response
}
