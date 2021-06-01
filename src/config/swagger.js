require('dotenv').config();
const swaggerJsDoc = require('swagger-jsdoc');
const path = require('path')

const dir = path.join(__dirname, '../routes');

// config of documetantion
module.exports = () => {
const swaggerOptions = {
    swaggerDefinition: {
        openapi: '3.0.1',
        info: {
            title: 'Excel import data API',
            description: 'Excel import data API',
            contact: {
                name: 'Excel import data developer',
            },
            servers: [`localhost:${process.env.PORT}`]
        },
    },
    apis: [dir+'/*routes.js']
}

const swaggerDocs = swaggerJsDoc(swaggerOptions);
return swaggerDocs;
};