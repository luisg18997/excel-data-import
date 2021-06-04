import express from 'express';
import morgan from 'morgan';
import cors from 'cors';
import fileUpload from 'express-fileupload';
import swaggerUI from 'swagger-ui-express';
import swaggerJsDoc from 'swagger-jsdoc';
import routes from '../routes';
import swaggerOptions from './swagger';


const Server = () => {
    const app = express();
    const swaggerDocs = swaggerJsDoc(swaggerOptions);
    //middleware
    app.use(morgan('dev'));
    app.use(cors());
    app.use(express.json({limit: '50mb'}));
    app.use(express.urlencoded({limit: '50mb'}));
    app.use(fileUpload());
    app.use('/api-docs', swaggerUI.serve, swaggerUI.setup(swaggerDocs))
 
    routes(app);
    try {
        
    } catch (err) {
    console.error(err);
    }

    const port = process.env.PORT;
    app.listen(port, () => {
    console.log(`Server is listening on port ${port}.`);
    });

}

export default Server;
