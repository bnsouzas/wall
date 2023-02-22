const functions = require('@google-cloud/functions-framework');
const { initializeApp } = require('firebase-admin/app');
const { getFirestore } = require('firebase-admin/firestore');
const { v4 } = require('uuid');
initializeApp();
const db = getFirestore();

const router = {
    'GET': async (req, res) => {
        const email = req.params[0]
        const accountExists = await db.collection('accounts').doc(email).get()
        if (!accountExists.exists) {
            res.status(404).json({ message: `${email} não encontrado`})
        }
        const document = accountExists.data()
        res.status(200).json(document)
    },
    'POST': async (req, res) => {
        const account = req.body
        account.id = v4()
        const accountExists = await db.collection('accounts').doc(account.email).get()
        let document = null
        let status = 200
        if (accountExists.exists) {
            document = accountExists.data()
        } else {
            await db.collection('accounts').doc(account.email).set(account);
            const accountExists = await db.collection('accounts').doc(account.email).get()
            document = accountExists.data()
            status = 201
        }
        res.status(status).json(document)
    },
    'DELETE': async (req, res) => {
        const email = req.params[0]
        const accountExists = await db.collection('accounts').doc(email).get()
        if (!accountExists.exists) {
            res.status(404).json({ message: `${email} não encontrado`})
        }
        await db.collection('accounts').doc(email).delete()
        res.status(204).send()
    }
}

functions.http('register', async (req, res) => {
    await router[req.method](req, res)
});
