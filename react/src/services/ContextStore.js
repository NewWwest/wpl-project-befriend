import { makeAutoObservable } from "mobx"
import { ApiService } from "./ApiService";
import { eventsContext } from "./EventsContextStore";

class ContextStore {
    username = '';
    roles = [];
    isLoggedIn = false;
    isAdmin = false;
    isPartner = false;

    profileLoaded = false;
    profile = {
        gender: ''
    };
    interests = undefined;
    interestsLoaded = false;

    selectedInterest = undefined;
    newInterest = undefined;
    friendsLoaded = false;
    friends = undefined;
    error = undefined;
    matchingUser = undefined;
    newContact = {
        contactType: '',
        contactValue: ''
    };

    messages = [];
    chatWith = undefined;

    constructor() {
        makeAutoObservable(this);
    }

    setupEmptyFields(){
        this.username = '';
        this.roles = [];
        this.isLoggedIn = false;
        this.isAdmin = false;
        this.isPartner = false;
    
        this.profileLoaded = false;
        this.profile = {
            gender: ''
        };
        this.interests = undefined;
        this.interestsLoaded = false;
        this.selectedInterest = undefined;
        this.newInterest = undefined;
        this.friendsLoaded = false;
        this.friends = undefined;
        this.error = undefined;
        this.matchingUser = undefined;
        this.newContact = {
            contactType: '',
            contactValue: ''
        };
        this.messages = [];
        this.chatWith = undefined;
    }

    login(username, password) {
        return ApiService.login(username, password).then(s=>{
            this.username = username;
            this.isLoggedIn = true;
            globalContextStore.initialize();
        }, err=>{
            console.error("Failed request to api: login")
            console.error(err)
        });
    }

    initialize() {
        return ApiService.me().then(s=>{
            if(s.message === "OK"){
                this.roles = s.roles;
                this.username = s.username;
                this.isLoggedIn = true; 
                this.isAdmin = this.roles.some(r => r === "admin");
                this.isPartner = this.roles.some(r => r === "partner");
            }
        }, () => {
            // not really an error - just ignore
        });
    }

    register(username, password, confirm){
        if(password!==confirm){
            return null;
        }
        return ApiService.register(username, password, confirm).then(s=>{
        }, err=>{
            console.error("Failed request to api: register")
            console.error(err)
        });
    }

    logout() {
        return ApiService.logout().then(s=>{
            this.setupEmptyFields();
            eventsContext.setupEmptyFields();
        }, err=>{
            console.error("Failed request to api: logout")
            console.error(err)
        });
    }

    changePassword(oldPassword, password, confirm) {
        return ApiService.changePassword(oldPassword, password, confirm).then(s=>{
        }, err=>{
            console.error("Failed request to api: changePassword")
            console.error(err)
        });
    }

    getProfile() {
        if(!this.profileLoaded){
            this.profileLoaded=true;
            return ApiService.getProfile().then(s=>{
                this.profile = s.profile;
            }, err=>{
                console.error("Failed request to api: getProfile");
                console.error(err);
            });
        }
    }

    saveProfile() {
        return ApiService.saveProfile(this.profile).then(s=>{
        }, err=>{
            console.error("Failed request to api: saveProfile");
            console.error(err);
        });
    }

    getInterest() {
        if(!this.interestsLoaded){
            this.interestsLoaded = true;
            return ApiService.interests().then(s=>{
                this.interests = s.interests;
                this.interestList =s.interests.map(x=>{
                    return {
                        'name':x.name,
                        'value':  x.ID,
                        'ID': x.ID,
                        'label': x.name
                    };
                  });
            }, err=>{
                console.error("Failed request to api: getInterest");
                console.error(err);
            });
        }
    }

    addInterest(interest_Id) {
        return ApiService.addInterest(interest_Id).then(s=>{
            this.profileLoaded=false;
            this.getProfile();
        }, err=>{
            console.error("Failed request to api: addInterest");
            console.error(err);
        });
    }

    createInterest(interest_name) {
        return ApiService.createInterest(interest_name).then(s=>{
            this.interestsLoaded=false;
            this.newInterest="";
            this.getInterest();
        }, err=>{
            console.error("Failed request to api: createInterest");
            console.error(err);
        });
    }

    getFriends(){
        if(!this.friendsLoaded){
            this.friendsLoaded = true;
            ApiService.getFriends().then(s=>{
                this.friends = s.friends;
            }, err=>{
                this.selectedGroup = null;
                console.error("Failed request to api: getFriends");
                console.error(err);
            });
        }
    }

    getFriend(username){
        return this.friends?.find(f=>f.username===username);
    }

    nextMatch(){
        if(!this.matchingUser){
            ApiService.getMatch().then(s=>{
                this.matchingUser =  s.match;
            }, err=>{
                this.selectedGroup = null;
                console.error("Failed request to api: nextMatch");
                console.error(err);
            });
        }
    }

    reactMatch(username, reaction){
        ApiService.reactMatch(username, reaction).then(s=>{
            this.matchingUser = null;
            this.nextMatch();
        }, err=>{
            this.matchingUser = null;
            console.error("Failed request to api: reactMatch");
            console.error(err);
        });
    }

    addContact(newContact) {
        ApiService.addContact(newContact.contactType, newContact.contactValue).then(s=>{
            this.newContact = {
                contactType: '',
                contactValue: ''
            };
            this.getProfile();
        }, err=>{
            console.error("Failed request to api: addContact");
            console.error(err);
        });
    }

    getMessages(username, force){
        if(!username){
            return;
        }
        if(force || this.chatWith!== username){
            this.chatWith = username;
            ApiService.getMessages(username).then(s=>{
                this.messages=s.messages;
            }, err=>{
                console.error("Failed request to api: getMessages");
                console.error(err);
            });
        }
    }
    sendMessage(message, username){
        return ApiService.sendMessage(message, username).then(s=>{
            this.getMessages(username, true);
        }, err=>{
            console.error("Failed request to api: sendMessage");
            console.error(err);
        });

    }
}

export const globalContextStore = new ContextStore();