module api

imports dbmodel
imports core

service userlogin(){
  var msg := JSONObject();
  if( getHttpMethod() == "POST" ){
    var body := readRequestBody();
    var body_json := JSONObject( body );
    var username:String := body_json.getString( "username" );
    var password:Secret := body_json.getString( "password" );
    validate(authenticate( username, password ), "The login credentials are invalid." );
    
    msg.put( "message", "OK" );
  }
  else{
    msg.put( "message", "ERR" );
  }
  return msg;
}

service api_logout(){
  logout();
  var msg := JSONObject();
  msg.put( "message", "OK" );
  return msg;
}

service api_register(){
  var msg := JSONObject();
  if( getHttpMethod() == "POST" ){
    log("Executing api_register");
    var body := readRequestBody();
    var body_json := JSONObject( body );
    var username:String := body_json.getString( "username" );
    var password:Secret := body_json.getString( "password" );
    var confirmPassword:Secret := body_json.getString( "confirmPassword" );
    validate(password == confirmPassword, "Passwords do not match");
    
    var newUser := User{
      username:=username
      password:=password.digest()
      profile:= Profile{}
      roles := {StudentRole}
    };
    
    newUser.save();
    msg.put( "message", "OK" );
  }
  return msg;
}

service api_changePassword() {
  var msg := JSONObject();
  if( getHttpMethod() == "POST" ){
    log("Executing api_changePassword");
    var body := readRequestBody();
    var body_json := JSONObject( body );

    var oldPassword:String := body_json.getString( "oldPassword" );
    var password:Secret := body_json.getString( "password" );
    var confirmPassword:Secret := body_json.getString( "confirm" );

    validate(authenticate( securityContext.principal.username, oldPassword ), "Old password is invalid." );
    validate(password == confirmPassword, "Passwords do not match");

    securityContext.principal.password := password.digest();
    securityContext.principal.save();
    msg.put( "message", "OK" );
  }
  else{
    msg.put( "message", "ERR" );
  }
  return msg;
}

service api_me(){
  log("Executing api_getroles");
  var msg := JSONObject();
  if( getHttpMethod() == "GET" ){
    var roles := JSONArray();
    for(r in securityContext.principal.roles){
      roles.put(r.name);
    }
    msg.put( "message", "OK" );
    msg.put( "roles", roles );
    msg.put( "username", securityContext.principal.username );
  }
  else{
    msg.put( "message", "ERR" );
  }
  return msg;
}

service api_profile(){
  var msg := JSONObject();
  if( getHttpMethod() == "GET" ){
    log("Executing GET api_profile");
    var user := userToJson(securityContext.principal, true);
    msg.put( "message", "OK" );
    msg.put( "profile", user );
  }
  else if( getHttpMethod() == "POST" ){
    log("Executing POST api_profile");
    var body := readRequestBody();
    var body_json := JSONObject( body );
    securityContext.principal.profile.name := body_json.getString( "name" );
    securityContext.principal.profile.surname := body_json.getString( "surname" );
    securityContext.principal.profile.age := body_json.getString( "age" );
    securityContext.principal.profile.gender := GenderFromString(body_json.getString( "gender" ));
    securityContext.principal.profile.save();
  }
  else {
    msg.put( "message", "ERR" );
  }
  return msg;
}

service api_interests(){
  var msg := JSONObject();
  if( getHttpMethod() == "GET" ){
    log("Executing GET api_interests");
    var ints := from Interest as i;

    var interests := JSONArray();
    for(i in ints){
      var temp := JSONObject();
      temp.put("ID",i.id);
      temp.put("name",i.name);
      interests.put(temp);
    }
    msg.put( "message", "OK" );
    msg.put( "interests", interests );
  }
  else if( getHttpMethod() == "POST" ){
    log("Executing POST api_interests");
    var body := readRequestBody();
    var body_json := JSONObject( body );
    var interest_Id := body_json.getString( "interest_Id" );
    var ints := from Interest as i where i.id = ~interest_Id.parseUUID();
    if(!(ints[0] in securityContext.principal.profile.interests)){
      securityContext.principal.profile.interests.add(ints[0]);
      securityContext.principal.profile.save();
    }
    msg.put( "message", "OK" );
  }
  else {
    msg.put( "message", "ERR" );
  }
  return msg;
}

service api_contact(){
  var msg := JSONObject();
  if( getHttpMethod() == "POST" ){
    log("Executing POST api_contact");
    var body := readRequestBody();
    var body_json := JSONObject( body );
    var contactTypeString := body_json.getString( "contactType" );
    var ci := ContactInfo{
      contactType := ContactTypeFromString(contactTypeString)
      contactValue := body_json.getString( "contactValue" )
    };
    securityContext.principal.profile.contacts.add(ci);
    securityContext.principal.profile.save();

    msg.put( "message", "OK" );
  }
  else {
    msg.put( "message", "ERR" );
  }
  return msg;
}

service api_make_interests(){
  var msg := JSONObject();
  if( getHttpMethod() == "POST" ){
    log("Executing POST api_profile");
    var body := readRequestBody();
    var body_json := JSONObject( body );
    var interestName := body_json.getString( "interest" );
    var sameInterest := from Interest as temp_i where temp_i.name=~interestName;
    validate(sameInterest == null || sameInterest.length == 0, "This hobby already exists");
    var interestx := Interest{
      name :=interestName
    };
    interestx.save();
    msg.put( "message", "OK" );
  }
  else {
    msg.put( "message", "ERR" );
  }
  return msg;
}

service api_events(){
  var msg := JSONObject();
  if( getHttpMethod() == "GET" ){
    log("Executing GET api_events");
    var events := from Event as e;

    var eventsJson := JSONArray();
    for(e in events){
      var temp := JSONObject();
      var subscribed := e in securityContext.principal.subscribedTo;
      temp.put("ID",e.id);
      temp.put("name",e.name);
      temp.put("shortDescription",e.shortDescription);
      temp.put("schedule",e.schedule.name);
      temp.put("subscribed",subscribed);
      eventsJson.put(temp);
    }
    msg.put( "events", eventsJson );
    msg.put( "message", "OK" );
  }
  else {
    msg.put( "message", "ERR" );
  }
  return msg;
}

service api_event(eventid :String){
  var msg := JSONObject();
  if( getHttpMethod() == "GET" ) {
    log("Executing GET api_event");
    var events := from Event as e where e.id = ~eventid.parseUUID();

	  var e_json := JSONObject();
	  var e := events[0];
	  var subscribed := e in securityContext.principal.subscribedTo;
    var closeSubscribtionsDate := e.referencePoint.addDays(-1 * e.closeSubscribtions);

	  e_json.put("ID",e.id);
	  e_json.put("name",e.name);
	  e_json.put("shortDescription",e.shortDescription);
	  e_json.put("description",e.description);
	  e_json.put("schedule",e.schedule.name);
	  e_json.put("maxParticipants",e.maxParticipants);
	  e_json.put("subscribed",subscribed);
	  e_json.put("closeSubscribtionsDate",closeSubscribtionsDate.format("yyyy-MM-dd HH:mm:ss Z"));
    msg.put( "event", e_json );
    msg.put( "message", "OK" );
  }
  else {
    msg.put( "message", "ERR" );
  }
  return msg;
}

service api_changesubscription(){
  var msg := JSONObject();
  if( getHttpMethod() == "POST" ) {
    log("Executing POST api_changesubscription");

    var body := readRequestBody();
    var body_json := JSONObject( body );
    var subscription := body_json.getBoolean( "subscription" );
    var eventId := body_json.getString( "eventId" );
    var events := from Event as e where e.id = ~eventId.parseUUID();
	  var e := events[0];

    if(subscription && !(e in securityContext.principal.subscribedTo)){
      securityContext.principal.subscribedTo.add(e);
      securityContext.principal.save();
    }
    
    if(!subscription && (e in securityContext.principal.subscribedTo)){
      securityContext.principal.subscribedTo.remove(e);
      securityContext.principal.save();
    }
    msg.put( "message", "OK" );
  }
  else {
    msg.put( "message", "ERR" );
  }
  return msg;
}


service api_groups(){
  var msg := JSONObject();
  if( getHttpMethod() == "GET" ){
    log("Executing GET api_groups");
    var eventsJson := JSONArray();
    for(eg in securityContext.principal.participatedIn){
      var temp := JSONObject();
      temp.put("ID",eg.id);
      temp.put("name",eg.name);
      temp.put("date",eg.date.toString());
      temp.put("eventName",eg.event.name);
      temp.put("eventShortDescription",eg.event.shortDescription);
      temp.put("eventId",eg.event.id);
      eventsJson.put(temp);
    }
    msg.put( "groups", eventsJson );
    msg.put( "message", "OK" );
  }
  else {
    msg.put( "message", "ERR" );
  }
  return msg;
}

service api_groupparticipants(groupId :String){
  var msg := JSONObject();
  if( getHttpMethod() == "GET" ) {
    log("Executing GET api_group");
    var egs := from EventGroup as eg where eg.id = ~groupId.parseUUID();
	  var eg := egs[0];
    validate(securityContext.principal in eg.participants, "You dont have access to this group");

    var participants := JSONArray();
    for(p  in eg.participants){
      participants.put(userToJson(p, true));
    }
    msg.put( "participants", participants );
    msg.put( "message", "OK" );
  }
  else {
    msg.put( "message", "ERR" );
  }
  return msg;
}

service api_friends(){
  var msg := JSONObject();
  if( getHttpMethod() == "GET" ) {
    log("Executing GET api_friends");
    var friends := getFriends();

    var friendsJson := JSONArray();
    for(f in friends){
      friendsJson.put(userToJson(f, true));
    }
    msg.put("friends",friendsJson);
    msg.put( "message", "OK" );
  }
  else {
    msg.put( "message", "ERR" );
  }
  return msg;
}

service api_match(){
  var msg := JSONObject();
  if( getHttpMethod() == "GET" ) {
    log("Executing GET api_match");
    var u := getRandomUserForMatch(securityContext.principal);
    if(u==null){
      msg.put( "message", "NOUSER" );
    }
    else{
      msg.put("match", userToJson(u, false));
      msg.put( "message", "OK" );
    }
  }
  else if(getHttpMethod() == "POST"){
    log("Executing POST api_match");
    var body := readRequestBody();
    var body_json := JSONObject( body );
    var username := body_json.getString( "username" );
    var reaction := body_json.getBoolean( "reaction" );

    var users := from User as u where u.username = ~username;
    var user := users[0];
    if(reaction){
      securityContext.principal.matchedUsers.add(user);
    securityContext.principal.save();
    }
    else{
      securityContext.principal.dismatchedUsers.add(user);
    securityContext.principal.save();
    }
    sendMatchedEmailIfMatched(securityContext.principal, user);
    msg.put( "message", "OK" );
  }
  else {
    msg.put( "message", "ERR" );
  }
  return msg;
}

service api_message(username: String){
  var msg := JSONObject();
  var users := from User as u where u.username = ~username;
  var user := users[0];
  validate(canSeeUser(securityContext.principal, user), "you can't chat with this user");
  if( getHttpMethod() == "GET" ) {
    log("Executing GET api_message");
    var messages:= getMessages(securityContext.principal, user);
    var messages_json := JSONArray();
    for(m in messages){
      messages_json.put(messageToJson(m));
    }
    msg.put("messages", messages_json);
    msg.put( "message", "OK" );
  }
  else if(getHttpMethod() == "POST"){
    log("Executing POST api_message");
    var body := readRequestBody();
    var body_json := JSONObject( body );
    var message := body_json.getString( "message" );

    var message_entity := Message{
      from:=securityContext.principal
      to:=user
      timestamp:=now()
      content := message
    };
    message_entity.save();
    msg.put( "message", "OK" );
  }
  else {
    msg.put( "message", "ERR" );
  }
  return msg;
}


access control rules
  rule page userlogin(){ true }
  rule page api_logout(){ loggedIn() }
  rule page api_register(){ true }
  rule page api_me(){ loggedIn() }
  rule page api_profile() { loggedIn() }
  rule page api_changePassword() {loggedIn()}
  rule page api_interests() {loggedIn()}
  rule page api_make_interests() {loggedIn()}
  rule page api_events() {loggedIn()}
  rule page api_event(event_id :String) {loggedIn()}
  rule page api_changesubscription() {loggedIn()}
  rule page api_groups() {loggedIn()}
  rule page api_groupparticipants(groupId :String) {loggedIn()}
  rule page api_friends() {loggedIn()}
  rule page api_match() {loggedIn()}
  rule page api_contact() {loggedIn()}
  rule page api_message(username: String) {loggedIn()}
  