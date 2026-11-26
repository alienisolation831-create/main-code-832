FROM python:3.12-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt && useradd --create-home --uid 10001 monitor && mkdir /data && chown monitor:monitor /data
COPY app.py .
USER monitor
ENV BRAND_MONITOR_DATA_DIR=/data PYTHONUNBUFFERED=1
EXPOSE 5000
VOLUME ["/data"]
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "1", "--worker-class", "gthread", "--threads", "2", "--timeout", "600", "app:app"]
