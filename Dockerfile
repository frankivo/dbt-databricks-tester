FROM python:3.11-slim

RUN apt update && apt install -y nano git && rm -rf /var/lib/apt/lists/*

RUN adduser testuser
USER testuser
WORKDIR /home/testuser

ENV PATH="$PATH:/home/testuser/.local/bin"

RUN git clone https://github.com/databricks/dbt-databricks.git
WORKDIR /home/testuser/dbt-databricks

RUN python -m pip install --upgrade pip && pip install "tox>=3.2.0"

RUN tox -e unit

ADD --chown=testuser test.env /home/testuser/dbt-databricks
# RUN sed tox.ini -e 's#/adapter/#/adapter/constraints/#g' -i
