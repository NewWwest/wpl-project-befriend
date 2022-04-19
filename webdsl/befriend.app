application befriend

imports dbmodel
imports core
imports api

var AdminRole := Role{
  name:="admin"
}

var PartnerRole := Role{
  name:="partner"
}

var StudentRole := Role{
  name:="student"
}

native class nativejava.JavaProxy as JavaProxyClass : SuperClass {
  constructor()
  static j_shuffle(List<User>): List<User> 
  static j_uuid(): String
}


template layout() {
  includeCSS("styles.css")
  includeCSS("bootstrap.min.css")
  <div>
    <nav class="navbar navbar-expand-lg navbar-light">
      <a class="navbar-brand" href="~navigate(root())">rawoutput("&#128029;")"Friend"</a>
      
      <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>
      
      <div class="collapse navbar-collapse" id="navbarNav">
      if(loggedIn()){
      <ul class="navbar-nav mr-auto">
        <li class="nav-item">
          <a class="nav-link" href="~navigate(profile())">
           "My profile"
          </a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="~navigate(events())">
           "My subscriptions"
          </a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="~navigate(myGroups())">
           "My groups"
          </a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="~navigate(friends())">
           "Friends"
          </a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="~navigate(match())">
           "Match new people"
          </a>
        </li>
      </ul>
      <ul class="navbar-nav">
        <li class="navbar-text d-flex justify-content-end">
          "logged in as: " ~securityContext.principal.username
        </li>
        <li class="navbar-text d-flex justify-content-end pl-2">
          logout
        </li>
      </ul>
      }
      else {
      <ul class="navbar-nav mr-auto">
      </ul>
      <ul class="navbar-nav">
        <li class="nav-item">
          <a class="nav-link" href="~navigate(register())">
           "Register"
          </a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="~navigate(login())">
           "Login"
          </a>
        </li>
      </ul>
      }
      </div>
    </nav>
    </div>
    
      <div class="card m-1">
        <div class="card-body">
          elements
        </div>
      </div>
    
    <footer>
      <a class="ml-2 mr-2" href="~navigate(about())">
        "About"
      </a>
      <a class="ml-2 mr-2" href="~navigate(contact())">
        "Contact"
      </a>
      if(isPartner() || isAdmin()){
        <a class="ml-2 mr-2" href="~navigate(addEvent())">
          "Add Event"
        </a>
      }
      if(isAdmin()){
        <a class="ml-2 mr-2" href="~navigate(admin_users())">
          "(ADMIN) Users"
        </a>
        <a class="ml-2 mr-2" href="~navigate(admin_events())">
          "(ADMIN) Events"
        </a>
        <a class="ml-2 mr-2" href="~navigate(admin_eventsgroups())">
          "(ADMIN) Groups"
        </a>
      }
      if(loggedIn()){
        <a class="ml-2 mr-2" href="~navigate(changePassword())">
          "Change Password"
        </a>
      }
    </footer>
}

page root {
  layout() {
    <div class="m-3">
      <h1>"Befriend!"</h1>
      <div>"BeFriend is a app that will allow you to connect with people in your area and build up your social life!"</div>
      if(loggedIn()){
        <div class="mb-2">
          <h3 class="d-inline-block align-middle mr-2">"Find new people:"</h3>
          <a class="btn btn-primary align-middle" href="~navigate(match())">"Let's go!"</a>
        </div>
        <div>
          <h3 class="d-inline-block align-middle mr-2">"See organized events:"</h3>
          <a class="btn btn-primary align-middle" href="~navigate(events())">"Let's go!"</a>
        </div>
      }
      else {
        <div class="mb-2">
          <h3 class="d-inline-block align-middle mr-2">"Login to use the portal!"</h3>
          <a class="btn btn-primary align-middle" href="~navigate(login())">"Login"</a>
        </div>
        <div>
          <h3 class="d-inline-block align-middle mr-2">"You don't have a account?"</h3>
          <a class="btn btn-primary align-middle" href="~navigate(register())">"Register"</a>
        </div>
      }
    </div>
  }
}

page about {
  layout() {
    <div>
      <h2>"About"</h2>
      <p>"The BeFriend project was created to simplify meeting new people. Especially when working or studying in a remote setting one simply lack the opportunity to create new contacts."</p>
      <p>"BeFriend helps you to do that in two ways:"</p>
      <div class="card">
        <div class="card-body">
          <h5 class="card-title">"Friend matching"</h5>
          <p class="card-text">"On BeFriend you can browse people registerrred in the system. "
          "If you both decide that you fit each other, you will receive the other persons contact information. "
          "Just so you know: there is no limit on people you look through :)"</p>
        </div>
      </div>
      <div class="card">
        <div class="card-body">
          <h5 class="card-title">"Events"</h5>
          <p class="card-text">"On BeFriend you can look through events organized in your neighborhood. "
          "Moreover some Events repeated periodically and once subscribed, you will be included in all events from that series!"</p>
        </div>
      </div>
      <p>"Project was created by Andrzej Westfalewicz for CS4275 Web Programming Languages course on TU Delft"</p>
    </div>
  }
}
page contact {
  layout() {
    <div>
      <h2>"About"</h2>
      <p>"When hosting this project make sure you include your contact information here"</p>
      <p>"You can check out the code of this project here: " <a href="https://github.com/NewWwest/wpl-project-befriend">"https://github.com/NewWwest/wpl-project-befriend"</a></p>
    </div>
  }
}

page register {
  var newUser := User{}
  var confirmPass: Secret
  
  layout(){
  form {
    <table>
      <tr>labelcolumns( "Email:" ){ input( newUser.username ) }</tr>
      <tr>labelcolumns( "Password:" ){ input( newUser.password ) }</tr>
      <tr>labelcolumns( "Confirm Password:" ){ input( confirmPass ) }</tr>
    </table>
    submit doRegister()[class="btn btn-primary"]{ "Register" }
    }
  }

  action doRegister(){
    validate(newUser.password == confirmPass, "Passwords do not match");

    var p: Profile := Profile{user:=newUser};
    newUser.password := newUser.password.digest();
    newUser.profile := p;
    newUser.roles := {StudentRole};
    newUser.save();
    return root();
  }
}

page changePassword() {
  var oldPassword : Secret
  var password : Secret
  var confirmPassword: Secret
  
  layout(){
  form {
    <table>
      <tr>labelcolumns( "Old Password:" ){ input( oldPassword ) }</tr>
      <tr>labelcolumns( "New Password:" ){ input( password ) }</tr>
      <tr>labelcolumns( "Confirm Password:" ){ input( confirmPassword ) }</tr>
    </table>
    submit changePass()[class="btn btn-primary"]{ "Change Password" }
    }
  }

  action changePass(){
    validate(authenticate( securityContext.principal.username, oldPassword ), "Old password is invalid." );
    validate(password == confirmPassword, "Passwords do not match");

    securityContext.principal.password := password.digest();
    securityContext.principal.save();
    return root();
  }
}

override page login {
  var username: String
  var pass: Secret
  var stayLoggedIn := false
  
  layout(){
    form {
      <table>
        <tr>labelcolumns( "Username:" ){ input( username ) }</tr>
        <tr>labelcolumns( "Password:" ){ input( pass ) }</tr>
        <tr>labelcolumns( "Stay logged in:" ){ input( stayLoggedIn ) }</tr>
      </table>
      submit signinAction()[class="btn btn-primary"]{ "Login" }
    }
  }

  action signinAction(){
    getSessionManager().stayLoggedIn := stayLoggedIn;
    validate(authenticate( username, pass ), "The login credentials are invalid." );
    return root();
  }
}

override template logout {
  form {
    submitlink signoffAction(){ "Logout" }
  }
  action signoffAction() {
    logout();
    return root();
  }
}

page profile() {
  var u: User := securityContext.principal
  var c: ContactInfo := ContactInfo{}
  var i: Interest := Interest{}
  var i_new: Interest := Interest{}
  
  layout() {
    <script>
    function showNewInterestForm() {
      var newInterestForm = document.getElementById("newInterestForm");
      console.log(newInterestForm);
      newInterestForm.classList.remove("d-none");
    }
    </script>
    <h1>"Profile"</h1>
    <p>"Change how others see you in the system"</p>
      <div class="card mt-3">
        <div class="card-body">
          <h5 class="card-title">"Basic information"</h5>
          <table>
          form {
              if(u.profile.profilePicture==null){
                <img style="width:15em;height:15em" src="/befriend/images/profile_picture.jpg"/>
              }
              else{
                output(u.profile.profilePicture)[style="width:15em;height:15em"]
              }
              <tr>labelcolumns( "Name:" ){ input( u.profile.name ) }</tr>
              <tr>labelcolumns( "Surname:" ){ input( u.profile.surname ) }</tr>
              <tr>labelcolumns( "Age:" ){ input( u.profile.age ) }</tr>
              <tr>labelcolumns( "Gender:" ){ input( u.profile.gender ) }</tr>
              <tr>labelcolumns( "Picture:" ){ input( u.profile.profilePicture ) }</tr>
              <tr><td></td><td>submit doSubmit()[class="btn btn-primary d-block float-right"]{ "Save" }</td></tr>
          }
          </table>
        </div>
    </div>
    
    <div class="card mt-3">
      <div class="card-body">
        <h5 class="card-title">"Contacts"</h5>
        form {
          <fieldset>
          <legend>
            output( "Add new contact:" )
          </legend>
          <table>
          <tr>labelcolumns("Select contact type:"){ input(c.contactType) }</tr>
          <tr>labelcolumns("contactValue:"){ input(c.contactValue) }</tr>
          <tr><td></td><td>submit addContact()[class="btn btn-primary d-block float-right"]{ "Add" }</td></tr>
          </table>
          </fieldset>
        }
         <legend>
           output( "My contacts" )
         </legend>
         <ul>
         for(contact:ContactInfo in u.profile.contacts){
         <li>
          <span>output(contact.contactType) ": " ~contact.contactValue</span>
           form{
             submit deleteContact(contact)[class="btn btn-danger d-inline-block ml-2"] { "delete" }
           }
         </li>
         }
         </ul>
      </div>
    </div>
  
    <div class="card mt-3">
      <div class="card-body">
        <h5 class="card-title">"Hobbies"</h5>
        form {
          <fieldset>
          <legend>
            output( "Add new hobby:" )
          </legend>
          <table>
          <tr>labelcolumns("interest:"){ input(i) }</tr>
          <tr><td></td><td>submit addInterest()[class="btn btn-primary d-block float-right"]{ "Add" }</td></tr>
          </table>
          </fieldset>
        }
        <div>"Can't see your hoobby?" <button onclick="showNewInterestForm()" class="btn btn-primary m-1">"Add one!"</button></div>
        <div id="newInterestForm" class="d-none">
          form{
              labelcolumns("Name:"){ input(i_new.name) }
              submit addNewInterest()[class="btn btn-primary d-block float-right"]{ "Add new interest" }
          }
        </div>
         <legend>
           output( "My Hobbies" )
         </legend>
         <ul>
          for(interest:Interest in u.profile.interests){
            <li>
              <span>output(interest)</span>
              form{
                submit action {
                  if(interest != null){
                    interest.profiles.remove(u.profile);
                    u.profile.interests.remove(interest);
                }
                }[class="btn btn-danger d-inline-block ml-2"]{ "delete" }
              }
            </li>
          }
         </ul>
      </div>
    </div>
  }
  
  action doSubmit(){
    u.profile.save();
  }
  action addContact(){
    c.profile := u.profile;
    c.save();
  }
  action addInterest() {
    u.profile.interests.add(i);
    i.profiles.add(u.profile);
    i.save();
  }
  action deleteContact(contactToRemove:ContactInfo) {
     if(contactToRemove != null){
      contactToRemove.delete();
      u.profile.contacts.remove(contactToRemove);
     }
  }
  
  action addNewInterest() {
    var sameInterest := from Interest as temp_i where temp_i.name=~i_new.name;
    validate(sameInterest == null || sameInterest.length == 0, "This hobby already exists");
    i_new.save();
  }
}

page events() {
  var events := from Event as evnt

  layout(){
    for(i in events){
      <a href="~navigate(event(i))" class="card">
        <div class="card-body">
          <div class="card-title">
            <h5 class="d-inline">~i.name</h5>
            if(i in securityContext.principal.subscribedTo){
              <span class="d-inline float-right">"Subscribed!"</span>
            }
            <small class="card-title d-inline m-1"> output(i.schedule) </small>
          </div>
          <p class="card-text">~i.shortDescription</p>
        </div>
      </a>
     }
  }
}

page addEvent(){
  var evt := Event{}
  layout(){
  form {
    <table>
      <tr>labelcolumns( "Name:" ){ input( evt.name ) }</tr>
      <tr>labelcolumns( "Short Description:" ){ input( evt.shortDescription ) }</tr>
      <tr>labelcolumns( "Description:" ){ input( evt.description ) }</tr>
      <tr>labelcolumns( "Max Participants:" ){ input( evt.maxParticipants ) }</tr>
      <tr>labelcolumns( "Schedule:" ){ input( evt.schedule ) }</tr>
      <tr>labelcolumns( "First occurrence:" ){ input( evt.referencePoint ) }</tr>
      <tr>labelcolumns( "Days before event when subscription is closed:" ){ input( evt.closeSubscribtions ) }</tr>
    </table>
    submit makeEvent()[class="btn btn-primary"]{ "Create Event" }
    }
  }

  action makeEvent(){
    evt.save();
    return root();
  }
}

page admin_users(){
  var allUsers := from User as u
  layout(){
    <table>
    for( u in allUsers){
      <tr>
      <td>~u.username</td>
      <td>form{
        submit deleteUser(u)[class="btn btn-danger"]{ "Delete" }
      }</td>
      <td>form{
        submit switchPartner(u)[class="btn btn-warning"]{
			    if(PartnerRole in u.roles){
			      "Revoke Parner"
			    }
			    else {
			      "Grant Parner"
			    }
        }
      }</td>
      </tr>
    }
    </table>
  }
  action switchPartner(u:User){
    if(PartnerRole in u.roles){
      u.roles.remove(PartnerRole);
    }
    else {
      u.roles.add(PartnerRole);
    }
    u.save();
  }
  action deleteUser(u:User){
    for( r in u.roles){
      r.users.remove(u);
      r.save();
    }
    for( eg in u.participatedIn){
      eg.participants.remove(u);
      eg.save();
    }
    for( e in u.subscribedTo){
      e.subscribers.remove(u);
      e.save();
    }
    for( i in u.profile.interests){
      i.profiles.remove(u.profile);
      i.save();
    }
    for( r in u.roles){
      r.users.remove(u);
      r.save();
    }
    for( c in u.profile.contacts){
      u.profile.contacts.remove(c);
      c.profile :=null;
      c.delete();
    }
    u.profile.delete();
    u.delete();
    return admin_users();
  }
}

page admin_events(){
  var allEvents := from Event as u
  
  layout(){
    <table>
    for( e in allEvents){
      <tr>
      <td>~e.name</td>
      <td>~e.schedule</td>
      <td>
      for(u in e.subscribers){
        <span class="m-1">~u.username</span>
      }
      </td>
      <td>form{
        submit deleteEvent(e)[class="btn btn-danger"]{ "Delete" }
      }</td>
      </tr>
    }
    </table>
  }

  action deleteEvent(e:Event){
    for( u in e.subscribers){
      u.subscribedTo.remove(e);
      u.save();
    }
    for(eg in e.groups){
      for( u in eg.participants){
        u.participatedIn.remove(eg);
        u.save();
      }
      e.groups.remove(eg);
      eg.delete();
    }
    e.delete();
    return admin_eventsgroups();
  }
}

page admin_eventsgroups(){
  var allEventGroups := from EventGroup as eg
  
  layout(){
    <table>
    for( eg in allEventGroups){
      <tr>
      <td>~eg.name</td>
      <td>~eg.date</td>
      <td>
      for(u in eg.participants){
        <span class="m-1">~u.username</span>
      }
      </td>
      <td>form{
        submit deleteEventGroup(eg)[class="btn btn-danger"]{ "Delete" }
      }</td>
      </tr>
    }
    </table>
  }

  action deleteEventGroup(eg:EventGroup){
    for( u in eg.participants){
      u.participatedIn.remove(eg);
      u.save();
    }
    eg.delete();
    return admin_eventsgroups();
  }
}


page event(e: Event) {
  var loggedIn := securityContext.principal
  var isSubscribedTo := e in loggedIn.subscribedTo
  var closeSubscribtionsDate := e.referencePoint.addDays(-1 * e.closeSubscribtions)
  
  layout(){
      <div class="card">
        <div class="card-body">
          <div class="card-title">
            <h5 class="d-inline">~e.name</h5>
            if(isSubscribedTo){
              submit unsubscribe()[class="btn btn-warning d-inline-block ml-2 float-right"]{ "Unsubscribe" }
            }
            else{
              if(closeSubscribtionsDate.after(now())){
                submit subscribe()[class="btn btn-primary d-inline-block ml-2 float-right"]{ "Subscribe" }
              }
              else{
                <span class="text-secondary">"Registration closed"</span>
              }
            }
            <small class="card-title d-inline m-1 float-right"> output(e.schedule) </small>
          </div>
          <p class="card-text">~e.description</p>
        </div>
      </div>
  }
  
  action subscribe(){
    validate(closeSubscribtionsDate.after(now()), "Registration closed");
    e.subscribers.add(loggedIn);
    loggedIn.subscribedTo.add(e);
    e.save();
    loggedIn.save();
  }
  action unsubscribe(){
    validate(closeSubscribtionsDate.after(now()), "Registration closed");
    e.subscribers.remove(loggedIn);
    loggedIn.subscribedTo.remove(e);
    e.save();
    loggedIn.save();
  }
}

template avatar(u:User){ 
  if(u == securityContext.principal) {
    <a href="~navigate(profile())" class="card m-1">
      <div class="card-body">
        if(u.profile == null || u.profile.profilePicture == null){
          <img style="width:5em;height:5em" src="/befriend/images/profile_picture.jpg"/>
        }
        else{
          output(u.profile.profilePicture)[style="width:5em;height:5em"]
        }
       <span>"You"</span>
      </div>
    </a>
  }
  else{
    <a href="~navigate(friend(u))" class="card m-1">
      <div class="card-body">
      if(u.profile == null || u.profile.profilePicture == null){
        <img style="width:5em;height:5em" src="/befriend/images/profile_picture.jpg"/>
      }
      else{
        output(u.profile.profilePicture)[style="width:5em;height:5em"]
      }
      if(u.profile == null || u.profile.name == null || u.profile.name == "" || u.profile.surname == null || u.profile.surname == ""){
        <span>~u.username</span>
      }
      else{
        <span>~u.profile.name " " ~u.profile.surname</span>
      }
      </div>
    </a>
  }
}

page myGroups() {
  var loggedIn := securityContext.principal
  layout(){
    for(eg in loggedIn.participatedIn){
      <a href="~navigate(eventGroup(eg))" class="card">
        <div class="card-body">
          <div class="card-title">
            <h5 class="d-inline">~eg.name</h5>
            <span class="d-inline float-right">~eg.date</span>
          </div>
          <p class="card-text">~eg.event.description</p>
        </div>
      </a>
    }
  }
}

page eventGroup(eg: EventGroup) {
  layout() {
    <h3>~eg.name</h3>
    <p>"Will occur on:" ~eg.date</p>
    <p>"Make sure to contact everyone before the event!"</p>
    for(participant in eg.participants){
      avatar(participant)
    }
  }
}

page match() {
  var user := getRandomUserForMatch(securityContext.principal)
  
  layout(){
    if(user == null){
      <div>"No more users to match with"</div>
    }
    else{
      avatar(user)
      <h4>"Hobbies:"</h4>
      <ul>
      for(inter in user.profile.interests){
        <li>output(inter.name)</li>
      }
      </ul>
      form{
        submit  matchx()[class="btn btn-warning d-inline-block ml-2 float-right"]{ "Match" }
      }
      form{
        submit ignore()[class="btn btn-primary d-inline-block ml-2 float-right"]{ "Next" }
      }
    }
  }
  
  action matchx(){
    securityContext.principal.matchedUsers.add(user);
    securityContext.principal.save();
    sendMatchedEmailIfMatched(securityContext.principal, user);
    return match();
  }
  action ignore(){
    securityContext.principal.dismatchedUsers.add(user);
    securityContext.principal.save();
    return match();
  }
}

page friends() {
  var friends := getFriends()
  layout(){
      <div>"Here you can see all people you successfully matched with!"</div>
      for(u in friends){
        avatar(u)
      }
  }
}

page friend(u: User) {
  layout(){
      avatar(u)
      <div  class="card m-1">
        <div class="card-body">
        if(u.profile == null){
          <p>"This user hasn't configured their profile yet."</p>
        }
        else{
          <p>"Age: " ~u.profile.age</p>
          <p>"Gender: " output(u.profile.gender)</p>
          if(u.profile.interests != null && u.profile.interests.length != 0){
            <h4>"Hobbies:"</h4>
            <ul>
              for(i in u.profile.interests){
                <li><span class="m-1 border border-secondary">~i.name</span></li>
              }
            </ul>
          }
          if(u.profile.contacts != null && u.profile.contacts.length != 0){
            <h4>"Contacts:"</h4>
            <ul>
            for(c in u.profile.contacts){
              <li><span class="m-1 border border-secondary">output(c.contactType) ": " ~c.contactValue</span></li>
            }
            </ul>
          }
        }
        </div>
      </div>
      <div class="card m-1">
        <div class="card-title">"Messages"</div>
        <div class="card-body">
          chat(u)
        </div>
      </div>
  }
}

template chat(secondUser: User) {
  var new_message := Message{}
  placeholder messagesContainer { messages(secondUser) }
  var refresh_id := JavaProxyClass.j_uuid()
  <div>
    form{
      <small>"New message:"</small>
      input(new_message.content)[class="d-block w-100"]
      submit sendMessage()[class="btn btn-primary d-inline-block ml-2 float-right", ajax]{ "Send" }
    }
    form[id="~refresh_id"]{
        submit refresh()[class="btn btn-primary d-inline-block ml-2 float-right", ajax, id = "~refresh_id"]{ "Refresh" }
    }
  </div>
  <script>
      var refreshtimer;
      function setRefreshTimer(){
        clearTimeout(refreshtimer);
        refreshtimer = setTimeout(function() {
          $("#~refresh_id").click();
          setRefreshTimer();
        }, 10000);
      }
      setRefreshTimer();
  </script>
  action sendMessage(){
    new_message.from := securityContext.principal;
    new_message.to := secondUser;
    new_message.timestamp := now();
    securityContext.principal.sentMessages.add(new_message);
    secondUser.receivedMessages.add(new_message);
    new_message.save();
    refresh();
  }
  action refresh(){
    replace(messagesContainer,messages(secondUser));
  }
}

ajax template messages(secondUser: User){
  var messages: List<Message> := getMessages(securityContext.principal, secondUser)
  <div>
    for(m in messages) {
      message(m)
    }
  </div>
}
template message(m:Message) {
  if(m.to == securityContext.principal){
    <div class="row w-100 m-1">
      <div class="border border-secondary rounded p-1 col-9">
        <div class="small">~displayName(m.from) " wrote:"</div>
        <div>~m.content</div>
      </div>
      <div class="col-3">
      </div>
    </div>
  }
  else{
    <div class="row w-100 m-1">
      <div class="col-3">
      </div>
      <div class="border border-secondary rounded p-1 col-9">
        <div class="small">~displayName(m.from) " wrote:"</div>
        <div>~m.content</div>
      </div>
    </div>
  }
}

principal is User with credentials username, password


invoke setupEventGroups() every 1 days

function isAdmin(): Bool {
  return loggedIn() && (AdminRole in securityContext.principal.roles);
}
function isPartner(): Bool {
  return loggedIn() && (PartnerRole in securityContext.principal.roles);
}

access control rules
// public pages:
  rule page root(){ true }
  rule page about(){ true }
  rule page contact(){ true }
  rule page register(){ true }
// main features
  rule page login(){ true }
  rule page changePassword(){ loggedIn()}
  rule page profile(){ loggedIn() }
  rule page events(){ loggedIn() }
  rule page event(e: Event){ loggedIn() }
  rule page eventGroup(eg: EventGroup){ loggedIn() && principal in eg.participants }
  rule page myGroups(){ loggedIn() }
  rule page match(){ loggedIn() }
  rule page friends(){ loggedIn() }
  rule page friend(u: User) {loggedIn() && canSeeUser(principal, u)}
  rule ajaxtemplate messages(u:User){loggedIn() && canSeeUser(principal, u)}
  
// special access
  rule page addEvent(){ isAdmin() || isPartner()}
  rule page admin_users(){isAdmin()}
  rule page admin_eventsgroups(){isAdmin()}
  rule page admin_events(){isAdmin()}
  