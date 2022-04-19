import { useState } from "react";
import React from 'react';
import { observer } from "mobx-react";
import { useNavigate } from "react-router-dom";

function RegisterComponent(context){
  const navigate = useNavigate();
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [confirm, setconfirm] = useState("");

  const doRegister = (event)=> {
    event.preventDefault();
    context.register(username, password, confirm).then(x => navigate("/"));
  }

  return (
    <div>
    <form onSubmit={doRegister}>
      <label className="row col-12">
        <p className="col-6 col-md-2 col-lg-1" >
          Username:
        </p>
        <input type="text" name="username" value={username} onChange={(e) => setUsername(e.target.value)} />
      </label>
      <label className="row col-12">
        <p className="col-6 col-md-2 col-lg-1" >
          Password:
        </p>
        <input type="password" name="password" value={password} onChange={(e) => setPassword(e.target.value)} />
      </label>
      <label className="row col-12">
        <p className="col-6 col-md-2 col-lg-1" >
          Confirm password:
        </p>
        <input type="password" name="confirm" value={confirm} onChange={(e) => setconfirm(e.target.value)} />
      </label>
      <input type="submit" className="btn btn-primary d-block"  value="Register" />
      {password === confirm ?"":
        <p className="text-danger">
          Passwords don't match!
        </p>
      }
      
    </form>
    </div>
  );
}

const Register = observer(({ context }) => RegisterComponent(context))
export default Register;
