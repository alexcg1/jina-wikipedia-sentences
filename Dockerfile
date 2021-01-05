FROM pytorch/pytorch:latest

WORKDIR "/root"

COPY . .

ENV MAX_DOCS=3000
ENV JINA_DATA_PATH='data/input.txt'

RUN python -m pip install --no-cache-dir --upgrade -r requirements.txt

RUN python -c "from transformers import DistilBertModel, DistilBertTokenizer; x='distilbert-base-cased'; DistilBertModel.from_pretrained(x); DistilBertTokenizer.from_pretrained(x)"

ENTRYPOINT ["python", "app.py", "search"]
