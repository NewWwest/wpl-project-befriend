import { Outlet, Link } from "react-router-dom";
import Button from 'react-bootstrap/Button';
import React from 'react';
import { observer } from "mobx-react"
import { useNavigate } from "react-router-dom";

const LayoutComponent = (context)  => {
  const navigate = useNavigate();
  const doLogout = () => {
    context.logout().then(x => navigate("/"));
  }

  return (
    <>
<div>
  <nav className="navbar navbar-expand-lg navbar-light">
    <Link className="navbar-brand" to="/">&#128029;Friend</Link>
    
    <button className="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
      <span className="navbar-toggler-icon"></span>
    </button>
    
    <div className="collapse navbar-collapse" id="navbarNav">
      {
        !context.isLoggedIn ? "" : 
        <>
          <ul className="navbar-nav mr-auto">
            <li className="nav-item">
              <Link className="nav-link" to="/profile">Profile</Link>
            </li>
            <li className="nav-item">
              <Link className="nav-link" to="/events">My subscriptions</Link>
            </li>
            <li className="nav-item">
              <Link className="nav-link" to="/myGroups">My groups</Link>
            </li>
            <li className="nav-item">
              <Link className="nav-link" to="/friends">Friends</Link>
            </li>
            <li className="nav-item">
              <Link className="nav-link" to="/match">Match new people</Link>
            </li>
          </ul>
          <ul className="navbar-nav">
            <li className="navbar-text d-flex justify-content-end">
              "logged in as: " {context.username}
            </li>
            <li className="navbar-text d-flex justify-content-end pl-2">
              <Button onClick={doLogout}>
                Logout
              </Button>
            </li>
          </ul>
        </>
      }
      {
        context.isLoggedIn ? "" :
        <>
          <ul className="navbar-nav mr-auto">
          </ul>
          <ul className="navbar-nav">
            <li className="nav-item">
              <Link className="nav-link" to="/register">Register</Link>
            </li>
            <li className="nav-item">
              <Link className="nav-link" to="/login">Login</Link>
            </li>
          </ul>
        </>
      }
    </div>
  </nav>
  </div>

  {!context.error? "":
      <div className="card m-1">
        <div className="card-body row">
          <p className="text-danger">{context.error}</p>
        </div>
      </div>
  }

      <div className="card m-1">
        <div className="card-body">
          <Outlet />
        </div>
      </div>

    <footer>
      <Link to="/about" className="ml-2 mr-2">About</Link> 
      <Link to="/contact" className="ml-2 mr-2">Contact</Link>
      {
        (context.isPartner || context.isAdmin) ? <Link to="/addEvent" className="ml-2 mr-2">Add Event</Link> : ""
      }
      {
        context.isLoggedIn ? <Link to="/changePassword" className="ml-2 mr-2">Change Password</Link> : ""
      }
    </footer>
    </>
  );
}

const Layout = observer(({ context }) => LayoutComponent(context))
export default Layout;
