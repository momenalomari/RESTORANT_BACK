import dotenv from "dotenv";
import connectToDatabase from "./src/config/db.js";

dotenv.config();

connectToDatabase();
