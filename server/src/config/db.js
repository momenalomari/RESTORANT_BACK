import pkg from "pg";
import dotenv from "dotenv";

dotenv.config();

const { Pool } = pkg;

const pool = new Pool({
    CONNECTIONSTRING: process.env.CONNECTIONSTRING,
});

const connectToDatabase = async () => {
    try {
        await pool.connect();
        console.log("Connected to PostgreSQL successfully ✅");
    } catch (error) {
        console.error("Error connecting to the database:", error);
    }
};

export default connectToDatabase;
export { pool };