import pool  from "../config/db";

const Query = async(querytext:any) => {
    try {
        console.log(querytext);
        const rows = await pool.query(querytext)
        .then((res:any) => {return res.rows;}).catch((err:any) => {throw err; });
        return rows;
    } catch (error) {
        throw error;
    }
};

export default Query