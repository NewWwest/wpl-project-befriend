module dbmodel

entity User {
  username : Email(id, name, iderror="User with this username exists", idemptyerror = "username required")
  password : Secret(validate(password.length() >= 8, "Password needs to be at least 8 characters")) 
  profile : Profile
  subscribedTo : {Event}
  participatedIn: {EventGroup}
  matchedUsers: {User}
  dismatchedUsers: {User}
  roles: {Role}
  sentMessages: {Message}
  receivedMessages: {Message}
}


entity Profile {
  user: User (inverse = profile)
  name : String
  surname : String
  age: String
  gender: Gender
  profilePicture: Image
  contacts: {ContactInfo}
  interests: {Interest}
}

entity Interest {
  name : String
  profiles: {Profile}(inverse = interests)
}

entity Role {
  name : String
  users: {User}(inverse = roles)
}

entity ContactInfo {
  contactType : ContactType
  contactValue: String
  profile: Profile(inverse = contacts)
}

entity Event {
  name : String
  shortDescription : String
  description : String
  maxParticipants : Int
  schedule : Schedule
  referencePoint: DateTime
  closeSubscribtions: Int
  processedAtLeastOnce: Bool
  subscribers : {User}(inverse = subscribedTo)
  groups: {EventGroup}
}

entity EventGroup {
  name : String
  date : DateTime
  event: Event(inverse=groups)
  participants : {User}(inverse = participatedIn)
}

entity Message {
  from : User(inverse = sentMessages)
  to : User(inverse = receivedMessages)
  content: String
  timestamp: DateTime
}

enum Schedule {
  daily("daily"),
  weekly("weekly"),
  biweekly("biweekly"),
  monthly("monthly"),
  never("never")
}

enum ContactType {
  WhatsAppContactType("Whats App"),
  PhoneContactType("Phone number"),
  FacebookContactType("Facebook"),
  InstagramContactType("Instagram")
}

enum Gender {
  maleGender("Male"),
  femaleGender("Female"),
  otherGender("Other")
}

init {
  var defaultPassword: Secret := "123";
  var adminuser := User { 
    username := "admin"
    password := defaultPassword.digest()
    profile := Profile {
      name := "Admin"
      surname := "Admin"
      age := "100"
      gender:= otherGender
    }
    roles := {AdminRole}
  };
  adminuser.save();
  
  var testUser := User{
    username := "test@example.com"
    password := defaultPassword.digest()
    profile := Profile {
      name := "John"
      surname := "Tester"
      age := "25"
      gender:= maleGender
    }
    roles := {StudentRole}
  };
  testUser.save();
  
  var testUser2 := User{
    username := "test2@example.com"
    password := defaultPassword.digest()
    profile := Profile {
      name := "Maria"
      surname := "Testova"
      age := "25"
      gender:= femaleGender
    }
    roles := {StudentRole}
  };
  testUser2.save();
  
  var testUser3 := User{
    username := "test3@example.com"
    password := defaultPassword.digest()
    profile := Profile {
      name := "Test"
      surname := "Example"
      age := "25"
      gender:= femaleGender
    }
    roles := {StudentRole}
  };
  testUser3.save();
  
  var OnlineWednesdays := Event{
    name := "Online Wednesdays"
    description := "Online Wednesdays for gaming and chatting and not only"
    shortDescription := "Online Wednesdays for gaming and chatting"
    maxParticipants := 2
    schedule := weekly
    referencePoint := DateTime("05/01/2022 00:01") // a Wednesday
  };
  OnlineWednesdays.save();
  
  var CityFridays := Event{
    name := "City Fridays"
    maxParticipants := 5
    description := "City Fridays for going out not only"
    shortDescription := "City Fridays for going out"
    description := "todo" 
    schedule := weekly
    referencePoint := DateTime("07/01/2022 00:01") // a Friday
  };
  CityFridays.save();
  
  var ParkSaturdays := Event{
    name := "Park Saturdays"
    maxParticipants := 10
    description := "Park Saturdays for a nice hike during the day and not only"
    shortDescription := "Park Saturdays for a nice hike during the day"
    schedule := weekly
    referencePoint := DateTime("08/01/2022 00:01") // a Saturday
  };
  ParkSaturdays.save();
  
  var ProjectSearch := Event{
    name := "Project Search"
    description := "Find your next project and not only"
    shortDescription := "Find your next project!"
    maxParticipants := 200
    schedule := monthly
    referencePoint := DateTime("01/01/2022 00:01")
  };
  ProjectSearch.save();
  testUser.subscribedTo.add(OnlineWednesdays);
  testUser.save();
  testUser2.subscribedTo.add(OnlineWednesdays);
  testUser2.save();
  testUser3.subscribedTo.add(OnlineWednesdays);
  testUser3.save();

  var ComputerScienceInterest := Interest{
    name := "Computer Science"
  };
  ComputerScienceInterest.save();

  var WebInterest := Interest{
    name := "Web programming"
  };
  WebInterest.save();

  var HtmlInterest := Interest{
    name := "Html"
  };
  HtmlInterest.save();
}