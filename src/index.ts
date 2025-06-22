import express, {Express} from 'express';
import dotenv from 'dotenv';
dotenv.config();

import cors from 'cors';
import http from 'http';
import router from './routes/routes';

const app: Express = express();
const server = http.createServer(app);

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.set("PORT", 3000);
app.set("BASE_URL", "http://localhost:3000");


app.use("/api/v1",router);

try {
    server.listen(app.get("PORT"), () => {
        console.log(`Server running on port ${app.get("PORT")}`);
    });
} catch (error) {
    console.log(error);
}

export default server;