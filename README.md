# Excel data import API

Excel data import API

## Table of content

- [Excel Data Import API](#excel-data-import-api)
  - [Table of content](#table-of-content)
  - [Prerequisites](#prerequisites)
    - [Install](#install)
    - [Environment variables](#environment-variables)
    - [Install dependencies](#install-dependencies)
- [API server](#api-server)

## Prerequisites

### Install

- [Postgres](https://www.postgresql.org/download/)
- [Nodejs](https://nodejs.org/es/download/)


### Environment variables

- Define `.env` to initialize the workspace with all the environment variables needed for local development, copying the pattern file `.envPattern`.
    Template:

    ```bash
    PORT=5050           #(listen port api)
    DB_USER=            #(username db)
    DB_PASSWORD=        #(password db)
    DB_NAME=            #(name db)
    DB_HOST=            #(host db)
    DB_PORT=            #(listen port db)
    ```

### Install dependencies
-  Now install the project dependencies with `npm install` at the root of the repository.


## API server


- To start the API server in `localhost:5050` and test your changes with Postman or `localhot:5050/api-docs`
run:

- `npm start`  to run it as a node process.

  or

- `npm run start:dev` to run it as a node process (restart the server with the changes made at the moment).

**Tip:** Use `npm start` to spin up the api faster locally for test and debugging. When everything looks good,
run it with `npm run start:dev` when making changes to the api.


