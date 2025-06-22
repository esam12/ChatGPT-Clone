import { Router, Request, Response } from "express";
import { generateGeminiAiResponsesController } from "../controllers/generate_open_ai_controller";

const openAiRouter = Router();

openAiRouter.post("/", generateGeminiAiResponsesController);

export default openAiRouter;