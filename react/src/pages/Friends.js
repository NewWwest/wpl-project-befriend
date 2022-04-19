import { React } from "react";
import { observer } from "mobx-react";
import { Link } from "react-router-dom";
import Avatar from "../components/Avatar";

function MyGroupsComponent(context){
  context.getFriends();

  return (
    <div>
        Here you can see all people you successfully matched with!
        <div>
            {
                !context.friends || context.friends.length === 0 ? 
                <>
                 <p>You have no friends right now. :c </p>
                 <p>Meet new people <Link to="/match">here!</Link></p>
                </> 
                : context.friends.map((f,i)=>
                <Avatar key={i} context={context} user={f}>
                </Avatar>
                )
            }
        </div>
    </div>
  );
}


const MyGroups = observer(({ context }) => MyGroupsComponent(context))
export default MyGroups;