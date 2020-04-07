const express = require('express')
const questionRouter = require('./routers/question')

const app = express()

app.use(express.json())
app.use(questionRouter)

module.exports = app