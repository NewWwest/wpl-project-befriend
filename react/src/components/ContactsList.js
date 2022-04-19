import React from 'react';
import { observer } from "mobx-react";

function ContactsListComponent(context, contacts){
  return (
    <div>
      <h5>Contacts:</h5>
        <ul>
        {  contacts && contacts.length !== 0 ? 
            contacts.map((c, i) =>
                <li key={i} className="row col-12 m-1">
                    <span className='badge-info text-center col-6 col-md-3 col-lg-2'>{c.contactType}:</span>
                    <span className='border border-secondary mr-2 col-6 col-md-3 col-lg-2'>{c.contactValue}</span>
                </li>
            )
            :
          <>Not contacts yet</>
        }
        </ul>
    </div>
  );
}

const ContactsList = observer(({ context, contacts }) => ContactsListComponent(context, contacts))
export default ContactsList;
