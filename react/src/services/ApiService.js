import axios from "axios";

const api_url = "http://localhost:3000/befriend/";
const defaultOptions = defaultOptions;
const handleResponse = (resp) => {
    const data = resp?.data;
    if(data?.message === "OK"){
        return data;
    }
    else{
        console.error(resp)
        throw new Error(`API returned error: ${resp.message}`)
    }
}



export const ApiService = {
    login: function(username, password) {
        const user = {username, password};
        const url = `${api_url}userlogin`
        return axios.post(url, user);
    },

    logout: function() {
        return axios.get(`${api_url}api_logout`);
    },

    register: function(username, password, confirmPassword) {
        const user = {username, password, confirmPassword};
        return axios.post(`${api_url}api_register`, user);
    },

    me: function() {
        return axios.get(`${api_url}api_me`, defaultOptions).then(handleResponse);
    },

    changePassword: function(oldPassword, password, confirm) {
        const data = {oldPassword, password, confirm};
        return axios.post(`${api_url}api_changePassword`, data);
    },

    getProfile: function() {
        return axios.get(`${api_url}api_profile`, defaultOptions).then(handleResponse);
    },
    saveProfile: function(profile) {
        return axios.post(`${api_url}api_profile`, profile, defaultOptions);
    },
    interests: function() {
        return axios.get(`${api_url}api_interests`, defaultOptions).then(handleResponse);
    },
    addInterest: function(interest_Id) {
        return axios.post(`${api_url}api_interests`, {'interest_Id':interest_Id}, defaultOptions);
    },
    createInterest: function(interest) {
        return axios.post(`${api_url}api_make_interests`, {'interest':interest}, defaultOptions);
    },
    getEvents: function(interest) {
        return axios.get(`${api_url}api_events`, defaultOptions).then(handleResponse);
    },
    changeSubscription: function(subscription, eventId) {
        return axios.post(`${api_url}api_changesubscription`, {'subscription':subscription, 'eventId':eventId}, defaultOptions);
    },
    getEventDetails: function(event_id) {
        return axios.get(`${api_url}api_event?eventid=${event_id}`, defaultOptions).then(handleResponse);
    },
    getGroups: function() {
        return axios.get(`${api_url}api_groups`, defaultOptions).then(handleResponse);
    },
    getGroupParticipants: function(groupId) {
        return axios.get(`${api_url}api_groupparticipants?groupId=${groupId}`, defaultOptions).then(handleResponse);
    },
    getFriends: function() {
        return axios.get(`${api_url}api_friends`, defaultOptions).then(handleResponse);
    },
    getMatch: function() {
        return axios.get(`${api_url}api_match`, defaultOptions)
        .then(resp => resp?.data?.message === "NOUSER" ? null : resp?.data);
    },
    reactMatch: function(username, reaction){
        const data = {
            'username':username,
            'reaction':reaction
        };
        return axios.post(`${api_url}api_match`,data, defaultOptions);
    },
    addContact: function(newContacttype, newContactvalue){
        const data = {
            'contactType':newContacttype,
            'contactValue':newContactvalue
        };
        return axios.post(`${api_url}api_contact`, data, defaultOptions);
    },
    getMessages(username){ 
        return axios.get(`${api_url}api_message?username=${encodeURIComponent(username)}`, defaultOptions).then(handleResponse);
    },
    sendMessage(message, username){ 
        const data = {
            'message':message,
        };
        return axios.post(`${api_url}api_message?username=${encodeURIComponent(username)}`, data, defaultOptions); 
    }
};
