FROM python:3.10-slim

# System deps
RUN apt-get update && apt-get install -y \
    git \
    curl \
    build-essential \
    libglib2.0-0 \
    libgomp1 \
    libqt5widgets5 \
    libqt5gui5 \
    libqt5core5a \
    libqt5network5 \
    libqt5xml5 \
    libqt5concurrent5 \
    zlib1g \
    liblz4-1 \
    libboost-all-dev \
    && apt-get clean

# Install Poetry
RUN curl -sSL https://install.python-poetry.org | python3 - && \
    ln -s /root/.local/bin/poetry /usr/local/bin/poetry

ENV PATH="${PATH}:/root/.local/bin"
ENV POETRY_VIRTUALENVS_CREATE=false

# Clone your fork with patched pyproject.toml
RUN git clone https://github.com/rodvrees/quantms-utils.git /opt/quantms-utils
WORKDIR /opt/quantms-utils

# Just to make sure, show the pyproject.toml section
RUN grep -A6 '\[tool.poetry.dependencies\]' pyproject.toml

# Clean stale state
RUN rm -f poetry.lock && rm -rf .venv

RUN python --version
# Respect Python constraint and resolve
RUN poetry lock && poetry install --only main

# Verify CLI
RUN which quantmsutilsc && quantmsutilsc --help