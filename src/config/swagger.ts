import dotenv from 'dotenv';
import path from 'path';

dotenv.config();
const dir = path.join(__dirname, '../routes');

// config of documetantion

const swaggerOptions:Object = {
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
    apis: [dir+'/*.ts']
};

export default swaggerOptions;

