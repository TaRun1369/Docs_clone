const express = require('express');

const Document = require("../models/document")

const documentRouter = express.Router();

const auth = require('../middlewares/auth');

documentRouter.post('/doc/create',auth, async (req,res) => {
    try{
        const{createdAt} = req.body;// time based hai ye // delay ho sakta // createdAt ka different value ho iss wajah se
        let document = new Document({
            uid: req.user,
            title:"unititled document",
            createdAt: 1,
        });
        document = await document.save();
        res.json(document);
    } catch(e){
        res.status(500).json({error:e.message});
    }
});

//creating first route
documentRouter.get("/docs/me",auth,async(req ,res)=>{
    try{
        let documents = await Document.find({uid: req.user});
        res.json(documents);
    } catch(e){
        res.status(500).json({error:e.message});
    }
});

documentRouter.post('/doc/title',auth, async (req,res) => {
    try{
        const{id,title} = req.body;// time based hai ye // delay ho sakta // createdAt ka different value ho iss wajah se
        const document = await Document.findByIdAndUpdate(id,{title});
        // document = await document.save();
        res.json(document);
    } catch(e){
        res.status(500).json({error:e.message});
    }
});

// for getting body in get request
// this one is for getting the document data.
documentRouter.get("/doc/:id",auth,async(req ,res)=>{
    try{
        const document = await Document.findById(req.params.id);
        res.json(document);
    } catch(e){
        res.status(500).json({error:e.message});
    }
});



module.exports = documentRouter;