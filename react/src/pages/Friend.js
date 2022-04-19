import { React } from "react";
import {  useParams} from "react-router-dom";
import { observer } from "mobx-react";
import Avatar from "../components/Avatar";
import InterestList from "../components/InterestList";
import ContactsList from "../components/ContactsList";
import Chat from "../components/Chat";

function FriendComponent(context){
  context.getFriends();
  let { username } = useParams();
  var user = context.getFriend(username);

  return (
    <div>
      <Avatar context={context} user={user} ></Avatar>
      <InterestList interests={user?.interests}></InterestList>
      <ContactsList context={context} contacts={user?.contacts}></ContactsList>
      <Chat context={context} user={user}></Chat>
    </div>
  );
}


const Friend = observer(({ context }) => FriendComponent(context))
export default Friend;