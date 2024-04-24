const db = require("./db");

async function read(emotionId) {
    const rows = await db.query(`
        SELECT * FROM emociones WHERE id = ?
    `, [emotionId]);

    return rows[0];
}

async function post() {

}

module.exports = {
    read,
    post
}