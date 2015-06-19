var Gpio = require('onoff').Gpio,
    garageDoorOpen = new Gpio(14, 'out'),
    garageDoorClose = new Gpio(22, 'out'),
    garageDoorEnable = new Gpio(12, 'out'),
    garageDoorInput1 = new Gpio(6, 'out'),
    garageDoorInput2 = new Gpio(5, 'out'),
    openingTimer = 30000,
    doorStatus = 2,
    lastOpen = getDate(),
    lastClose = getDate(),
    lastUser = "",
    status = {
        1 : "Ouvert",
        2 : "Fermé",
        4 : "En cours d'ouverture",
        5 : "Le portail est actuellement ouvert",
        6 : "En cours de fermeture",
        7 : "Le portail est actuellement fermé",
    };

function getDate(){
    now = new Date();
    return new Date(now.getTime() - now.getTimezoneOffset() * 60000);
}

exports.GPIOController = {

    getDoorStatus : function(text){
        if(text){
            return status[doorStatus];
        }else{
            return doorStatus
        }
    },

    getTimer : function(){
        return openingTimer;
    },

    getLastActionDate : function(action){
        if(action){
            return lastOpen;
        }else{
            return lastClose;
        }
    },

    getLastUser : function(action){
        return lastUser;
    },

    openGarageDoor : function(user, callback){

        if(doorStatus != 4 && doorStatus != 6){

            if(doorStatus == 2){

                garageDoorEnable.writeSync(1);
                garageDoorInput1.writeSync(0);
                garageDoorInput2.writeSync(1);

                doorStatus = 4;
                lastOpen = getDate(); 
                lastUser = user;

                setTimeout(function(){
                    garageDoorEnable.writeSync(1);
                    garageDoorInput1.writeSync(0);
                    garageDoorInput2.writeSync(0);
                    doorStatus=1;
                },openingTimer);

                callback.call(this, {status_code : 4, status_text : status[4], date : lastOpen});
            }else{
                callback.call(this, {status_code : 5, status_text : status[5]});  
            }

        }else if(doorStatus != 6) {
            callback.call(this, {status_code : 4, status_text : status[4]});
        }else{
            callback.call(this, {status_code : 6, status_text : status[6]});
        }
    },

    closeGarageDoor : function(user,callback){


        if(doorStatus != 4 && doorStatus != 6){

            if(doorStatus == 1){

                garageDoorEnable.writeSync(1);
                garageDoorInput1.writeSync(1);
                garageDoorInput2.writeSync(0);

                doorStatus = 6;
                lastClose = getDate();
                lastUser = user;

                setTimeout(function(){

                    garageDoorEnable.writeSync(1);
                    garageDoorInput1.writeSync(0);
                    garageDoorInput2.writeSync(0);
                    doorStatus =2;
                },openingTimer);

                callback.call(this, {status_code : 6, status_text : status[6]});
            }else{
                callback.call(this, {status_code : 7, status_text : status[7]});
            }

        }else if(doorStatus != 4) {
            callback.call(this, {status_code : 6, status_text : status[6]});
        }else{
            callback.call(this, {status_code : 4, status_text : status[4]});
        }
    },

    toggleAction : function(user, callback){

        if(doorStatus == 1){
            this.closeGarageDoor(user, callback);
        }else{
            this.openGarageDoor(user, callback);
        }

    },

    test : function(){

        garageDoorEnable.writeSync(1);
        garageDoorInput1.writeSync(0);
        garageDoorInput2.writeSync(1);
    }

}