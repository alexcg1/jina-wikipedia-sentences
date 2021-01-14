# Search Wikipedia Sentences with Jina

This is an example of using [Jina](http://www.jina.ai)'s neural search framework to search through a [selection of individual Wikipedia sentences](https://www.kaggle.com/mikeortman/wikipedia-sentences) downloaded from Kaggle. It's based on code generated by `jina hub new --type app`.

## Run in Docker

To test this example you can run a Docker image with 30,000 pre-indexed sentences:

```sh
docker run -p 65481:65481 jinahub/app.app.jina-wikipedia-sentences-30k:0.2.3-0.9.5
```

You can then query by running:

```sh
curl --request POST -d '{"top_k": 10, "mode": "search",  "data": ["text:hello world"]}' -H 'Content-Type: application/json' 'http://0.0.0.0:65481/api/search'`
```

## Setup

1. `pip install -r requirements.txt`
2. Set up [Kaggle](https://www.kaggle.com/docs/api#getting-started-installation-&-authentication)
3. `sh ./get_data.sh`
4. `export JINA_DATA_PATH='data/input.txt'`

## Index

```sh
python app.py index
```

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
3. Run `docker build -t <your_image_name> .` in the root directory of this repo
5. Run it with `docker run -p 65481:65481 <your_image_name>`
6. Search using instructions from [Search](#search) above

### Image name format

Please use the following name format for your Docker image, otherwise it will be rejected if you want to push it to Jina Hub. Please also see my [notes](#notes) section before which explains my versioning weirdness

```
jinahub/type.kind.jina-image-name:image-jina_version
```

For example:

```
jinahub/app.app.jina-wikipedia-sentences-30k:0.2.3-0.9.5
```

## Push to [Jina Hub](https://github.com/jina-ai/jina-hub)

1. Ensure hub is installed with `pip install jina[hub]`
2. Run `jina hub login` and paste the code into your browser to authenticate
3. Run `jina hub push <your_image_name>`

## Notes

At the time of writing, the version of Jina in `requirements.txt` **doesn't** match the `jina_version` label we use in our `docker build ...` command. 

Why?

- I built this example with Jina 0.8.2
- Jina Hub expects you to push with the same version you built with (i.e. it would expect me to use `jina[hub]==0.8.2` to push)
- Pushing with Jina Hub wouldn't work for me until 0.9.5. Luckily `jina hub push ...` only cares about the Docker image, not my actual code (I ran `jina[hub]==0.9.5` in a separate virtualenv)
- We're working on updating this example code to 0.9.5 to get around this ugly kluge and delete this note!
