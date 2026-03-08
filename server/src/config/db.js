import pkg from 'pg';
const { Pool } = pkg;
import dotenv from 'dotenv';

dotenv.config(); // تأكد أن ملف .env في المجلد الرئيسي للمشروع

const pool = new Pool({
  connectionString: process.env.CONNECTION_STRING,
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