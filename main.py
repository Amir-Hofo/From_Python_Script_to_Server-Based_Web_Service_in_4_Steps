# fastapi

from your_code_file_name import your_function

from fastapi import FastAPI

app= FastAPI()

@app.get("/")
def root():
    return {"status": "ok"}


from pydantic import BaseModel

class DataInput(BaseModel):
    input_var_1: int
    input_var_2: str
    input_var_3: dict

@app.post("/endpoint_name")
def endpoint_name(data: DataInput):
    response= your_function(data.input_var_1, data.input_var_2, data.input_var_3)
    return {"result": response}