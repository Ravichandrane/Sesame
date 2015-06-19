var http = require('http'); 
var express = require('express');
var bodyParser = require("body-parser");
var app = express();
var GPIOCtrl = require('./GPIOController.js');

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());


app.get('/garage/status', function(req, res){
    res.status(200).json({
        status: GPIOCtrl.GPIOController.getDoorStatus(),
        status_text: GPIOCtrl.GPIOController.getDoorStatus(true),
        lastOpen : GPIOCtrl.GPIOController.getLastActionDate(1),
        lastClose : GPIOCtrl.GPIOController.getLastActionDate(),
        lastUser : GPIOCtrl.GPIOController.getLastUser()
    });
});

app.post('/garage/open', function(req, res){
    
    if(req.body.authenticate){
        last_user = req.body.authenticate;

        GPIOCtrl.GPIOController.openGarageDoor(req.body.authenticate,function(status){

            res.status(200).json({
                action : "Ouverture du portail",
                lastOpen : GPIOCtrl.GPIOController.getLastActionDate(1),
                timer : GPIOCtrl.GPIOController.getTimer(),
                response : status
            });

        })

    }else{
        res.status(404).json({ error : "access_denied" });
    }

});

app.post('/garage/close', function(req, res){
    if(req.body.authenticate){  
        
        GPIOCtrl.GPIOController.closeGarageDoor(req.body.authenticate,function(status){
            
            res.status(200).json({
                action : "Fermeture du portail",
                timer : GPIOCtrl.GPIOController.getTimer(),
                response : status
            });
        
        })
          
    }else{
        res.status(404).json({ error : "access_denied" });
    }

});

app.post('/garage/toggle', function(req, res){
    if(req.body.authenticate){  
        
        GPIOCtrl.GPIOController.toggleAction(req.body.authenticate,function(status){
            
            res.status(200).json({
                action : "toggle",
                timer : GPIOCtrl.GPIOController.getTimer(),
                response : status
            });
        
        })
          
    }else{
        res.status(404).json({ error : "access_denied" });
    }

});

app.get('*', function(req, res){
    res.status(404).json({ error : "access_denied" });
});


app.listen(3000); 
console.log('App Server running at port 3000');