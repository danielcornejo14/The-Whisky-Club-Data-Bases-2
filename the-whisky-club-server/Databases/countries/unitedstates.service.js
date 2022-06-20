const mssql = require('mssql')

module.exports = {
    selectTotal,
    insertSale
}

const config = {
    user: process.env.MSSQL_USER,
    password: process.env.MSSQL_PASSWORD,
    database: 'UnitedStates_db',
    server: process.env.HOST,
    options: {
        encrypt: true, // for azure
        trustServerCertificate: true // change to true for local dev / self-signed certs
    }
}

async function selectTotal(order){
    mssql.close()
    await mssql.connect(config)
    console.log(order)
    try{
        const result = await mssql.query(`exec selectSaleInfo '${order}'`)
        mssql.close()
        return result.recordset[0]
    }
    catch(err){
        console.log(err) 
    }

}

async function insertSale(order){ 

    console.log(order)

    // mssql.close()

    // await mssql.connect(config)
    // let result;
    // if(order.location.lat == undefined){
    //     result = await mssql.query(``).catch((err)=> console.log(err))
    //     mssql.close()
    // }
    // else{
    //     result = await mssql.query(``).catch((err)=> console.log(err))
    //     mssql.close()
    // }
}