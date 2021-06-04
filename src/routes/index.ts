declare module 'express' {
    interface Request {
      body: any // Actually should be something like `multer.Body`
      files: any // Actually should be something like `multer.Files`
    }
  }
import { Request, Response } from 'express';
import { ImportData } from '../controllers';

const routes = (router:any) => {
    /**
     * @swagger
     * tags:
     *    name: Import
     *    description: routes of import data
     */

    /**
     * @swagger
     * /:
     *  post:
     *    tags:
     *      - Import
     *    description: import data of excel
     *    requestBody:
     *      required: true
     *      content:
     *        multipart/form-data:
     *          schema:
     *            type: object
     *            properties:
     *              document:
     *                type: string
     *                format: binary
     *                description: file excel for import data
     *            required:
     *              - document
     *    responses:
     *      200:
     *        description: OK
     *      400:
     *        description: BAD REQUEST
     */
     
    router.post('/', async(req: Request, res: Response) => {
        let status = 200
        let result = {
        success: true,
        message: 'Import Data succesfully'
        }
        let data = null
        try {
            data = await ImportData(req.files.document);
            
        } catch (error) {
            status= 400
            result = {
            success: false,
            message: error
            }
        }
        res.status(status).send({...result, data})
    })

};

export default routes