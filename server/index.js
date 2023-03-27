//console.log("hello world");
const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const http = require("http");

const authRouter = require("./routes/auth.js");
const documentRouter = require("./routes/document.js");
const Document = require("./models/document");
const PORT = process.env.PORT || 3001;

const app = express();

var server = http.createServer(app);
var io = require("socket.io")(server);

const DB =
    "mongodb+srv://test:test@cluster0.mmznspq.mongodb.net/?retryWrites=true&w=majority";

app.use(cors());
app.use(express.json());
app.use(authRouter);// middleware hai ye // bich ka aadmi
app.use(documentRouter);


// const DB = "mongodb://127.0.0.1:27017";

// mongoose.set("strictQuery",false)

mongoose
    .connect(DB)
    .then(()=>{
        console.log("Connection successful");

    })
    .catch((err)=>{
    console.log(err);
})

io.on("connection", (socket) => {
    // socket.on("join",(documentId)=>{
    //     socket.join(documentId);
    //     console.log("joined");// ye nhi ho rahs hai
    // });
    socket.on("join", (data) => {
        socket.join(data.room);
        console.log("joined"); 
    });
    // socket.on("disconnect", () => {
    //     console.log("user disconnected");
    // }
    // );
    socket.on('typing', (data) => {
        socket.broadcast.to(data.room).emit('changes', data);
    });

    // void changeListener(Function(Map<String, dynamic>) func){
    //     _socketClient.on('changes', (data) => func(data));
    // }
    // socket.on('save', (data) => {
    //     socket.broadcast.to(data.room).emit('changes', data);
    // });
    socket.on('save', (data) => {
        saveData(data); 
    });

});

const saveData = async (data) => {
    let document = await Document.findById(data.room);
    document.content = data.delta;
    document = await document.save();
};

server.listen(PORT, "0.0.0.0",() =>{
    // yaha wo string form mein nhi hai wo variable form mein hai
    console.log(`connected at port ${PORT}`);
    //console.log('hey this is changing'); // just to check nodemon
});

//// or this syntax for same above function
//app.listen(PORT,"0.0.0.0",function (){
//    console.log(`connected at port 3001`);
//});