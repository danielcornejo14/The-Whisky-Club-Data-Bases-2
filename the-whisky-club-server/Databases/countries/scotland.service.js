const mssql = require('mssql')

module.exports = {
    selectTotal,
    insertSale
}

const config = {
    user: process.env.MSSQL_USER,
    password: process.env.MSSQL_PASSWORD,
    database: process.env.MSSQL_DB_SC,
    server: process.env.HOST,
    options: {
        encrypt: true, // for azure
        trustServerCertificate: true // change to true for local dev / self-signed certs
    }
}

async function selectTotal(order){

    console.log(order)

    await mssql.connect(config)
    let result;
    if(order.location.lat == undefined){
        result = await mssql.query(``).catch((err)=> console.log(err))
    }
    else{
        result = await mssql.query(``).catch((err)=> console.log(err))
    }
}

async function insertSale(order){
    await mssql.connect(config)
    let result;
    if(order.location.lat == undefined){
        result = await mssql.query(``).catch((err)=> console.log(err))
    }
    else{
        result = await mssql.query(``).catch((err)=> console.log(err))
    }
}