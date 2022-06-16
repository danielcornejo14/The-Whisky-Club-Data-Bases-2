const mssql = require('mssql')

module.exports = {
    testdb,
    verifyAdmin,
    selectWhisky,
    selectSupplier,
    selectPresentation,
    selectWhiskeyType,
    selectCurrency,
    updateWhiskey,
    insertWhiskey,
    insertCustomer,
    deleteWhiskey,
    verifyCustomer,
    selectPaymentMethod
}

const config = {
    user: process.env.MSSQL_USER,
    password: process.env.MSSQL_PASSWORD,
    database: process.env.MSSQL_DB_MAINFRAME,
    server: process.env.HOST,
    options: {
        encrypt: true, // for azure
        trustServerCertificate: true // change to true for local dev / self-signed certs
    }
}


async function testdb(){
    await mssql.connect(config) 
    const result = await mssql.query(`select * from Customer`)
    return result.recordset
}

//=============================INSERT==============================


async function insertWhiskey(whiskey){

    console.log(whiskey)

    await mssql.connect(config)
    const result = await mssql.query(`exec insertWhiskey ${whiskey.idSupplier},
    ${whiskey.idPresentation},
    ${whiskey.idCurrency},
    ${whiskey.idWhiskeyType},
    '${whiskey.brand}',
    ${parseFloat(whiskey.price)},
    ${whiskey.alcoholContent},
    '${whiskey.productionDate}',
    '${whiskey.dueDate}',
    ${whiskey.availability},
    ${whiskey.millilitersQuantity},
    ${whiskey.whiskeyAging},
    ${whiskey.special}`).catch(err => console.log(err))

    return result.recordset
}

async function insertCustomer(customer){
    await mssql.connect(config)

    const result = await mssql.query(`declare @location geometry;
    set @location = geometry::Point(${customer.location.lng}, ${customer.location.lat}, 0)
    exec insertCustomer '${customer.email}',
    '${customer.name}',
    '${customer.lastName1}',
    '${customer.lastName2}',
    @location,
    '${customer.username}',
    '${customer.password}'`).catch(err => console.log(err))

    return result.recordset

}

//=============================SELECT==============================


async function verifyAdmin(username, password){
    await mssql.connect(config)
    const result = await mssql.query(`exec validateAdministrator '${username}', '${password}'`)
    console.log(result.recordset)

    if(result.recordset[0].message === '00'){
        return true
    }
    else if(result.recordset[0].message ===  '01'){
        return false
    }
}

async function verifyCustomer(username, password){
    await mssql.connect(config)
    const result = await mssql.query(`exec validateCustomer '${username}', '${password}'`)
    if(result.recordset[0].message === '00'){
        return true
    }
    else if(result.recordset[0].message ===  '01'){
        return false
    }
}

async function  selectWhisky(){
    await mssql.connect(config)
    const result = await mssql.query(`exec selectWhiskey`)

    for(let i = 0; i < result.recordset.length; i++){
        const imageRecordset = await mssql.query(`exec selectImage ${result.recordset[i].idWhiskey}`)
        let imageSet = []

        for(let j = 0; j < imageRecordset.recordset.length; j++){
            imageSet.push(imageRecordset.recordset[j].image)
        }
        
        result.recordset[i].images = imageSet
    }
    

    return result.recordset
}

async function selectPresentation(){
    await mssql.connect(config)
    const result = await mssql.query(`exec selectPresentation`)

    return result.recordset
}

async function selectSupplier(){
    await mssql.connect(config)
    const result = await mssql.query(`exec selectSupplier`)

    return result.recordset
}

async function selectWhiskeyType(){
    await mssql.connect(config)
    const result = await mssql.query(`exec selectWhiskeyType`)

    return result.recordset
}

async function selectCurrency(){
    await mssql.connect(config)
    const result = await mssql.query(`exec selectCurrency`)

    return result.recordset
}

async function selectPaymentMethod(){
    await mssql.connect(config)
    const result = await mssql.query(`exec selectAllPaymentMethods`)
    console.log(result.recordset)
    return result.recordset
}

//=============================UPDATE==============================

async function updateWhiskey(whiskey){

    console.log(whiskey.price)

    await mssql.connect(config)
    const result = await mssql.query(`exec updateWhiskey ${whiskey.idSupplier},
    ${whiskey.idPresentation},
    ${whiskey.idCurrency},
    ${whiskey.idWhiskeyType},
    '${whiskey.brand}',
    ${parseFloat(whiskey.price)},
    ${whiskey.alcoholContent},
    '${whiskey.productionDate}',
    '${whiskey.dueDate}',
    ${whiskey.availability},
    ${whiskey.millilitersQuantity},
    ${whiskey.whiskeyAging},
    ${whiskey.special},
    ${whiskey.idWhiskey}`).catch(err => console.log(err))

    return result.recordset

}

//=============================DELETE==============================

async function deleteWhiskey(id){
    await mssql.connect(config)
    const result = await mssql.query(`exec deleteWhiskey ${id}`).catch(err => console.log(err))
    
    return result.recordset
}