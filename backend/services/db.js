const mysql = require("mysql2/promise");
const config = require("../config");

async function query(sql, params) {
    const conn = await mysql.createConnection(config.db);
    const [results, ] = await conn.execute(sql, params);
    return results;
}

module.exports = { query };