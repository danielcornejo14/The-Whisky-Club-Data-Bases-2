const mssql = require('mssql')

module.exports = {
    testConnection
}

const config = {
    user: process.env.MSSQL_USER,
    password: process.env.MSSQL_PASSWORD,
    server: process.env.MSSQL_HOST,
    database: process.env.MSSQL_DATABASE,
    options: {
        encrypt: true, // for azure
        trustServerCertificate: true // change to true for local dev / self-signed certs
    }
}
async function testConnection(){
    await mssql.connect(config)
    const query = await mssql.query(`select * from dbo.num`)
    console.dir(query.recordset)
}
