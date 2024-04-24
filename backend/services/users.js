const db = require("./db");

async function read(userId) {
    const result = await db.query(`
        SELECT *
        FROM usuario
        WHERE id = ?
    `, [userId]);

    const user = result[0];

    return { user };
}

async function create({ nombre, apellido, correo, clave, fecha_nacimiento, localidad, esPremium }) {
    const result = await db.query(`
        INSERT INTO usuario(nombre, apellido, correo, clave, fecha_nacimiento, localidad, esPremium)
        VALUES(?, ?, ?, ?, ?, ?, ?);
    `, [nombre, apellido, correo, clave, fecha_nacimiento, localidad, esPremium]);

    const lastId = result.insertId;
    const user = await db.query(`SELECT * FROM usuario WHERE id = ?`, [lastId]);
    return { user: user[0] };
}

async function update({ clave, nombre, apellido, direccion, telefono, cedula, id, correo }) {
    const result = await db.query(`
        UPDATE usuarios
        SET
            clave = ?,
            nombre = ?,
            apellido = ?,
            direccion = ?,
            telefono = ?,
            cedula = ?,
            correo = ?
        WHERE id = ? 
    `, [clave, nombre, apellido, direccion, telefono, cedula, correo, id]);

    const msg = result.affectedRows !== 0 ? "Usuario actualizado con éxito."
        : "Error al actualizar el usuario."

    return { msg };
}
async function authenticate({ email, password }) {
    const res = await db.query(`SELECT autenticar_usuario(?, ?) AS authenticated`, [email, password]);

    console.log("res: ", res);
    const authenticated = res[0];

    return authenticated;
}

module.exports = {
    read,
    update,
    authenticate,
    create
};