FROM pytorch/pytorch:latest
#FROM pytorch/pytorch:1.7.0-cuda11.0-cudnn8-devel

WORKDIR "/root"

RUN apt-get update && \
    apt-get install --no-install-recommends -y git \
                                               curl

#RUN python -m pip install --no-cache-dir --upgrade pip && \
    #pip install --no-cache-dir transformers==3.3.1 \
                               #jina[scipy]==0.8.11 \
                               #kaggle \
                               #click \


COPY . /root

RUN mkdir /root/.kaggle
RUN rm -rf workspace env

COPY kaggle.json /root/.kaggle

#RUN ls 

RUN python -m pip install --no-cache-dir --upgrade -r docker-requirements.txt

RUN python -c "from transformers import DistilBertModel, DistilBertTokenizer; x='distilbert-base-cased'; DistilBertModel.from_pretrained(x); DistilBertTokenizer.from_pretrained(x)"

RUN pip freeze

RUN python app.py -t index && \
    rm -rf data

#RUN bash get_data.sh && \
    #python app.py -t index && \
    #rm -rf data

#ENTRYPOINT ["python", "app.py", "-t", "query_restful"]

RUN bash
