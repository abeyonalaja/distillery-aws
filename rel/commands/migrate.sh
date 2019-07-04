#!/usr/bin/env bash

exec bin/start foreground
# release_ctl eval --mfa "Example.ReleaseTasks.migrate/1" --argv -- "$@"