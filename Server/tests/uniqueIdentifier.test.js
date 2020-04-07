const { generateUniqueIdentifier } = require('../src/utils/uniqueIdentifier.js')

test('Should generate identifier with correct width', () => {
    const res = generateUniqueIdentifier()
    const correctWidth = 13;

    if (res.length != correctWidth) {
        throw new Error(`Length should be equal to ${correctWidth}, but it is ${res.length}.`)
    }
})