const server = require('./config/server')

const port = process.env.PORT
server(port);