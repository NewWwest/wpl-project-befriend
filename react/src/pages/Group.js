import { React } from "react";
import {  useParams} from "react-router-dom";
import { observer } from "mobx-react";
import Avatar  from "../components/Avatar";

function GroupComponent(context, eventsContext){
  let { id } = useParams();
  const group = eventsContext.getGroup(id);
  eventsContext.getGroupParticipants(id);

  const renderParticipant = (part,i) => {
    return <div key={i}>
      <Avatar context={context} user={part}></Avatar>
    </div>
  }

  const renderGroup = (g) => {
    return <>
      <h3>{g.name}</h3>
      <p>"Will occur on:" {g.date}</p>
      <p>"Make sure to contact everyone before the event!"</p>
      {
        !eventsContext.groupParticipants ? "" : eventsContext.groupParticipants.map((part,i)=>
        <div>{renderParticipant(part,i)}</div>
        )
      }
    </>
  }

  return (
    <div>
      {group? renderGroup(group):""}
    </div>
  );
}


const Group = observer(({ context, eventsContext  }) => GroupComponent(context, eventsContext))
export default Group;