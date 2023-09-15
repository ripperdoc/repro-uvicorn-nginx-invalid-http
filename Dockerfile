FROM python:3.10-bullseye

WORKDIR /code

RUN pip install fastapi uvicorn[standard]==0.23.2

COPY ./test.py .

EXPOSE 7000

CMD ["uvicorn", "test:app", "--host", "0.0.0.0", "--port", "7000"]