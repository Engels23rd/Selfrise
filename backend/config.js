const env = process.env;

const config = {
    db: {
        host: env.host,
        user: env.user,
        password: env.password,
        database: env.database,
        port: env.port
    },
    listPerPage: 10
}

module.exports = config;