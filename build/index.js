"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const dotenv_1 = __importDefault(require("dotenv"));
dotenv_1.default.config();
const cors_1 = __importDefault(require("cors"));
const http_1 = __importDefault(require("http"));
const routes_1 = __importDefault(require("./routes/routes"));
const app = (0, express_1.default)();
const server = http_1.default.createServer(app);
app.use((0, cors_1.default)());
app.use(express_1.default.json());
app.use(express_1.default.urlencoded({ extended: true }));
app.set("PORT", 3000);
app.set("BASE_URL", "http://localhost:3000");
app.use("/api/v1", routes_1.default);
try {
    server.listen(app.get("PORT"), '0.0.0.0', () => {
        console.log(`Server running on port ${app.get("PORT")}`);
    });
}
catch (error) {
    console.log(error);
}
exports.default = server;
