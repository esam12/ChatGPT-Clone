import { Request, Response } from "express";
import { GoogleGenerativeAI } from "@google/generative-ai";

const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY!);

export const generateGeminiAiResponsesController = async (req: Request, res: Response) => {
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

    const latestUserMessage = messages[messages.length - 1]?.text;

    const chat = model.startChat({ history });

    // Streaming headers
    res.setHeader("Content-Type", "text/event-stream; charset=utf-8");
    res.setHeader("Transfer-Encoding", "chunked");

    const result = await chat.sendMessageStream(latestUserMessage);

    for await (const chunk of result.stream) {
        const text = chunk.text();
        if (text) {
            res.write(`data: ${text}\n\n`);
        }
    }

    res.end();

  } catch (error: any) {
    console.error("Gemini streaming error:", error);
    if (!res.headersSent) {
      res.status(500).json({ error: error.message || "Internal error" });
    } else {
      res.end();
    }
  }
};
