import path from 'path';

export default ({ env }) => {
  const client = env('DATABASE_CLIENT', 'sqlite');

  const connections = {
    mysql: {
      connection: {
        host: env('DATABASE_HOST', 'localhost'),
        port: env.int('DATABASE_PORT', 3306),
        database: env('DATABASE_NAME', 'strapi'),
        user: env('DATABASE_USERNAME', 'strapi'),
        password: env('DATABASE_PASSWORD', 'strapi'),
        ssl: env.bool('DATABASE_SSL', false) && {
          key: env('DATABASE_SSL_KEY', undefined),
          cert: env('DATABASE_SSL_CERT', undefined),
          ca: env('DATABASE_SSL_CA', undefined),
          capath: env('DATABASE_SSL_CAPATH', undefined),
          cipher: env('DATABASE_SSL_CIPHER', undefined),
          rejectUnauthorized: env.bool('DATABASE_SSL_REJECT_UNAUTHORIZED', true),
        },
      },
      pool: { min: env.int('DATABASE_POOL_MIN', 2), max: env.int('DATABASE_POOL_MAX', 10) },
    },
    postgres: {
  connection: {
    host: env('DATABASE_HOST'),
    port: env.int('DATABASE_PORT', 5432),
    database: env('DATABASE_NAME'),
    user: env('DATABASE_USERNAME'),
    password: env('DATABASE_PASSWORD'),

    // 🔴 REQUIRED FOR RDS
    keepAlive: true,
    connectionTimeoutMillis: 10000,

    // 🔴 SSL REQUIRED FOR RDS
    ssl: {
      rejectUnauthorized: false,
    },

    schema: env('DATABASE_SCHEMA', 'public'),
  },

  pool: {
    min: 0, // 🔴 IMPORTANT for RDS
    max: 5, // 🔴 DO NOT increase
    idleTimeoutMillis: 10000,
    acquireTimeoutMillis: 30000,
    reapIntervalMillis: 5000,

    // 🔴 Prevent reuse of dead RDS connections
    validate: (conn) => conn && !conn._ending,
  },
},
    sqlite: {
      connection: {
        filename: path.join(__dirname, '..', '..', env('DATABASE_FILENAME', '.tmp/data.db')),
      },
      useNullAsDefault: true,
    },
  };

  return {
    connection: {
      client,
      ...connections[client],
      acquireConnectionTimeout: env.int('DATABASE_CONNECTION_TIMEOUT', 60000),
    },
  };
};
