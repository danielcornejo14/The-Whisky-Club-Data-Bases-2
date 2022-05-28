const mysql = require('mysql')

module.exports = {
    testConnection
}

let mysql_config = mysql.createConnection(
    {
        host: process.env.MYSQL_HOST,
        user: process.env.MYSQL_USER,
        database: process.env.MYSQL_DATABASE,
        password: process.env.MYSQL_PASSWORD
    }
)

function testConnection(){
    mysql_config.connect((err)=>{
        if(err){
            console.log(err.stack)
        }
        else{
            console.log('Connected as thread id: ' + mysql_config.threadId)
        }
    })
}

