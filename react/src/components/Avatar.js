import React from 'react';
import { observer } from "mobx-react";
import { Link } from "react-router-dom";

function AvatarComponent(context, user){

    const renderIfNotNull = (user,context)=>{
        if(user.username === context.username){
            return <Link to="/profile" className="card m-1">
                <div className="card-body">
                    <img alt="" style={{width: '5em', height:'5em'}}  src="/default_profile_picture.jpg"/>
                <span>You</span>
                </div>
            </Link>
            }
        else {
            var showUsername = user.name == null || user.name === "" || user.surname == null || user.surname === "";
            return <Link to={`/friend/${encodeURIComponent(user.username)}`} className="card m-1">
            <div className="card-body">
            <img alt="" style={{width: '5em', height:'5em'}}  src="/default_profile_picture.jpg"/>
            {
                showUsername?
                    <span>{user.username}</span> 
                :
                    <span>{user.name} {user.surname}</span>
            }
            </div>
            </Link>
        }
    }
  return (
    <div>
      {
          user ?renderIfNotNull(user, context):"Not A User"
      }
    </div>
  );
}

const Avatar = observer(({ context, user }) => AvatarComponent(context, user))
export default Avatar;
