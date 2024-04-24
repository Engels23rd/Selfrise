const db = require("./db");

async function read(chatId) {
    const rows = await db.query(`
        SELECT * FROM chat WHERE id = ?
    `, [chatId]);

    return rows[0];
}

module.exports = {
    read
};