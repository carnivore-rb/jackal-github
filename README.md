# Jackal Github

Processes incoming payloads from github.

## Usage

Configure incoming source using the `:http_paths` source:

```json
...
"sources": {
  "input": {
    "type": "http_paths",
    "args": {
      "port": 9090,
      "path": "/github",
      "method": "post"
    }
  }
}
...
```

## Configuration

The name provided for the payload defaults to `"github"`. This
can be overridden in the configuration using the names map,
which allows names to be provided on a per-event basis:

```json
...
"config": {
  "names": {
    "push": PUSH_NAME,
    "create": CREATE_NAME
  }
}
...
```

## Payload

The payload generated will contain the contents fo the github
payload, any query parameters provided, and the headers. It will
also add in an `event` key to designate what type of event was
received.

```json
...
"data": {
  "github": {
    "event": "X_GITHUB_EVENT",
    "query": QUERY_PARAMS,
    "headers": HTTP_HEADERS,
    GITHUB_PAYLOAD
  }
}
...
```

## Formatters

* `Jackal::Github::Formatter::CodeFetcher` Formats payload for code fetcher

# Info

* Repository: https://github.com/carnivore-rb/jackal-github
* IRC: Freenode @ #carnivore
