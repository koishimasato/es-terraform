#!/usr/bin/env bash

aws ecs register-task-definition --cli-input-json file://$1/task-definition.json

