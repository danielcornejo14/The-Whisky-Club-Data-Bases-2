const mssql = require('mssql')

module.exports = {
    verifyAdmin,
    selectWhisky,
    selectSupplier,
    selectPresentation,
    selectWhiskeyType,
    selectCurrency,
    updateWhiskey
}

const mainframe = {
    user: process.env.MSSQL_USER,
    password: process.env.MSSQL_PASSWORD,
    database: 'Mainframe_db',
    server: process.env.MSSQL_HOST,
    options: {
        encrypt: true, // for azure
        trustServerCertificate: true // change to true for local dev / self-signed certs
    }
}

async function verifyAdmin(username, password){
    await mssql.connect(mainframe)
    const result = await mssql.query(`exec validateAdministrator '${username}', '${password}'`)

    if(result.recordset[0].message === '00'){
        return false
    }
    else if(result.recordset[0].message ===  '01'){
        return true
    }
}

async function  selectWhisky(){
    await  mssql.connect(mainframe)
    const result = await mssql.query(`exec selectWhiskey`)

    return result.recordset
}

async function selectPresentation(){
    await mssql.connect(mainframe)
    const result = await mssql.query(`exec selectPresentation`)

    return result.recordset
}

async function selectSupplier(){
    await mssql.connect(mainframe)
    const result = await mssql.query(`exec selectSupplier`)

    return result.recordset
}

async function selectWhiskeyType(){
    await mssql.connect(mainframe)
    const result = await mssql.query(`exec selectWhiskeyType`)

    return result.recordset
}

async function selectCurrency(){
    await mssql.connect(mainframe)
    const result = await mssql.query(`exec selectCurrency`)

    return result.recordset
}

//=============================UPDATE==============================

async function updateWhiskey(whiskey){

    console.log(whiskey.price)

    await mssql.connect(mainframe)
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
    ${whiskey.idWhiskey}`)


}