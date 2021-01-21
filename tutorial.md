<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [Build Your First Jina App](#build-your-first-jina-app)
  - [👋 Introduction](#-introduction)
  - [🗝️ Key Concepts](#-key-concepts)
  - [🧪 Try it Out!](#-try-it-out)
  - [🐍 Install](#-install)
  - [🏃 Run the Flows](#-run-the-flows)
  - [🤔 How Does it Actually Work?](#-how-does-it-actually-work)
  - [⏭️  Next Steps](#-next-steps)
  - [🤕 Troubleshooting](#troubleshooting)
  - [🎁 Wrap Up](#-wrap-up)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Build Your First Jina App

## 👋 Introduction

This tutorial guides you through building your own neural search app using the [Jina framework](https://github.com/jina-ai/jina/). Don't worry if you're new to machine learning or search. We'll spell it all out right here.

|              |                     |
| ---          | ---                 |
| Medium       | Text                |
| Input        | Wikipedia sentences |
| Output       | Wikipedia sentences |
| Jina version | 0.8.2               |

TODO
![](./images/jinabox-startrek.gif)

Our example program will be a simple neural search engine for text. It will take a user's typed input, and return a list of sentences from Wikipedia that match most closely.

TODO When you're finished, you'll have recreated our [wikipedia sentence search example]() from scratch and have a better understanding of how things work in Jina.

⚠️ Need help? Check out the **[troubleshooting](#troubleshooting)** section further along.

## 🗝️ Key Concepts

TODO urls

- **[What is Neural Search?]()** See how Jina's search is different from the traditional way
- **[Jina 101](https://github.com/jina-ai/jina/tree/master/docs/chapters/101)**: Get an idea of Jina's core components
- **[Jina 102](https://github.com/jina-ai/jina/tree/master/docs/chapters/102)**: See how Jina's components are wired together

## 🧪 Try it Out!

Before going through the trouble of downloading, configuring and testing your app, let's get an idea of the finished product: 

### Run with Docker

```sh
docker run --name=wikipedia-search -p 65481:65481 jinahub/app.app.jina-wikipedia-sentences-30k:0.2.3-0.9.5
```
Note: You'll need to run the Docker image before trying the steps below

### Search the Data

#### With Jinabox

[Jinabox](https://github.com/jina-ai/jinabox.js/) is a simple web-based front-end for neural search. You can see it in the graphic at the top of this tutorial.

1. Go to [jinabox](https://jina.ai/jinabox.js) in your browser
2. Ensure you have the server endpoint set to `http://127.0.0.1:65481/api/search`
3. Type a phrase into the search bar and see which Wikipedia sentences come up

**Note:** If it times out the first time, that's because the query system is still warming up. Try again in a few seconds!

#### With `curl`

```sh
curl --request POST -d '{"top_k":10,"mode":"search","data":["middle east"]}' -H 'Content-Type: application/json' 'http://0.0.0.0:65481/api/search'
```

`curl` will output a *lot* of information in JSON format - not just the lines you're searching for, but also metadata about the search and the Documents it returns. Look for the lines starting with `"matchDoc"` to find the matches.

After looking through the JSON you should see lines that contain the text of the Document matches, like:

```json
"text": "OACIS for the Middle East is a union list of serials from or about the Middle East.\n",
```

ℹ️  There's a LOT of other data too, but its all metadata and not strictly relevant to the output a user would want to see.

### Shut Down Docker

Start a new terminal window and run:

```sh
docker stop wikipedia-search
```

To cleanly exit the Docker container

## 🐍 Install

Now that you know what we're building, let's get started!

### Prerequisites

You'll need:

* A basic knowledge of Python
* Python 3.7 or higher installed, and `pip`
* 8 gigabytes or more of RAM

### Clone the Repo

Let's get the basic files we need to get moving:

TODO
```sh
git clone https://github.com/jina-ai/examples.git
cd examples/my-first-jina-app
```

### Create a New App

```sh
jina hub new --type=app
```

The CLI wizard will create the files for a basic Jina app and save you having to do a lot of typing and setup.

For building this example, we recommend the following settings:

| Parameter                   | What to type                                          |
| ---                         | ---                                                   |
| `project_name`              | `Wikipedia sentence search`                           |
| `jina_version`              | Use default setting                                   |
| `project_slug`              | Use default setting                                   |
| `author_name`               | Your name                                             |
| `project_short_description` | `Search Wikipedia sentences using Jina neural search` |
| `task_type`                 | `2` (NLP)                                             |
| `index_type`                | `2` (strings)                                         |
| `public_port`               | Use default setting                                   |
| `parallel`                  | Use default setting                                   |
| `shards`                    | Use default setting                                   |
| `version`                   | Use default setting                                   |

TODO
After answering all the questions, the wizard will create [a folder and files](https://docs.google.com/document/d/1A2t-K2DEZvJ7sOmWLuCmUQINyESaxucM7wOJCSCPmdI/edit#) for your new Jina app.

### Install Requirements

In your terminal:

```sh
cd wikipedia_sentence_search
pip install -r requirements.txt
```

⚠️  Now we're going to get our hands dirty, and if we're going to run into trouble, this is where we'll find it. If you hit any snags, check our **[troubleshooting](#troubleshooting)** section!

### Download Data

Our goal is to search a set of sentences from Wikipedia and return the closest sentences to our search term. We're using [this dataset](https://www.kaggle.com/mikeortman/wikipedia-sentences) from Kaggle.

There are almost 8 million sentences in this dataset - that sounds like a LOT of work for Jina. Since this is just an example we'll only work with a small subset to get an idea of how things work.

To get the data, you'll need to set up [Kaggle](https://www.kaggle.com/docs/api#getting-started-installation-&-authentication) and then download our dataset:

```sh
wget https://raw.githubusercontent.com/alexcg1/jina-wikipedia-sentences/master/get_data.sh
sh ./get_data.sh
```

The `get_data.sh` script:

- Creates a data directory
- Downloads the dataset from Kaggle
- Extracts and shuffles the dataset to ensure some variety in what we ask Jina to search

### Set Data Path

Now we need to tell Jina where to find the data. By default, `app.py` uses the environment variable `JINA_DATA_PATH` for this. We can simply run:

```sh
export JINA_DATA_PATH='data/input.csv'
```

You can double check it was set successfully by running:

```sh
echo $JINA_DATA_PATH
```

## 🏃 Run the Flows

Now that we've got our dataset, let's write our app and run our Flows!

### Index Flow

First up we need to build up an index of our dataset, which we'll later search with our search Flow.

```sh
python app.py index
```

You'll see a lot of output scrolling by. You'll know indexing is complete once you see:

```sh
Flow@58199[S]:flow is closed and all resources should be released already, current build level is EMPTY
```

This may take a little while the first time, since Jina needs to download the language model and tokenizer to process the dataset. You can think of these as the brains that power the search.

### Search Flow

Run:

```bash
python app.py search
```

After a while you should see the console stop scrolling and display output like:

```console
        🖥️ Local access         http://0.0.0.0:65481
        🔒 Private network:     http://192.168.1.68:65481
        🌐 Public address:      http://81.37.167.157:65481
```

Congratulations! You've just built your very own search engine!

⚠️  Be sure to note down the port number. We'll need it for `curl` and Jinabox! In our case we can see it's `65481`.

ℹ️  `python app.py search` doesn't pop up a search interface - for that you'll need to connect via `curl`, Jinabox, or another client.

### Searching Data

See our section on [searching the data](#search-the-data).

When you're finished, you can stop the search Flow with Ctrl-C (or Command-C on a Mac).

## 🤔 How Does it Actually Work?

Let's dive deeper to learn what happens inside our Flows and how they're built up from Pods.

### Flows

<img src="https://raw.githubusercontent.com/jina-ai/jina/master/docs/chapters/101/img/ILLUS10.png" width="30%" align="left">

As you can see in [Jina 101](https://github.com/jina-ai/jina/tree/master/docs/chapters/101), just as a plant manages nutrient flow and growth rate for its branches, Jina's Flow manages the states and context of a group of Pods, orchestrating them to accomplish one specific task. 

We define Flows in `app.py` to index and query our dataset:

```python
from jina.flow import Flow

<other code here>

def index():
    f = Flow.load_config('flows/index.yml')

    with f:
        data_path = os.path.join(os.path.dirname(__file__), os.environ.get('JINA_DATA_PATH', None)) # Set data path
        f.index_lines(filepath=data_path, batch_size=16, read_mode='r', size=num_docs) # Set mode (index_lines) and indexing settings
```

Then to start the Flow, we just run `python app.py <flow_name>`, in this case:

```sh
python app.py index
```

ℹ️  Alternatively you can build Flows in `app.py` itself [without specifying them in YAML](https://docs.jina.ai/chapters/flow/index.html) or with [Jina Dashboard](http://dashboard.jina.ai)

#### Indexing

Every Flow has well, a flow to it. 

If you look at `input.csv` you'll see it's just one big text file. Our Flow will process it into something more suitable for Jina, which is handled by the Pods in the Flow. Each Pod performs a different task, with one Pod's output becoming another Pod's input. 

Let's look at `flows/index.yml`:

```yaml
!Flow
pods:
  crafter:
    uses: pods/craft.yml
    parallel: $JINA_PARALLEL
    read_only: true
  encoder:
    uses: pods/encode.yml
    parallel: $JINA_PARALLEL
    timeout_ready: 600000
    read_only: true
  doc_indexer:
    uses: pods/doc.yml
    shards: $JINA_SHARDS
    separated_workspace: true
```

Each Pod performs a different operation on the dataset:

| Pod             | Task                                                 |
| ---             | ---                                                  |
| `crafter`       | Convert each Document in the dataset into a sentence |
| `encoder`       | Encode each Document into a vector                   |
| `doc_idx`       | Build an index of the vectors                        |

#### Searching

Just like indexing, the search Flow is also defined in a YAML file, in this case at `flows/query.yml`:

```yaml
!Flow
with:
  read_only: true  # better add this in the query time
  rest_api: true
  port_expose: $JINA_PORT
pods:
  crafter:
    uses: pods/craft.yml
    parallel: $JINA_PARALLEL
  encoder:
    uses: pods/encode.yml
    parallel: $JINA_PARALLEL
    timeout_ready: 600000
    read_only: true
  doc_indexer:
    uses: pods/doc.yml
    shards: $JINA_SHARDS
    separated_workspace: true
    polling: all
    uses_reducing: _merge_all
    timeout_ready: 100000 # larger timeout as in query time will read all the data
```

As in `flows/index.yml`, we use two Pods, but this time they behave differently:

| Pod       | Task                                                    |
| ---       | ---                                                     |
| `crafter` | Convert user's query into a sentence                    |
| `encoder` | Encode user's query into a vector                   |
| `doc_idx` | Query vector index and return matching Document |

### Pods

<img src="https://raw.githubusercontent.com/jina-ai/jina/master/docs/chapters/101/img/ILLUS8.png" width="20%" align="left">

You can think of the Flow as telling Jina *what* tasks to perform on the dataset. The Pods comprise the Flow and tell Jina *how* to perform each task, and they define the actual neural networks we use in neural search, namely the machine-learning models like `distilbert-base-cased`. (Which we can see in `pods/encode.yml`)

Jina uses YAML files to describe objects like Flows and Pods, so we can easily configure the behavior without touching our application code.

Let's look at `pods/encode.yml` as an example:

```yaml

!TransformerTorchEncoder
with:
  pool_strategy: auto
  pretrained_model_name_or_path: distilbert-base-cased
  max_length: 96
```

We first use the built-in `TransformerTorchEncoder` as the Pod's **[Executor](https://github.com/jina-ai/jina/tree/master/docs/chapters/101#executors)** TODO url. The `with` field is used to specify the parameters we pass to `TransformerTorchEncoder`.

| Parameter          | Effect                                                    |
| ---                | ---                                                       |
| `pool_strategy` | Strategy to merge word embeddings into Document embedding |
| `model_name`       | Name of the model we're using                             |
| `max_length`       | Maximum length to truncate tokenized sequences to         |

All the other Pods follow similar a similar structure. While a Flow differs based on task (indexing or searching), Pods differ based on *what* is being searched (text, images, etc). 

## ⏭️  Next Steps

### Improve Accuracy

You may have noticed your results are not so accurate when you query your dataset. This can be remedied in several ways:

#### Index More Documents

Increase `MAX_DOCS` to index more sentences and give the language model has more data to work with: 

```sh
export MAX_DOCS=30000
```

#### Increase `max_length`

In `pods/encode.yml` you can increase the length of your embeddings:

```yaml
with:
  ...
  max_length: 192 # This works better for our Wikipedia dataset
```

#### Change Language Model

Language model performance will vary based on your task. If you're indexing Chinese sentences, you wouldn't use an English-language model after all! Jina uses a sane (English language) default of [`distilbert-base-cased`](https://huggingface.co/distilbert-base-cased), but you may find [other models](https://huggingface.co/models) work better depending on your dataset and use case.

In `pods/encode.yml`:

```yaml
with:
  ...
  pretrained_model_name_or_path: <your model name>
```

### Simplify the Code

The `crafter` Pod splits each entry of our dataset into individual sentences. Our dataset is already in sentences, so this Pod is redundant. Let's remove it:

```sh
rm -f pods/craft.yml
```

We'll also need to remove those Pods from `flows/index.yml` and `flows/query.yml`

## 🤕 Troubleshooting

### Module not found Error

Be sure to run `pip install -r requirements.txt` before beginning, and ensure you have lots of RAM/swap and space in your `tmp` partition (see below issues). This may take a while since there are a lot of prerequisites to install.

If this error keeps popping up, look into the error logs to try to find which module it's talking about, and then run:

```sh
pip install <module_name>
```

### My Computer Hangs

Machine learning requires a lot of resources, and if your machine hangs this is often due to running out of memory. To fix this, try [creating a swap file](https://linuxize.com/post/how-to-add-swap-space-on-ubuntu-20-04/) if you use Linux. This isn't such an issue on macOS, since it allocates swap automatically.

### `ERROR: Could not install packages due to an EnvironmentError: [Errno 28] No space left on device`

This is often due to your `/tmp` partition running out of space so you'll need to [increase its size](https://askubuntu.com/questions/199565/not-enough-space-on-tmp).

### `command not found`

For any of these errors you'll need to install the relevant software package onto your system. In Ubuntu this can be done with:

```sh
sudo apt-get install <package_name>
```

## 🎁 Wrap Up

In this tutorial you've learned:

* How to install the Jina neural search framework
* How to load and index text data from files
* How to query data with `curl` and Jinabox
* The nitty-gritty behind Jina Flows and Pods

Now that you have a broad understanding of how things work, you can try out some of more [example tutorials](https://github.com/jina-ai/examples) to build image or video search, or stay tuned for our next set of tutorials that build upon your Star Trek app.
