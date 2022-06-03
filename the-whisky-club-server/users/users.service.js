const mainframeService = require("../Databases/MsSql/mainframe.service");
const jwt = require("jsonwebtoken");

module.exports = {
    authAdmin
}

async function authAdmin(username, password) {
    return await mainframeService.verifyAdmin(username, password)
}
