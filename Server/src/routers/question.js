const express = require('express')
const router = new express.Router()

const path = require('path')
const fs = require('fs')
const { generateUniqueIdentifier } = require('./../utils/uniqueIdentifier.js')

const publicDirectoryPath = path.join(__dirname,'./../../public')
const answersDirectoryPath = path.join(__dirname,'./../../answers')

router.use(express.static(publicDirectoryPath))

router.post('/saveAnswers', async (req,res) => {
    
    const data = JSON.stringify(req.body)
    
    const filename = answersDirectoryPath + '/' + generateUniqueIdentifier() + '.json'

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

module.exports = router