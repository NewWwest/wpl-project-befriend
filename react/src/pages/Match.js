import { React } from "react";
import { observer } from "mobx-react";
import Avatar  from "../components/Avatar";
import InterestList  from "../components/InterestList";

function MatchComponent(context){
  context.nextMatch();
  return (
    <>
    {context.matchingUser ?
      <div>
        <Avatar context={context} user={context.matchingUser}></Avatar>
        <InterestList interests={context.matchingUser?.interests}></InterestList>
        <button className="btn btn-warning d-inline-block ml-2 float-right" onClick={()=>context.reactMatch(context.matchingUser?.username, false)}>
          Next
        </button>
        <button className="btn btn-primary d-inline-block ml-2 float-right" onClick={()=>context.reactMatch(context.matchingUser?.username, true)}>
          Match
        </button>
      </div>
    :
    <div>
      No more users to match with :c {context.matchingUser}
    </div>
    }
    </>
  );
}


const Match = observer(({ context }) => MatchComponent(context))
export default Match;