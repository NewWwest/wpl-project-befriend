import { Link } from "react-router-dom";
import React from 'react';
import { observer } from "mobx-react";


function HomeComponent(context) {
  return (
  <>
    <div className="m-3">
    <h1>"Befriend!"</h1>
    <div>"BeFriend is a app that will allow you to connect with people in your area and build up your social life!"</div>
    { 
      !context.isLoggedIn ? "" :
      <>
        <div className="mb-2">
          <h3 className="d-inline-block align-middle mr-2">"Find new people:"</h3>
          <Link className="btn btn-primary align-middle" to="/match">Let's go!</Link>
        </div>
        <div>
          <h3 className="d-inline-block align-middle mr-2">"See organized events:"</h3>
          <Link className="btn btn-primary align-middle" to="/events">Let's go!</Link>
        </div>
      </>
    }
    {
      context.isLoggedIn ? "" :
      <>
      <div className="mb-2">
        <h3 className="d-inline-block align-middle mr-2">"Login to use the portal!"</h3>
        <Link className="btn btn-primary align-middle" to="/login">Login</Link>
      </div>
      <div>
        <h3 className="d-inline-block align-middle mr-2">"You don't have a account?"</h3>
        <Link className="btn btn-primary align-middle" to="/register">Register</Link>
      </div>
      </>
    }
    </div>
  </>
  );
}

const Home = observer(({ context }) => HomeComponent(context))
export default Home;

