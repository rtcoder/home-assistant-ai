import logging
from typing import Optional

logger = logging.getLogger(__name__)

class LLMManager:
    """
    Zarządza wyborem i interakcją z lokalnymi modelami LLM (Ollama).
    """
    
    MODELS = {
        "fast": "bielik",
        "balanced": "qwen2.5:32b",
        "powerful": "llama3.1:70b-instruct-q3_K_M"
    }

    def __init__(self, default_model: str = "balanced"):
        self.current_model = self.MODELS.get(default_model, self.MODELS["balanced"])
        logger.info(f"LLMManager zainicjalizowany z modelem: {self.current_model}")

    def switch_model(self, model_key: str):
        """Przełącza model na podstawie klucza (fast, balanced, powerful)."""
        if model_key in self.MODELS:
            self.current_model = self.MODELS[model_key]
            logger.info(f"Przełączono model na: {self.current_model}")
        else:
            logger.warning(f"Nieznany klucz modelu: {model_key}. Pozostaję przy {self.current_model}")

    def generate_response(self, prompt: str, context: Optional[str] = None):
        """
        Wysyła zapytanie do aktualnie wybranego modelu Ollama.
        (Miejsce na implementację komunikacji z Ollama API)
        """
        logger.info(f"Generowanie odpowiedzi za pomocą {self.current_model} dla promptu: {prompt[:50]}...")
        # TODO: Implementacja aiohttp/requests do http://localhost:11434/api/generate
        return f"[Odpowiedź z {self.current_model}]"
