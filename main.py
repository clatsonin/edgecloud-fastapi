from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import httpx

app = FastAPI()

# Define the URL and headers
url = "https://llama38bu7wgnb5wyg-6622d7b512eb2090.tec-s1.onthetaedgecloud.com/v1/chat/completions"
headers = {
    "Content-Type": "application/json"
}

# Define the request model
class UserRequest(BaseModel):
    message: str

@app.post("/chat")
async def chat_with_model(user_request: UserRequest):
    # Define the data payload
    agent = "Pharmacists"
    command = """Generate a response that is easy to understand for someone without a medical background. 
    Focus on providing details about the medicine's information, primary purpose, precautions or side effects, history, dosage, and common medical formula. 
    For the common formula, mention only one main chemical formula. 
    Ensure each answer is less than 50 words and easy to understand for someone without a medical background."""
    json_format = """{[
              "response": 
                {
                  "medicine_name": "string",
                  "medicine_information": "string",
                  "history": "string",
                  "primary_purpose": "string",
                  "precautions": "string",
                  "chemical_formula": "string",
                  "dosage": "string"
                }]
            }"""

    role_content = f"You are {agent}. Follow these commands {command} for this medicine the  .Output in dictionary with this format {json_format} remove unwanted spaces without triple quotes."
    data = {
        "model": "meta-llama/Meta-Llama-3-8B-Instruct",
        "messages": [
            {"role": "system", "content": role_content},
            {"role": "user", "content": "The mdeicine name is" + user_request.message}
        ],
        "max_tokens": 100
    }

    # Make the asynchronous POST request
    async with httpx.AsyncClient() as client:
        response = await client.post(url, headers=headers, json=data)

    # Check the response status and return the result
    if response.status_code == 200:
        response_json = response.json()
        message_content = response_json['choices'][0]['message']['content']
        return {"response": message_content}
    else:
        raise HTTPException(status_code=response.status_code, detail=response.text)
