# Symfony_open_swoole_docker
Symfony with Openswoole / swoole bundle via docker

# Symfony with OpenSwoole

This repository demonstrates how to set up a Symfony project with OpenSwoole, enabling high-performance asynchronous operations using coroutines. 
Coroutines in this setup are **manual**, and the full coroutine integration is **under development and open to contributions**.

## Features

- **Asynchronous server**: Symfony with OpenSwoole to handle HTTP requests asynchronously.
- **Manual coroutines**: Coroutines need to be manually enabled and integrated.
- **High-performance**: Optimized for speed with multiple workers and task workers.

## Requirements

- **Docker**: For running the application in a containerized environment.
- **PHP 8.4+**: Required for running OpenSwoole.
- **OpenSwoole**: An asynchronous PHP extension that provides coroutine-enabled server capabilities.

## Getting Started


### 1. Build and start the container

```bash
make setup
```

