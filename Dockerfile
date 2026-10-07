FROM python:3.12-slim

WORKDIR /app

COPY ./requirements.txt /app/

RUN pip install -r ./requirements.txt

COPY . /app/

EXPOSE 8008

CMD ["gunicorn", "-b", "0.0.0.0:8008", "app:app"]


