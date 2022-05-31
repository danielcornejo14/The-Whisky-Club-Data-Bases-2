const mssql = require('mssql')
module.exports= {
    testDatabase
}

const config = {
    user: process.env.MSSQL_USER,
    password: process.env.MSSQL_PASSWORD,
    database: process.env.MSSQL_DB_MAINFRAME,
    server: process.env.MSSQL_HOST,
    options: {
      encrypt: true, // for azure
      trustServerCertificate: true // change to true for local dev / self-signed certs
    }
}

async function testDatabase(){
    await mssql.connect(config)
    const result = await mssql.query`select * from Administrator`
    console.log(result.recordset)
}
