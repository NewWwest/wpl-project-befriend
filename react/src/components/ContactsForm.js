import React from 'react';
import { observer } from "mobx-react";

function ContactsFormComponent(context){
  const addContact = (evt) =>{
    evt.preventDefault();
    context.addContact(context.newContact);
  }

  return (<>
    <div>
      <form onSubmit={addContact}>
        <label className="row col-12">
          <p className="col-6 col-md-2 col-lg-1" >
          Contact Type:
          </p>
          <select name="type" className="col-4" value={context.newContact.contactType}  onChange={(e) => {context.newContact.contactType = e.target.value}}>
            <option value="WhatsAppContactType">Whats App</option>
            <option value="PhoneContactType">Phone number</option>
            <option value="FacebookContactType">Facebook</option>
            <option value="InstagramContactType">Instagram</option>
          </select>
        </label>
        <label className="row col-12">
          <p className="col-6 col-md-2 col-lg-1" >
            Value:
          </p>
          <input type="text" className="col-4" name="type" value={context.newContact.contactValue} onChange={(e) => {context.newContact.contactValue = e.target.value}}/>
        </label>
        <input type="submit" className="btn btn-primary d-block" name="submit" value="Add new contact"/>
      </form>
    </div>
  </>
  );
}

const ContactsForm = observer(({ context }) => ContactsFormComponent(context))
export default ContactsForm;





