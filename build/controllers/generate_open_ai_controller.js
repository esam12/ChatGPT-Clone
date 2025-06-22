"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __asyncValues = (this && this.__asyncValues) || function (o) {
    if (!Symbol.asyncIterator) throw new TypeError("Symbol.asyncIterator is not defined.");
    var m = o[Symbol.asyncIterator], i;
    return m ? m.call(o) : (o = typeof __values === "function" ? __values(o) : o[Symbol.iterator](), i = {}, verb("next"), verb("throw"), verb("return"), i[Symbol.asyncIterator] = function () { return this; }, i);
    function verb(n) { i[n] = o[n] && function (v) { return new Promise(function (resolve, reject) { v = o[n](v), settle(resolve, reject, v.done, v.value); }); }; }
    function settle(resolve, reject, d, v) { Promise.resolve(v).then(function(v) { resolve({ value: v, done: d }); }, reject); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.generateGeminiAiResponsesController = void 0;
const generative_ai_1 = require("@google/generative-ai");
const genAI = new generative_ai_1.GoogleGenerativeAI(process.env.GEMINI_API_KEY);
const generateGeminiAiResponsesController = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    var _a, e_1, _b, _c;
    var _d;
    try {
        const { messages } = req.body;
        if (!messages || !Array.isArray(messages)) {
            return res.status(400).json({ error: "Messages must be an array" });
        }
        const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash" });
        const history = messages.slice(0, -1).map(msg => ({
            role: msg.role,
            parts: [{ text: msg.text }]
        }));
        const latestUserMessage = (_d = messages[messages.length - 1]) === null || _d === void 0 ? void 0 : _d.text;
        const chat = model.startChat({ history });
        // Streaming headers
        res.setHeader("Content-Type", "text/event-stream; charset=utf-8");
        res.setHeader("Transfer-Encoding", "chunked");
        const result = yield chat.sendMessageStream(latestUserMessage);
        try {
            for (var _e = true, _f = __asyncValues(result.stream), _g; _g = yield _f.next(), _a = _g.done, !_a; _e = true) {
                _c = _g.value;
                _e = false;
                const chunk = _c;
                const text = chunk.text();
                if (text) {
                    res.write(`data: ${text}\n\n`);
                }
            }
        }
        catch (e_1_1) { e_1 = { error: e_1_1 }; }
        finally {
            try {
                if (!_e && !_a && (_b = _f.return)) yield _b.call(_f);
            }
            finally { if (e_1) throw e_1.error; }
        }
        res.end();
    }
    catch (error) {
        console.error("Gemini streaming error:", error);
        if (!res.headersSent) {
            res.status(500).json({ error: error.message || "Internal error" });
        }
        else {
            res.end();
        }
    }
});
exports.generateGeminiAiResponsesController = generateGeminiAiResponsesController;
