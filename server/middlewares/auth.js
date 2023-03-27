
const jwt = require("jsonwebtoken");

const auth = async (req,res,next)=>{
    try{
        const token = req.header("x-auth-token");//kuch bhi naam de sakte token ko // x-auth-token is jwt (json token)

        if(!token){
            return res.status(401).json({msg:"No auth toke,access denied. "});//  401 - user is unauthorised aur 400 matlab bad request
        }

        const verified = jwt.verify(token,"passwordKey");

        if(!verified){
            return res.status(401).json({msg:"token verification failed, authorization denied"});
        } 
        
        req.user = verified.id;
        req.token = token;
        next();// ye function middleware se aage leke jayega final destination pe
    }
    catch(e){
        res.status(500).json({error : e.message});
    }
}



module.exports = auth;