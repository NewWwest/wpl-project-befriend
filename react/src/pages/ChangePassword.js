import { useState } from "react";
import React from 'react';
import { observer } from "mobx-react";

function ChangePasswordComponent(context){
  const [oldPassword, setOldPassword] = useState("");
  const [password, setPassword] = useState("");
  const [confirm, setconfirm] = useState("");

  const doChangePassword = (event)=> {
    event.preventDefault();
    context.changePassword(oldPassword, password, confirm);
  }

  return (
    <div>
    <form onSubmit={doChangePassword}>
      <label className="row col-12">
        <p className="col-6 col-sm-4 col-lg-2" >
          Old Password:
        </p>
        <input type="password" className="col-4" name="oldPassword" value={oldPassword} onChange={(e) => setOldPassword(e.target.value)} />
      </label>
      <label className="row col-12">
        <p className="col-6 col-sm-4 col-lg-2" >
          Password:
        </p>
        <input type="password" className="col-4" name="password" value={password} onChange={(e) => setPassword(e.target.value)} />
      </label>
      <label className="row col-12">
        <p className="col-6 col-sm-4 col-lg-2" >
          Confirm password:
        </p>
        <input type="password" className="col-4" name="confirm" value={confirm} onChange={(e) => setconfirm(e.target.value)} />
      </label>
      <input type="submit" value="Submit" />
      {password === confirm ?"":
        <p className="text-danger">
          Passwords don't match!
        </p>
      }
    </form>
    </div>
  );
}

const ChangePassword = observer(({ context }) => ChangePasswordComponent(context))
export default ChangePassword;