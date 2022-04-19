import { React } from "react";
import { observer } from "mobx-react";
import  InterestPicker  from "../components/InterestPicker";
import  InterestList  from "../components/InterestList";
import  ContactsForm  from "../components/ContactsForm";
import  ContactsList  from "../components/ContactsList";


function ProfileComponent(context) {
  context.getProfile();
  context.getInterest();

  const saveProfile = (evt) => {
    evt.preventDefault();
    context.saveProfile();
  }

  return (
    <div>
      <div>
        <img alt="" style={{width: '5em', height:'5em'}} className='d-inline' src="/default_profile_picture.jpg"/>
        <h1 className='d-inline align-middle'>Profile</h1>
      </div>
      <p>Change how others see you in the system</p>
      <div className="card mt-3">
        <div className="card-body">
          <h5 className="card-title">Basic information</h5>
        
          <form  onSubmit={saveProfile}>
            <label className="row col-12">
              <p className="col-6 col-md-2 col-lg-1" >
                Name:
              </p>
              <input type="text" className="col-4" name="name" value={context.profile?.name} onChange={(e) => {context.profile.name = e.target.value}}/>
            </label>
            <label className="row col-12">
              <p className="col-6 col-md-2 col-lg-1" >
                Surname:
              </p>
              <input type="text" className="col-4" name="surname" value={context.profile?.surname} onChange={(e) => {context.profile.surname = e.target.value}}/>
            </label>
            <label className="row col-12">
              <p className="col-6 col-md-2 col-lg-1" >
              Age:
              </p>
              <input type="number" className="col-4" name="age" value={context.profile?.age} onChange={(e) => {context.profile.age = e.target.value}}/>
            </label>
            <label className="row col-12">
              <p className="col-6 col-md-2 col-lg-1" >
              Gender:
              </p>
              <select name="gender" className="col-4" value={context.profile ? context.profile.gender : undefined }  onChange={(e) => {context.profile.gender = e.target.value}}>
                <option value="Male">Male</option>
                <option value="Female">Female</option>
                <option value="Other">Other</option>
              </select>
            </label>
              <input type="submit" className="btn btn-primary d-block" name="submit" value="Submit"/>
            </form>
        </div>
      </div>
      <div className="card mt-3">
        <div className="card-body">
          <h5 className="card-title">Contacts</h5>
            <ContactsForm context={context}></ContactsForm>
          <ContactsList context={context} contacts={context.profile?.contacts}></ContactsList>
        </div>
      </div>
      <div className="card mt-3">
        <div className="card-body">
          <h5 className="card-title">Hobbys</h5>
        <div>
          <InterestPicker context={context}></InterestPicker>
        </div>
        <div>
          <InterestList interests={context.profile?.interests}></InterestList>
        </div>
        </div>
      </div>
    </div>
  );
}

const Profile = observer(({ context }) => ProfileComponent(context))
export default Profile;