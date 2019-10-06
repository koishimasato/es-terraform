#!/usr/bin/env bash

curl -X PUT $1':8080/test' -d '{
  "settings": {
    "index": {
      "analysis": {
        "tokenizer": {
          "kuromoji_user_dict": {
            "type": "kuromoji_tokenizer",
            "mode": "search",
            "discard_punctuation": "false"
          }
        },
        "analyzer": {
          "my_analyzer": {
            "type": "custom",
            "tokenizer": "kuromoji_user_dict",
            "filter": ["cjk_width"]
          }
        }
      }
    }
  },
  "mappings": {
    "test": {
      "properties": {
        "id": {
          "type": "long"
        },
        "name": {
          "type": "text",
          "analyzer": "my_analyzer"
        },
        "url": {
          "type": "text"
        }
      }
    }
  }
}' -H 'Content-Type: application/json'