import openai
from flask import current_app as app


class OpenAIService:
    def __init__(self, api_key):
        self.client = openai.OpenAI(api_key=api_key)

    def get_gift_ideas(self, interests):
        prompt = f"Дай список максимально подходящих подарков по этим интересам {interests}. Ответ должен содержать список подарков по одному на каждой строке."
        try:
            chat_completion = self.client.chat.completions.create(
                messages=[{"role": "user", "content": prompt}],
                model="gpt-3.5-turbo",
            )
            return chat_completion.choices[0].message.content
        except openai.error.OpenAIError as e:
            raise Exception(f"Error from OpenAI: {str(e)}")


# Initialize OpenAIService with the API key from configuration
openai_service = OpenAIService(api_key=app.config['OPENAI_API_KEY'])
