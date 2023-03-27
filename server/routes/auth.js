const express = require("express");
const User = require("../models/user");

const jwt = require("jsonwebtoken");// data secure karne ke liye
const auth = require("../middlewares/auth");
const authRouter = express.Router();

authRouter.post("/api/signup", async (req,res)=>{
    try{
        const {name,email,profilePic} = req.body;
        // http.post('localhost:3ØØØ/api/signup', body{//data})
        // aisa kuch scene rahega
        let user = await User.findOne({email:email});

        if(!user){
            user = new User({
                email:email,
                name:name,
                profilePic:profilePic,
                //profilePic, // sirf ye likhna bhi chalega map mein
                // curly bracket manje map
            });
            user = await user.save();
        }

        const token = jwt.sign({id: user._id},"passwordKey");

        res.json({user,token});
    } catch(e){
        console.log(e);
        res.status(500).json({error:e.message});
    }
});

authRouter.get('/',auth,async(req,res)=>{ 
    //console.log(req.user);// ye middleware ke auth.js se aayega aur id store karega
    const user = await User.findById(req.user);
    res.json({user,token:req.token});
});

module.exports = authRouter;