# Search Wikipedia Sentences with Jina

This is an example of using [Jina](http://www.jina.ai)'s neural search framework to search through a selection of individual Wikipedia sentences downloaded from Kaggle. It's based heavily on Jina's [South Park example](https://github.com/jina-ai/examples/tree/master/southpark-search).

## Setup

1. `pip install -r requirements.txt`
2. Set up [Kaggle](https://www.kaggle.com/docs/api#getting-started-installation-&-authentication)
3. `sh ./get_data.sh`

## Index

`python app.py -t index -n 500`

Where `500` is the number of sentences you want to index

## Query

### With REST API

`python app.py -t query_restful`

### With gRPC

`python app.py -t query`

## Build a Docker Image

This will create a Docker image with pre-indexed data and an open port for REST queries.

1. Run all the steps in setup and index first
2. Run `docker build -t jina-wikipedia-sentences .` in the root directory of this repo

Run it with `docker run -p 45678:45678 jina-wikipedia-sentences` and then search via the REST API.
