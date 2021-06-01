const express = require('express');
const morgan = require('morgan');
const cors = require('cors');
const timeout = require('connect-timeout');
const fileUpload = require('express-fileupload');
const swaggerUI = require('swagger-ui-express');
const routes = require('../routes')
const swaggerConf = require('./swagger');


const Server = (port) => {
    const app = express();
    const swaggerDocs = swaggerConf()
    //middleware
    app.use(morgan('dev'));
    app.use(cors());
    app.use(express.json({limit: '50mb'}));
    app.use(express.urlencoded({limit: '50mb'}));
    app.use(fileUpload());
    app.use('/api-docs', swaggerUI.serve, swaggerUI.setup(swaggerDocs))
    app.use(timeout(590000));
    app.use(haltOnTimedout);

    function haltOnTimedout(req, res, next) {
        if (!req.timedout) next();
    }
    
    routes(app);
    try {
        
    } catch (err) {
    console.error(err);
    }

    app.listen(port, () => {
    console.log(`Server is listening on port ${port}.`);
    });

}

module.exports = Server
