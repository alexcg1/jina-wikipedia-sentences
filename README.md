# Search Wikipedia Sentences with Jina

This is an example of using [Jina](http://www.jina.ai)'s neural search framework to search through a [selection of individual Wikipedia sentences](https://www.kaggle.com/mikeortman/wikipedia-sentences) downloaded from Kaggle. It's based heavily on Jina's [South Park example](https://github.com/jina-ai/examples/tree/master/southpark-search).

## Setup

1. `pip install -r requirements.txt`
2. Set up [Kaggle](https://www.kaggle.com/docs/api#getting-started-installation-&-authentication)
3. `sh ./get_data.sh`

## Index

`python app.py index`

You can set the maximum documents to index with `export MAX_DOCS=500`

## Query

```sh
python app.py search
```

Then:

```sh
curl --request POST -d '{"top_k": 10, "mode": "search",  "data": ["text:hello world"]}' -H 'Content-Type: application/json' 'http://0.0.0.0:65481/api/search'
````

Or use [Jinabox](https://jina.ai/jinabox.js/) with endpoint `http://127.0.0.1:65481/api/search`

## Build a Docker Image

This will create a Docker image with pre-indexed data and an open port for REST queries.

1. Run all the steps in setup and index first. Don't run anything in the query step!
2. Run `docker build -t jina-wikipedia-sentences .` in the root directory of this repo
3. Run it with `docker run -p 65481:65481 jina-wikipedia-sentences` 
4. Search using instructions from [REST API](#with-rest-api) above
