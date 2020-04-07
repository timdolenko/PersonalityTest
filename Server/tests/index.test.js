const request = require('supertest')
const path = require('path')
const app = require('../src/app')
var fs = require('fs')

const answerOne = {
    "answers": [
        {
            "question": "What is your age?",
            "category": "hard_fact",
            "answer": 29
        },
        {
            "question": "What is your height?",
            "category": "hard_fact",
            "answer": "5'8"
        }
    ]
}

const readAnswersFiles = async () => {
    return new Promise((resolve, reject) => {

        const answersDirectoryPath = path.join(__dirname,'../answers')
        
        fs.readdir(answersDirectoryPath, (error, files) => { 
            if (error) {
                reject(error);
            }

            resolve(files);
        })
    });
}

test('Should save correct data', async () => {

    const answersBefore = await readAnswersFiles()

    await request(app).post('/saveAnswers').send(answerOne).expect(200)

    const answersAfter = await readAnswersFiles()
    
    let difference = answersAfter.filter(file => !answersBefore.includes(file))

    expect(difference.length).toBe(1)

    let answerFilename = difference[0]
    let answerPath = path.join(__dirname,'../answers/' + answerFilename)
    
    fs.readFile(answerPath, (e, data) => {
        if (e) throw e;
        let answer = JSON.parse(data);
        
        expect(answer).toMatchObject(answerOne)
    })
})

test('Should serve questions', async () => {
    let questionsPath = path.join(__dirname,'../public/personality_test.json')

    fs.readFile(questionsPath, async (e, data) => {
        if (e) throw e;
        let questions = JSON.parse(data);
        
        const response = await request(app).get('/personality_test.json').expect(200)
        expect(response.body).toMatchObject(questions)
    })
})