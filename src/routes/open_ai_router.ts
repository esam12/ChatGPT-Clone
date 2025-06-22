import { Router, Request, Response } from "express";

const openAiRouter = Router();

openAiRouter.post("/", (req: Request, res: Response) => {
    res.json({ 'data': "From OpenAI " });
});

export default openAiRouter;