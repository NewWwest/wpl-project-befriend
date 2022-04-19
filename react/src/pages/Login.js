import { React, useState } from "react";
import { observer } from "mobx-react";
import { useNavigate } from "react-router-dom";

function LoginComponent(context){
  const navigate = useNavigate();
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");

  const doLogin = (event) => {
    event.preventDefault();
    context.login(username, password).then(x => navigate("/"));
  }

  return (
    <div className="card mt-3">
      <div className="card-body">
        <form  onSubmit={doLogin}>
          <label className="row col-12">
            <p className="col-6 col-md-2 col-lg-1" >
              Username:
            </p>
            <input type="text" className="col-4" name="username" value={username} onChange={(e) => setUsername(e.target.value)} />
          </label>
          <label className="row col-12">
          <p className="col-6 col-md-2 col-lg-1" >
            Password:
          </p>
          <input type="password" className="col-4" name="password" value={password} onChange={(e) => setPassword(e.target.value)} />
          </label>
          <input type="submit" className="btn btn-primary d-block" value="Login"/>
        </form>
      </div>
    </div>
  );
}




const Login = observer(({ context }) => LoginComponent(context))
export default Login;