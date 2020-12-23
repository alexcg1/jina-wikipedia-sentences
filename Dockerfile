FROM pytorch/pytorch:latest

WORKDIR "/root"

COPY . .

RUN python -m pip install --no-cache-dir --upgrade -r docker-requirements.txt

RUN python -c "from transformers import DistilBertModel, DistilBertTokenizer; x='distilbert-base-cased'; DistilBertModel.from_pretrained(x); DistilBertTokenizer.from_pretrained(x)"

ENTRYPOINT ["python", "app.py", "-t", "query_restful"]
