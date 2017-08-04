FROM python:2-slim

ENV RASA_NLU_HOME=/app

RUN apt-get update -qq \
    && apt-get install -y --no-install-recommends build-essential git-core \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Setting up rasa NLU
RUN pip install rasa_nlu

# MITIE
RUN pip install git+https://github.com/mit-nlp/MITIE.git

# spaCy + sklearn
RUN pip install -U spacy
RUN python -m spacy download en
RUN pip install -U scikit-learn scipy sklearn-crfsuite

WORKDIR ${RASA_NLU_HOME}

COPY . ${RASA_NLU_HOME}

VOLUME ["/app/models", "/app/logs", "/app/data"]

EXPOSE 5000

ENTRYPOINT ["./entrypoint.sh"]

CMD ["start", "-c", "config.json"]
