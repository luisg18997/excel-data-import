import dotenv from 'dotenv';
import { Pool }  from "pg";

dotenv.config()
const conectionString:any = {
    user: process.env.DB_USER,
    host: process.env.DB_HOST,
    database: process.env.DB_NAME,
    password: process.env.DB_PASSWORD,
    port: process.env.DB_PORT,
}

const pool = new Pool(conectionString)

export default pool;