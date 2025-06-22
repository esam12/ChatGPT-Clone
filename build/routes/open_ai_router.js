"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const openAiRouter = (0, express_1.Router)();
openAiRouter.post("/", (req, res) => {
    res.json({ 'data': "From OpenAI " });
});
exports.default = openAiRouter;
