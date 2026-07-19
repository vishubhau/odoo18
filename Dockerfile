FROM python:3.10-slim-bullseye

# Install system dependencies needed for Odoo 18 and Postgres connection
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    wget \
    git \
    libxml2-dev \
    libxslt1-dev \
    libjpeg-dev \
    libpq-dev \
    libldap2-dev \
    libssl-dev \
    libsasl2-dev \
    libffi-dev \
    node-less \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Install wkhtmltopdf for printing PDF reports
RUN wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-2/wkhtmltox_0.12.6.1-2.bullseye_amd64.deb \
    && apt-get update \
    && apt-get install -y ./wkhtmltox_0.12.6.1-2.bullseye_amd64.deb \
    && rm wkhtmltox_0.12.6.1-2.bullseye_amd64.deb

# Copy code and install python dependencies
WORKDIR /app
COPY . /app
RUN pip install --no-cache-dir -r requirements.txt

# Create standard directories for runtime
RUN mkdir -p /var/lib/odoo /etc/odoo
COPY debian/odoo.conf /etc/odoo/odoo.conf

# Expose Odoo web port
EXPOSE 8069

# Execution Command
ENV ODOO_RC=/etc/odoo/odoo.conf
CMD ["python3", "odoo-bin"]
