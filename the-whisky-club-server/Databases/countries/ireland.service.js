const mssql = require('mssql')

module.exports = {
    selectTotal,
    insertSale,
    filterWhiskey
    
}

const config = {
    user: process.env.MSSQL_USER,
    password: process.env.MSSQL_PASSWORD,
    database: process.env.MSSQL_DB_IR,
    server: process.env.HOST,
    options: {
        encrypt: true, // for azure
        trustServerCertificate: true // change to true for local dev / self-signed certs
    }
}

async function selectTotal(order){
    mssql.close()
    
    await mssql.connect(config)
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
    await mssql.connect(config)
    let result;
    if(order.location.lat == undefined){
        result = await mssql.query(``).catch((err)=> console.log(err))
    }
    else{
        result = await mssql.query(``).catch((err)=> console.log(err))
    }
}

async function filterWhiskey(filter){
    mssql.close()
    await mssql.connect(config)

    try{
        const result = await mssql.query(`exec filterWhiskeys '${filter.username}',
        ${filter.whiskeyType},
        ${filter.name},
        ${filter.price},
        ${filter.existance},
        ${filter.distanceOrder},
        ${filter.popularity}`)
        mssql.close()
        console.log(result.recordset)
    }
    catch(err){
        console.log(err)
    }
}