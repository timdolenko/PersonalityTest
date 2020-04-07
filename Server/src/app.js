const path = require('path')
const express = require('express')
const fs = require('fs')
const nameGenerator = require('./name_generator.js')

const app = express()
const publicDirectoryPath = path.join(__dirname,'../public')
const answersDirectoryPath = path.join(__dirname,'../answers')

app.use(express.json())

app.use(express.static(publicDirectoryPath))

app.post('/saveAnswers', async (req,res) => {
    
    const data = JSON.stringify(req.body)
    
    const filename = answersDirectoryPath + '/' + nameGenerator.generateUniqueIdentifier() + '.json'

    try {
        fs.writeFile(filename, data, (e) => {
            if (e) throw e;
            res.send({'status':'success'})
        })
    } catch (e) {
        console.log(e)
        res.status(500).send(e)
    }
})

app.listen(3000, () => {
    console.log('Server is up on port 3000.')
})