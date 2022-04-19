module core

imports dbmodel

function GenderFromString(g:String):Gender{
    if(g == "Male"){
        return maleGender;
    }
    if(g == "Female"){
        return maleGender;
    }
    if(g == "Other"){
        return maleGender;
    }
    return null;
}
function ContactTypeFromString(g:String):ContactType{
    if(g == "WhatsAppContactType"){
        return WhatsAppContactType;
    }
    if(g == "PhoneContactType"){
        return PhoneContactType;
    }
    if(g == "FacebookContactType"){
        return FacebookContactType;
    }
    if(g == "InstagramContactType"){
        return InstagramContactType;
    }
    return null;
}

function setupEventGroups() {
  log("executing setupEventGroups");
  var events := from Event as evnt;
  
  for(evt in events){
    var groupCreationNeeded:= false;
    var closeSubscribtionsDate := evt.referencePoint.addDays(-1 * evt.closeSubscribtions);
    if(closeSubscribtionsDate.getDayOfYear() == now().getDayOfYear() && closeSubscribtionsDate.getYear() == now().getYear()) {
      groupCreationNeeded := true;
    }
    
    if(groupCreationNeeded && !(evt.schedule==never && evt.processedAtLeastOnce)){
      log("Creating groups for " + evt.name);
      
      // Create a randomized order collection
      var users := evt.subscribers;
      var users2 := List<User>();
      for(u in users){
        users2.add(u);
      }
      var usersShuffled := JavaProxyClass.j_shuffle(users2);
      
      //Assign them to group of evt.maxCount
      var j:=0;
      var evtGroup: EventGroup;
      for(u in usersShuffled) {
        if(j==0){
          evtGroup:=EventGroup{
            name := evt.name,
            date := evt.referencePoint,
            event:= evt,
            participants := Set<User>()
          };
        }
        evtGroup.participants.add(u);
        j := j+1;
        if(j==evt.maxParticipants){
          evtGroup.save();
          j:=0;
          evtGroup := null;
        }
      }
      if(evtGroup!=null){
          evtGroup.save();
      }
      
      
      //Determine nextEventDate
      case(evt.schedule){
        daily{
          evt.referencePoint := evt.referencePoint.addDays(1);
        }
        weekly{
          evt.referencePoint := evt.referencePoint.addDays(7);
        }
        biweekly{
          evt.referencePoint := evt.referencePoint.addDays(14);
        }
        monthly{
          evt.referencePoint := evt.referencePoint.addMonths(1);
        }
        default { //never and invalid 
          
        }
      }
      evt.processedAtLeastOnce := true;
      evt.save();
    }
  }
  log("executed setupEventGroups");
}

function getFriends(): List<User> {
  var users := List<User>();
  for(ux in securityContext.principal.matchedUsers){
    if(securityContext.principal in ux.matchedUsers){
      users.add(ux);
    }
  }
  return users;
}

function userToJson(p: User, includeContacts: Bool): JSONObject {
    var temp := JSONObject();
    temp.put("username",p.username);
    temp.put("name",p.profile.name);
    temp.put("surname",p.profile.surname);
    temp.put("age",p.profile.age);
    if(p.profile.gender == null){
      temp.put("gender","");
    }
    else {
      temp.put("gender",p.profile.gender.name);
    }

    var interests := JSONArray();
    if(p.profile.interests !=null){
      for(i in p.profile.interests){
          var i_json := JSONObject();
          i_json.put("name", i.name);
          i_json.put("id", i.id);
          interests.put(i_json);
      }
    }
    temp.put("interests", interests);

    if(includeContacts && p.profile.contacts != null){
        var contacts := JSONArray();
        for(c in p.profile.contacts){
            var c_json := JSONObject();
            if(c.contactType==null){
              c_json.put("contactType", "");
            }
            else{
              c_json.put("contactType", c.contactType.name);
            }
            c_json.put("contactValue", c.contactValue);
            contacts.put(c_json);
        }
        temp.put("contacts",contacts);
    }
    return temp;
}

function messageToJson(m:Message): JSONObject {
    var temp := JSONObject();
    temp.put("ID",m.id);
    temp.put("content",m.content);
    temp.put("from",m.from.username);
    temp.put("fromDisplayName",displayName(m.from));
    temp.put("to",m.to.username);
    temp.put("toDisplayName",displayName(m.to));
    temp.put("timestamp",m.timestamp.format("yyyy-MM-dd HH:mm:ss Z"));
    return temp;
}

function getRandomUserForMatch(currentUser:User): User {
  var users := from User as u;
  var userToMatch := List<User>();
  for(u in users){
    if(!(u in currentUser.matchedUsers) && !(u in currentUser.dismatchedUsers) && u != currentUser && (StudentRole in u.roles)){
      userToMatch.add(u);
    }
  }
  // var all := from User as u where u not in (select ux.matchedUsers from User as ux where ux.username = ~currentUser.username);
  // var userToMatch := from User as u where (u not in currentUser.matchedUsers and u not in currentUser.dismatchedUsers);
  
  if(userToMatch.length == 0){
    return null;
  }
  var rand := (random() * userToMatch.length.floatValue()).floor();
  var user := userToMatch[rand];
  return user;
}

function canSeeUser(currentUser:User, targetUser:User): Bool {
  if(!loggedIn()){
    // Not logged in
    return false;
  }
  if(currentUser in targetUser.matchedUsers && targetUser in currentUser.matchedUsers){
    // Mached
    return true;
  }
  for( evt in currentUser.participatedIn){
    if(evt in targetUser.participatedIn){
      // Shared event
      return true;
    }
  }
  return false;
}

function getMessages(currentUser:User, secondUser: User):List<Message>{
  var messages := List<Message>();
  for( m in currentUser.sentMessages){
    if(m.to==secondUser){
      messages.add(m);
    }
  }
  for( m in currentUser.receivedMessages){
    if(m.from==secondUser){
      messages.add(m);
    }
  }
  bubbleSortMessages(messages);
  return messages;
}

// todo: use sort from java
// without while(){} or continue I'm just will use bubble sort, at this scale it shouldn't be a problem
function bubbleSortMessages(array: List<Message>) {
    for(i:Int from 0 to array.length){ 
      for(j:Int from i to array.length){ 
        if(array.get(i).timestamp.after(array.get(j).timestamp)){
          var temp:=array.get(i);
          array.set(i,  array.get(j));
          array.set(j,temp);
        }
        
      }
    }
}

function displayName(u:User):String {
  if(u==null){
    return "";
  }
  if(u == securityContext.principal){
    return "You";
  }
  if(u.profile == null || u.profile.name == null || u.profile.name == "" || u.profile.surname == null || u.profile.surname == ""){
    return u.username;
  }
  else{
    return u.profile.name+" "+u.profile.surname;
  }
}

function sendMatchedEmailIfMatched(user1 : User, user2: User){
  var smtpFromEmail: String := null;
  if(smtpFromEmail ==null){
    return;
  }
  if(user1 in user2.matchedUsers && user2 in user1.matchedUsers){
    log("Sending match information emails");
    email matchedEmail(user1, user2, smtpFromEmail);
    email matchedEmail(user2, user1, smtpFromEmail);
  }
}

define email matchedEmail(userTo : User, otherUser: User, smtpFromEmail: String) {
  to(userTo.username)
  from(smtpFromEmail)
  subject("You have a match")

  par{ "Dear " ~displayName(userTo) ", " }
  par{
    "You are now friends with " ~displayName(otherUser)
  }
  par{
    <a href="~navigate(friends())">
      "Check your new friends in our system!"
    </a>
  }
}