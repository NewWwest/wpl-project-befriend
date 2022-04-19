import { BrowserRouter, Routes, Route } from "react-router-dom";
import Layout from "./Layout";
import About from "./pages/About";
import Contact from "./pages/Contact";
import Home from "./pages/Home";
import Login from "./pages/Login";
import Register from "./pages/Register";
import ChangePassword from "./pages/ChangePassword";
import Profile from "./pages/Profile";
import Events from "./pages/Events";
import Event from "./pages/Event";
import MyGroups from "./pages/MyGroups";
import Group from "./pages/Group";
import Friends from "./pages/Friends";
import Friend from "./pages/Friend";
import Match from "./pages/Match";
import {globalContextStore} from "./services/ContextStore";
import {eventsContext} from "./services/EventsContextStore";


function App() {
  globalContextStore.initialize();
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Layout context={globalContextStore}/>}>
          <Route index element={<Home context={globalContextStore}/>} />
          <Route path="about" element={<About />} />
          <Route path="contact" element={<Contact />} />
          <Route path="login" element={<Login context={globalContextStore}/>} />
          <Route path="register" element={<Register context={globalContextStore}/>} />
          <Route path="changePassword" element={<ChangePassword context={globalContextStore}/>} />
          <Route path="profile" element={<Profile context={globalContextStore}/>} />
          <Route path="events" element={<Events eventsContext={eventsContext}/>} />
          <Route path="event/:id" element={<Event eventsContext={eventsContext}/>} />
          <Route path="mygroups" element={<MyGroups eventsContext={eventsContext}/>} />
          <Route path="group/:id" element={<Group context={globalContextStore} eventsContext={eventsContext}/>} />
          <Route path="friends" element={<Friends context={globalContextStore}/>} />
          <Route path="friend/:username" element={<Friend context={globalContextStore}/>} />
          <Route path="match" element={<Match context={globalContextStore}/>} />
        </Route>
      </Routes>
    </BrowserRouter>
  );
}

export default App;
