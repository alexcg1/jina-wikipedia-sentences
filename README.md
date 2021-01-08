# Search Wikipedia Sentences with Jina

This is an example of using [Jina](http://www.jina.ai)'s neural search framework to search through a [selection of individual Wikipedia sentences](https://www.kaggle.com/mikeortman/wikipedia-sentences) downloaded from Kaggle. It's based on code generated by `jina hub new --type app`.

## Setup

1. `pip install -r requirements.txt`
2. Set up [Kaggle](https://www.kaggle.com/docs/api#getting-started-installation-&-authentication)
3. `sh ./get_data.sh`
4. `export JINA_DATA_PATH='data/input.txt'`

## Index

`python app.py index`

You can set the maximum documents to index with `export MAX_DOCS=500`

## Search

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
2. If you want to [push to Jina Hub](#push-to-jina-hub) be sure to edit the `LABEL`s in `Dockerfile` to avoid clashing with other images
3. Run `docker build -t jinahub/wikipedia-sentences .` in the root directory of this repo
4. Run it with `docker run -p 65481:65481 jinahub/wikipedia-sentences` 
5. Search using instructions from [Search](#search) above

## Push to Jina Hub

1. Ensure hub is installed with `pip install jina[hub]`
2. Run `jina hub login` and paste the code into your browser to authenticate
3. Run `jina hub push jinahub/wikipedia-sentences`
