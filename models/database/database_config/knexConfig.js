require('dotenv').config()

module.exports = {
    development: {
        // ⚠️ ALTERAÇÃO: Define o cliente como 'mysql2'
        client: 'mysql2',
        connection: {
            host: process.env.HOST_DB || 'localhost',
            user: process.env.USER_DB, // Substitua pelo seu usuário
            password: process.env.PASSWORD_DB, // Substitua pela sua senha
            database: process.env.NAME_DB,
            port: 3306, // Porta padrão do MySQL

            // Opcional: Define charset (recomendado para UTF8)
            charset: 'utf8mb4',
            timezone: 'Z',
            ssl: {
                rejectUnauthorized: false
            }
        },

        // Configurações de Migração
        migrations: {
            tableName: 'knex_migrations', // Nome da tabela de migrações
            directory: './db/migrations'
        },
        seeds: {
            directory: './db/seeds'
        }
    },

    // Você pode adicionar configurações para produção, testes, etc.
};