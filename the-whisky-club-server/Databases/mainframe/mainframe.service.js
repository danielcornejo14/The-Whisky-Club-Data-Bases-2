const mssql = require('mssql')

module.exports = {
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
    selectPaymentMethod,
    selectSubscription,
    updateSubscription,
    deleteSubscription,
    insertSubscription,
    insertWhiskeyType,
    updateWhiskeyType,
    deleteWhiskeyType,
    insertCurrency,
    updateCurrency,
    deleteCurrency,
    insertPresentation,
    updatePresentation,
    deletePresentation,
    queryCustomerReport,
    queryEmployeeReport,
    querySalesReport,
    selectWhiskeyReviews,
    insertReview,
    selectSales,
    selectWhiskyAdmin
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


//=============================INSERT==============================


async function insertWhiskey(whiskey){

    console.log(whiskey)

    await mssql.connect(config)
    const result = await mssql.query(`exec insertWhiskey 
    ${whiskey.idSupplier},
    ${whiskey.idPresentation},
    ${whiskey.idWhiskeyType},
    '${whiskey.brand}',
    ${parseFloat(whiskey.price)},
    ${whiskey.alcoholContent},
    '${whiskey.productionDate}',
    '${whiskey.dueDate}',
    ${whiskey.millilitersQuantity},
    ${whiskey.whiskeyAging},
    ${whiskey.special},
    ${whiskey.addStock}`).catch(err => console.log(err))
}

async function insertCustomer(customer){

    await mssql.connect(config)

    const result = await mssql.query(`declare @location geometry;
    set @location = geometry::Point(${customer.location.lng}, ${customer.location.lat}, 0);
    exec insertCustomer 
    '${customer.email}',
    '${customer.name}',
    '${customer.lastName1}',
    '${customer.lastName2}',
    @location,
    '${customer.username}',
    '${customer.password}',
    ${customer.subscription}`).catch(err => console.log(err))



}

async function insertSubscription(sub){
    await mssql.connect(config)

    const result = await mssql.query(`exec insertSubscription 
    '${sub.name}',
    ${sub.shoppingDiscount}, 
    ${sub.shippingDiscount}`).catch((err) => console.log(err))



}

async function insertWhiskeyType(type){
    await mssql.connect(config)
    console.log(type)
    const result = await mssql.query(`exec insertWhiskeyType 
    '${type.name}'`).catch(err => console.log(err))


}

async function insertPresentation(presentation){
    await mssql.connect(config)
    const result = await mssql.query(`exec insertPresentation 
    '${presentation.description}'`).catch((err)=>console.log(err))

}

async function insertCurrency(currency){
    await mssql.connect(config)
    const result = await mssql.query(`exec insertCurrency 
    '${currency.name}'`).catch((err)=>console.log(err))

}

async function insertReview(review){
    await mssql.connect(config)
    const result = await mssql.query(`exec insertWhiskeyReview 
    '${review.username}', 
    ${review.idWhiskey}, 
    '${review.comment}', 
    ${review.evaluation}`).catch(err => console.log(err))

}

//=============================SELECT==============================


async function verifyAdmin(username, password){
    await mssql.connect(config)
    const result = await mssql.query(`exec validateAdministrator 
    '${username}', 
    '${password}'`).catch(err => console.log(err))




    if(result.recordset[0].message === '00'){
        return true
    }
    else if(result.recordset[0].message ===  '01'){
        return false
    }
}

async function verifyCustomer(username, password){
    await mssql.connect(config)
    const result = await mssql.query(`exec validateCustomer 
    '${username}', 
    '${password}'`).catch(err => console.log(err))

    if(result.recordset[0].message === '00'){

        return true
    }
    else if(result.recordset[0].message ===  '01'){

        return false
    }
}

async function selectWhisky(data){

    const conn = await mssql.connect(config)

    const result = await mssql.query(`exec selectWhiskey '${data}'`).catch(err => console.log(err))


    for(let i = 0; i < result.recordset.length; i++){
        const imageRecordset = await mssql.query(`exec selectImage 
        ${result.recordset[i].idWhiskey}`).catch(err => console.log(err))

        let imageSet = []

        for(let j = 0; j < imageRecordset.recordset.length; j++){
            imageSet.push(imageRecordset.recordset[j].image)
        }
        
        result.recordset[i].images = imageSet
    }
    

    try{
        return result.recordset
    }catch(err){
        console.log(err)
    }
    
}

async function selectWhiskyAdmin(){

    const conn = await mssql.connect(config)

    const result = await mssql.query(`exec selectWhiskeyAdmin`).catch(err => console.log(err))


    for(let i = 0; i < result.recordset.length; i++){
        const imageRecordset = await mssql.query(`exec selectImage 
        ${result.recordset[i].idWhiskey}`).catch(err => console.log(err))

        let imageSet = []

        for(let j = 0; j < imageRecordset.recordset.length; j++){
            imageSet.push(imageRecordset.recordset[j].image)
        }
        
        result.recordset[i].images = imageSet
    }
    

    try{
        return result.recordset
    }catch(err){
        console.log(err)
    }
    
}

async function selectPresentation(){
    await mssql.connect(config)
    const result = await mssql.query(`exec selectPresentation`).catch(err => console.log(err))


    try{
        return result.recordset
    }catch(err){
        console.log(err)
    }
}

async function selectSupplier(){
    await mssql.connect(config)
    const result = await mssql.query(`exec selectSupplier`).catch(err => console.log(err))


    try{
        return result.recordset
    }catch(err){
        console.log(err)
    }
}

async function selectWhiskeyType(){
    await mssql.connect(config)
    const result = await mssql.query(`exec selectWhiskeyType`).catch(err => console.log(err))

    try{
        return result.recordset
    }catch(err){
        console.log(err)
    }
}

async function selectCurrency(){
    await mssql.connect(config)
    const result = await mssql.query(`exec selectCurrency`).catch(err => console.log(err))


    try{
        return result.recordset
    }catch(err){
        console.log(err)
    }
}

async function selectPaymentMethod(){
    await mssql.connect(config)
    const result = await mssql.query(`exec selectPaymentMethod`).catch(err => console.log(err))

    try{
        return result.recordset
    }catch(err){
        console.log(err)
    }
}

async function selectSubscription(){
    await mssql.connect(config)

    const result = await mssql.query(`exec selectSubscription`).catch(err => console.log(err))


    try{
        return result.recordset
    }catch(err){
        console.log(err)
    }
}


async function selectWhiskeyReviews(id){
    await mssql.connect(config)
    const result = await mssql.query(`exec readWhiskeyReview ${id}`).catch(err => console.log(err))

    try{
        return result.recordset
    }catch(err){
        console.log(err)
    }
}

async function selectSales(username){
    await mssql.connect(config)
    const result = await mssql.query(`exec readSaleByUserName '${username}'`).catch(err => console.log(err))
    try{
        return result.recordset
    }catch(err){
        console.log(err)
    }
 
}

//=============================UPDATE==============================

async function updateWhiskey(whiskey){

    console.log(whiskey)

    await mssql.connect(config)
    const result = await mssql.query(`exec updateWhiskey ${whiskey.idSupplier},
    ${whiskey.idPresentation},
    ${whiskey.idWhiskeyType},
    '${whiskey.brand}',
    ${parseFloat(whiskey.price)},
    ${whiskey.alcoholContent},
    '${whiskey.productionDate}',
    '${whiskey.dueDate}',
    ${whiskey.millilitersQuantity},
    ${whiskey.whiskeyAging},
    ${whiskey.special},
    ${whiskey.idWhiskey},
    ${whiskey.addStock}`).catch(err => console.log(err))

}

async function updateSubscription(sub){
    await mssql.connect(config)

    const result = await mssql.query(`exec updateSubscription ${sub.idSubscription},
        '${sub.name}',
        ${sub.shoppingDiscount},
        ${sub.shippingDiscount}`).catch((err) => console.log(err))



}

async function updateWhiskeyType(type){
    await mssql.connect(config)
    console.log(type)
    const result = await mssql.query(`exec updateWhiskeyType ${type.idWhiskeyType},
        '${type.name}'`).catch((err)=> console.log(err))


}

async function updatePresentation(presentation){
    await mssql.connect(config)

    const result = await mssql.query(`exec updatePresentation 
    ${presentation.idPresentation},
    '${presentation.description}'`).catch((err)=>console.log(err))


}

async function updateCurrency(currency){
    await mssql.connect(config)

    const result = await mssql.query(`exec updateCurrency 
    ${currency.idCurrency},
    '${currency.name}'`).catch((err)=>console.log(err))


}

//=============================DELETE==============================

async function deleteWhiskey(id){
    await mssql.connect(config)
    const result = await mssql.query(`exec deleteWhiskey ${id}`).catch(err => console.log(err))

}

async function deleteSubscription(id){
    await mssql.connect(config)
    console.log(typeof(id))
    const result = await mssql.query(`exec deleteSubscription ${id}`).catch(err => console.log(err))

}

async function deleteWhiskeyType(id){
    await mssql.connect(config)
    console.log(id)
    const result = await mssql.query(`exec deleteWhiskeyType ${id}`).catch(err=>console.log(err))

}

async function deletePresentation(id){
    await mssql.connect(config)
    const result = await mssql.query(`exec deletePresentation ${id}`).catch((err)=>console.log(err))
}

async function deleteCurrency(id){
    await mssql.connect(config)
    const result = await mssql.query(`exec deleteCurrency ${id}`).catch((err)=>console.log(err))

}


//=============================REPORTS==============================

async function queryCustomerReport(filter){
    await mssql.connect(config)

    if(filter.beforeDate !== null){
        filter.beforeDate = "'"+filter.beforeDate+"'"
    }

    if(filter.afterDate !== null){
        filter.afterDate = "'"+filter.afterDate+"'"
    }
    console.log(filter)

    const result = await mssql.query(`exec customersReport 
    ${filter.idSubscription},
    ${filter.beforeDate},
    ${filter.afterDate},
    ${filter.idCountry}`).catch(err => console.log(err))
    return result.recordset
}

async function queryEmployeeReport(filter){
    await mssql.connect(config)

    if(filter.departmentName !== null){
        filter.departmentName = "'"+filter.departmentName+"'"
    }

    console.log(filter)

    const result = await mssql.query(`exec employeesReport 
    ${filter.departmentName},
    ${filter.minimumAverageScore},
    ${filter.maximumAverageScore},
    ${filter.minimumLocalSalary},
    ${filter.maximumLocalSalary},
    ${filter.minimumDollarSalary},
    ${filter.maximumDollarSalary}`).catch(err => console.log(err))
    return result.recordset
}

async function querySalesReport(filter){
    await mssql.connect(config)
    console.log(filter)

    if(filter.beforeDate !== null){
        filter.beforeDate = "'"+filter.beforeDate+"'"
    }

    if(filter.afterDate !== null){
        filter.afterDate = "'"+filter.afterDate+"'"
    }
    
    const result = await mssql.query(`exec productCatalogSalesReport 
    ${filter.idWhiskeyType},
    ${filter.countryId},
    ${filter.beforeDate},
    ${filter.afterDate}`).catch(err => console.log(err))

    console.log(result.recordset)
    return result.recordset
}
