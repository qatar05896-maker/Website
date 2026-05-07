# استخدام أحدث نسخة بايثون 3.12 لعام 2026
FROM python:3.12

# إعدادات النظام لضمان السرعة
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# تثبيت أحدث إصدارات الأدوات (FFmpeg 7.x و Nginx)
RUN apt-get update && apt-get install -y --no-install-recommends \
    nginx \
    ffmpeg \
    curl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# تثبيت أحدث إصدار من yt-dlp (المنقذ للبث من الروابط)
RUN curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp \
    && chmod a+rx /usr/local/bin/yt-dlp

# إعداد Nginx لخدمة الموقع على بورت 8080
RUN echo 'server { \
    listen 8080; \
    location / { \
        root /app/www; \
        index index.html; \
    } \
}' > /etc/nginx/sites-available/default

# إنشاء الفولدرات ونسخ الملفات
RUN mkdir -p /app/www
COPY index.html /app/www/

# فتح البورت المطلوب
EXPOSE 8080

# تشغيل السيرفر
CMD ["nginx", "-g", "daemon off;"]
