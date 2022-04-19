import { ApiService } from "./ApiService";
import { makeAutoObservable } from "mobx"

class EventsContextStore {
    groupsSearchString = '';
    eventsLoaded = false;
    events = undefined;
    allEvents = undefined;
    eventDetails = {};
    groupsLoaded = false;
    groups = undefined;
    selectedGroup = undefined;
    groupParticipants = undefined;
    showOnlySubscribed=false;

    constructor() {
        makeAutoObservable(this)
    }

    setupEmptyFields(){
        this.groupsSearchString = '';
        this.eventsLoaded = false;
        this.events = undefined;
        this.allEvents = undefined;
        this.eventDetails = {};
        this.groupsLoaded = false;
        this.groups = undefined;
        this.selectedGroup = undefined;
        this.groupParticipants = undefined;
        this.showOnlySubscribed=false;
    }

    getEvents() {
        if(!this.eventsLoaded) {
            return ApiService.getEvents().then(s=>{
                this.eventsLoaded = true;
                this.allEvents = s.events;
                if(this.allEvents == null){
                    this.allEvents = [];
                }
                if(this.showOnlySubscribed){
                    this.events = this.allEvents.filter(e =>e.subscribed);
                }
                else{
                    this.events = this.allEvents;
                }
            }, err=>{
                console.error("Failed request to api: getEvents");
                console.error(err);
            });
        }
    }

    changeSubscription(subscription, eventId) {
        return ApiService.changeSubscription(subscription, eventId).then(s=>{
            this.eventDetails[eventId].subscribed = subscription;
        }, err=>{
            console.error("Failed request to api: changeSubscription");
            console.error(err);
        });
    }

    getEventDetails(event_id){
        if(!this.eventDetails[event_id]){
            ApiService.getEventDetails(event_id).then(s=>{
                this.eventDetails[event_id] = s.event;
            }, err=>{
                console.error("Failed request to api: getEventDetails");
                console.error(err);
            });
            return null;
        }
        else{
            return this.eventDetails[event_id];
        }
    }

    getGroups(){
        if(!this.groupsLoaded) {
            return ApiService.getGroups().then(s=>{
                this.groupsLoaded = true;
                this.groups = s.groups;
                if(this.groups == null){
                    this.groups = [];
                }
            }, err=>{
                console.error("Failed request to api: getGroups");
                console.error(err);
            });
        }
    }

    getGroup(groupId){
        if(this.groupsLoaded){
            return this.groups.find(g => g.ID === groupId)
        }
        else{
            this.getGroups();
            return null;
        }
    }

    getGroupParticipants(groupId){
        if(this.selectedGroup !== groupId){
            this.selectedGroup = groupId
            ApiService.getGroupParticipants(groupId).then(s=>{
                this.groupParticipants = s.participants;
            }, err=>{
                this.selectedGroup = null;
                console.error("Failed request to api: getGroupParticipants");
                console.error(err);
            });
        }
    }

    eventsFilter( shouldShowOnlySubscribed){
        this.showOnlySubscribed = shouldShowOnlySubscribed;
        if(this.showOnlySubscribed){
            this.events = this.allEvents.filter(e =>e.subscribed);
        }
        else{
            this.events = this.allEvents;
        }
    }
}

export const eventsContext = new EventsContextStore();