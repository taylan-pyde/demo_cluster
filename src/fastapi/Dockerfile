FROM python:3.11-slim
WORKDIR /app
COPY . .
RUN pip install -r requirements.txt
EXPOSE 8000
COPY start.sh .
RUN chmod +x start.sh
CMD ["./start.sh"]

