import express from 'express'
import { errorMiddleware } from './middlewares/error.middleware.js'

const app = express()

app.use(express.json())
app.use(errorMiddleware)

app.listen(3000, () => {
    console.log("Running on port 3000")
});
