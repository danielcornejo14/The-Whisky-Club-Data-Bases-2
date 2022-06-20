const mssql = require('mssql')

module.exports = {
    selectTotal,
    insertSale,
    filterWhiskey
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

    mssql.close()
    await mssql.connect(config)
    console.log(order)
    try{
        const result = await mssql.query(`exec processSale '${order}'`)
        mssql.close()
        console.log(result.recordset)
    }
    catch(err){ 
        console.log(err)  
    }
}

async function filterWhiskey(filter){
    mssql.close()
    await mssql.connect(config)
    console.log(filter)
    try{
        const result = await mssql.query(`exec filterWhiskeys '${filter.username}',
        ${filter.whiskeyType},
        '${filter.name}',
        ${filter.price},
        ${filter.existance},
        ${filter.distanceOrder},
        ${filter.popularity}`)
   
       

        for(let i = 0; i < result.recordset.length; i++){
            const imageRecordset = await mssql.query(` use Mainframe_db;
            exec selectImage ${result.recordset[i].idWhiskey}`)
            let imageSet = []
    
            for(let j = 0; j < imageRecordset.recordset.length; j++){
                imageSet.push(imageRecordset.recordset[j].image)
            }
            
            result.recordset[i].images = imageSet
        }

        mssql.close()

        console.log(result.recordset)

        return result.recordset
    }
    catch(err){
        console.log(err)
    }
}