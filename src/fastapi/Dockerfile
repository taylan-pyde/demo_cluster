FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY bigfiles/ /app/bigfiles/

COPY . .
EXPOSE 8000
COPY start.sh .
RUN chmod +x start.sh

CMD ["./start.sh"]
