from fastapi import FastAPI, Request

app = FastAPI(docs_url=None)

@app.get('/test/{filepath:path}')
def test(filepath, request: Request):
    return {'p': filepath, 'request': request.url}